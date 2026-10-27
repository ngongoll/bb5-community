# Baseball5 Copilot Development Skill

A small instruction pack for developing the Baseball5 Community App with Flutter and Firebase.

## Contents
- `AGENTS.md`: project-wide engineering rules.
- `.github/copilot-instructions.md`: repository-wide GitHub Copilot guidance.
- `.github/skills/baseball5-flutter-firebase/SKILL.md`: task-oriented development skill.

## Install
Copy the files and directories into the root of your Git repository, preserving the paths.

```text
your-repo/
├── AGENTS.md
└── .github/
    ├── copilot-instructions.md
    └── skills/
        └── baseball5-flutter-firebase/
            └── SKILL.md
```

## How to use with GitHub Copilot
1. Open the repository in VS Code.
2. Confirm that the instruction files are present in the repository.
3. In Copilot Chat, ask for a task and explicitly mention the skill when useful, for example:
   `Read AGENTS.md and .github/skills/baseball5-flutter-firebase/SKILL.md. Implement the user profile model and repository only. Inspect the current project first, add tests, and do not deploy anything.`
4. Review every diff, especially Firebase Security Rules, access control, and schema changes.
5. Run tests and inspect Firebase Emulator results before deployment.

## Important
These files guide Copilot; they do not guarantee that every instruction is automatically loaded in every editor or chat mode. Check your current GitHub Copilot version and repository support. Never rely on prompts alone for security: enforce authorization in Firebase Security Rules and trusted backend code.
