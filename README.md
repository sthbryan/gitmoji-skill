# Gitmoji Commits

> Semantic commit messages with gitmoji emojis. No dependencies.

## Script Usage

```bash
# Auto-detect emoji from message
bash gitmoji_selector.sh "fix critical security bug"
# → 🔐

# Get emoji only (fast)
bash gitmoji_selector.sh --emoji-only "upgrade dependencies"
# → ⬆️

# Generate full commit message
bash gitmoji_selector.sh --conventional feat auth "Add login"
# → ✨ feat(auth): Add login

# Then commit
git add .
git commit -m "✨ feat(auth): Add login"
```

## Emoji Map

| Emoji | When to use |
|-------|-------------|
| ✨ | New feature |
| 🐛 | Bug fix |
| 🩹 | Quick fix (typo, one-liner) |
| 📝 | Documentation |
| 🧪 | Tests |
| ♻️ | Refactor |
| ⚡ | Performance |
| 💄 | UI/Styles |
| 📦 | Dependencies |
| 🔐 | Security |
| ⚙️ | Config |
| 🗑️ | Remove code |
| 🔨 | Major rewrite |
| 🚀 | Deploy |
| ⏪ | Revert |
| 🔀 | Merge |
| 🚑 | Hotfix |
| 🚧 | WIP |
| ✅ | Tests/build passing |
| ⬆️ | Upgrade dependencies |
| ⬇️ | Downgrade dependencies |
| 🔧 | Settings/config files |
| 🏷️ | Tags/types/version |
| 💬 | Copy/text changes |
| 💡 | Comments/notes |
| 🎭 | Mocks/stubs |

## Run Tests

```bash
bash scripts/test.sh
```

## Install skill

Install using the Skills CLI:
```bash
# Go to your project directory and run:
npx skills add https://github.com/sthbryan/gitmoji-skill --skill gitmoji-commits
```

or globally:
```bash
npx skills add https://github.com/sthbryan/gitmoji-skill --skill gitmoji-commits -g -y 
```