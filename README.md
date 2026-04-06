# Gitmoji Commits

Semantic commits with gitmoji emojis.

## Quick Start

```bash
# Get emoji suggestion
bash scripts/gitmoji_selector.sh "add user authentication"
# Output: ✨

# Conventional commits format
bash scripts/gitmoji_selector.sh --conventional feat auth "Add login"
# Output: ✨ feat(auth): Add login

# Commit workflow
git add .
git commit -m "✨ feat(auth): Add login"
```

## Gitmoji Reference

✨ Feature | 🐛 Bug fix | 🩹 Simple fix | 📝 Docs | 🧪 Tests
♻️ Refactor | ⚡ Performance | 💄 UI/Styles | 📦 Deps | 🔐 Security
⚙️ Config | 🗑️ Remove | 🔨 Major | 🚀 Deploy

See `references/gitmoji-guide.md` for full reference.

## Files

- `SKILL.md` — Skill definition
- `scripts/gitmoji_selector.sh` — Emoji selector (bash, no deps)
- `references/gitmoji-guide.md` — Complete reference
- `scripts/test.sh` — Run tests
