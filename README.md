# Gitmoji Commits

> Semantic commit messages with gitmoji emojis. No dependencies.

## Install

```bash
# Download and chmod
curl -O https://raw.githubusercontent.com/YOUR_USER/gitmoji-skill/main/scripts/gitmoji_selector.sh
chmod +x gitmoji_selector.sh

# Or clone
git clone https://github.com/YOUR_USER/gitmoji-skill.git
```

## Usage

```bash
# Auto-detect emoji from message
bash gitmoji_selector.sh "fix critical security bug"
# → 🔐

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

## Run Tests

```bash
bash scripts/test.sh
```

## As AI Agent Skill

Install in Claude Code:
```bash
npx skills add https://github.com/YOUR_USER/gitmoji-skill --skill gitmoji-commits
```
