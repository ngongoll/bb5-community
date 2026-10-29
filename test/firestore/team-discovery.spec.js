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

const baseActivity = ({
  organizerId = 'owner-1',
  visibility = 'public',
  status = 'active',
  type = 'training',
  title = 'Evening training',
  description = 'Baseball5 practice for all skill levels.',
  city = 'Berlin',
  locationName = 'Tempelhofer Feld',
  startAt = new Date(Date.now() + 3600000),
  endAt = new Date(Date.now() + 7200000),
  participantLimit = 12,
  createdAt = new Date(),
  updatedAt = new Date(),
  teamId = null,
} = {}) => ({
  organizerId,
  visibility,
  status,
  type,
  title,
  description,
  city,
  locationName,
  startAt,
  endAt,
  participantLimit,
  createdAt,
  updatedAt,
  ...(teamId ? { teamId } : {}),
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

  const seedActivity = async (docId, activityData) => {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      await context.firestore().collection('activities').doc(docId).set(activityData);
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

  it('10. allows unauthenticated users to read a public, active activity', async () => {
    await seedActivity('public-activity', baseActivity({ organizerId: 'owner-1' }));

    const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
    await assertSucceeds(unauthenticatedDb.collection('activities').doc('public-activity').get());
  });

  it('11. denies unauthenticated users from reading a private activity', async () => {
    await seedActivity(
      'private-activity',
      baseActivity({
        organizerId: 'owner-1',
        visibility: 'private',
      }),
    );

    const unauthenticatedDb = testEnv.unauthenticatedContext().firestore();
    await assertFails(unauthenticatedDb.collection('activities').doc('private-activity').get());
  });

  it('12. allows a signed-in organizer to create an activity for themselves', async () => {
    const ownerDb = testEnv.authenticatedContext('owner-1').firestore();
    await assertSucceeds(
      ownerDb.collection('activities').doc('new-activity').set(baseActivity({ organizerId: 'owner-1' })),
    );
  });

  it('13. denies creating an activity for another user', async () => {
    const otherUserDb = testEnv.authenticatedContext('owner-1').firestore();
    await assertFails(
      otherUserDb.collection('activities').doc('malicious-activity').set(
        baseActivity({ organizerId: 'owner-2' }),
      ),
    );
  });

  it('14. allows the organizer to update their activity and denies another user from updating it', async () => {
    const ownerDb = testEnv.authenticatedContext('owner-1').firestore();
    await ownerDb.collection('activities').doc('owned-activity').set(
      baseActivity({ organizerId: 'owner-1', title: 'Original session' }),
    );

    await assertSucceeds(
      ownerDb.collection('activities').doc('owned-activity').update({ title: 'Updated session' }),
    );

    const otherUserDb = testEnv.authenticatedContext('owner-2').firestore();
    await assertFails(
      otherUserDb.collection('activities').doc('owned-activity').update({ title: 'Malicious change' }),
    );
  });

  it('15. allows a user to register for an activity and prevents cross-user spoofing', async () => {
    const ownerDb = testEnv.authenticatedContext('owner-1').firestore();
    await ownerDb.collection('activities').doc('activity-to-register').set(
      baseActivity({ organizerId: 'owner-1' }),
    );

    const userDb = testEnv.authenticatedContext('user-1').firestore();
    await assertSucceeds(
      userDb
        .collection('activities')
        .doc('activity-to-register')
        .collection('registrations')
        .doc('user-1')
        .set({ userId: 'user-1', status: 'registered', registeredAt: new Date() }),
    );

    const otherUserDb = testEnv.authenticatedContext('user-2').firestore();
    await assertFails(
      otherUserDb
        .collection('activities')
        .doc('activity-to-register')
        .collection('registrations')
        .doc('user-1')
        .set({ userId: 'user-1', status: 'registered', registeredAt: new Date() }),
    );
  });
});
