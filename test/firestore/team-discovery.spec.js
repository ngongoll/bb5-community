const { readFileSync } = require('fs');
const path = require('path');
const { initializeTestEnvironment, assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');

const projectId = 'demo-b5-community';
const rulesPath = path.resolve(__dirname, '../../firestore.rules');

const baseTeam = ({
  createdBy = 'owner-1',
  visibility = 'public',
  status = 'active',
  organizationType = 'team',
  name = 'Berlin Sluggers',
  description = 'Weekend training and community baseball for all levels.',
  city = 'Berlin',
  countryCode = 'DE',
  recruitingEnabled = true,
  createdAt = new Date(),
  updatedAt = new Date(),
} = {}) => ({
  name,
  description,
  city,
  countryCode,
  organizationType,
  visibility,
  recruitingEnabled,
  status,
  createdBy,
  createdAt,
  updatedAt,
});

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: {
      rules: readFileSync(rulesPath, 'utf8'),
      host: '127.0.0.1',
      port: 8088,
    },
  });
});

after(async () => {
  await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

describe('Firestore security rules for public team discovery', () => {
  const seedTeam = async (docId, teamData) => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await context.firestore().collection('teams').doc(docId).set(teamData);
    });
  };

  it('1. allows an unauthenticated user to read a public, active team', async () => {
    await seedTeam('public-team', baseTeam({ createdBy: 'owner-1' }));

    const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
    await assertSucceeds(unauthenticatedDb.collection('teams').doc('public-team').get());
  });

  it('2. allows an authenticated non-owner to read a public, active team', async () => {
    await seedTeam('public-team', baseTeam({ createdBy: 'owner-1' }));

    const otherUserDb = testEnv.authenticatedContext('user-2').firestore();
    await assertSucceeds(otherUserDb.collection('teams').doc('public-team').get());
  });

  it('3. denies an unauthenticated user reading a private team', async () => {
    await seedTeam(
      'private-team',
      baseTeam({
        createdBy: 'owner-1',
        visibility: 'private',
        status: 'active',
      }),
    );

    const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
    await assertFails(unauthenticatedDb.collection('teams').doc('private-team').get());
  });

  it('4. denies an authenticated non-owner reading a private team', async () => {
    await seedTeam(
      'private-team',
      baseTeam({
        createdBy: 'owner-1',
        visibility: 'private',
        status: 'active',
      }),
    );

    const otherUserDb = testEnv.authenticatedContext('user-2').firestore();
    await assertFails(otherUserDb.collection('teams').doc('private-team').get());
  });

  it('5. denies an unauthenticated user reading an inactive team', async () => {
    await seedTeam(
      'inactive-team',
      baseTeam({
        createdBy: 'owner-1',
        visibility: 'public',
        status: 'inactive',
      }),
    );

    const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
    await assertFails(unauthenticatedDb.collection('teams').doc('inactive-team').get());
  });

  it('6. allows an authenticated owner to read their own team', async () => {
    await seedTeam(
      'private-team',
      baseTeam({
        createdBy: 'owner-1',
        visibility: 'private',
        status: 'inactive',
      }),
    );

    const ownerDb = testEnv.authenticatedContext('owner-1').firestore();
    await assertSucceeds(ownerDb.collection('teams').doc('private-team').get());
  });

  it('7. denies an authenticated user from modifying or deleting another user\'s team', async () => {
    const ownerDb = testEnv.authenticatedContext('owner-1').firestore();
    await ownerDb.collection('teams').doc('public-team').set(baseTeam({ createdBy: 'owner-1' }));

    const otherUserDb = testEnv.authenticatedContext('user-2').firestore();
    await assertFails(
      otherUserDb.collection('teams').doc('public-team').update({
        description: 'malicious edit',
      }),
    );
    await assertFails(otherUserDb.collection('teams').doc('public-team').delete());
  });

  it('8. denies creating a team with another user\'s UID as createdBy', async () => {
    const loggedInDb = testEnv.authenticatedContext('owner-1').firestore();
    await assertFails(
      loggedInDb.collection('teams').doc('malicious-team').set(
        baseTeam({
          id: 'malicious-team',
          createdBy: 'owner-2',
        }),
      ),
    );
  });

  it('9. denies changing the createdBy field of an existing team', async () => {
    const ownerDb = testEnv.authenticatedContext('owner-1').firestore();
    await ownerDb.collection('teams').doc('public-team').set(baseTeam({ createdBy: 'owner-1' }));

    await assertFails(
      ownerDb.collection('teams').doc('public-team').update({ createdBy: 'owner-2' }),
    );
  });
});
