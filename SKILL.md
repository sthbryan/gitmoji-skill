---
name: gitmoji-commits
description: "Create semantic git commits with gitmoji. Stage only intended changes, suggest appropriate gitmojis via script, and write Conventional Commits messages. Trigger when user asks to commit, stage, split commits, or wants gitmoji support."
---

# Gitmoji Commits

## Workflow

1. **Inspect**: `git status && git diff --stat`
2. **Split**: Feature vs refactor vs docs vs tests vs config (use `git add -p` for mixed files)
3. **Detect emoji**: Run `bash scripts/gitmoji_selector.sh "<description>"` or consult reference
4. **Stage**: `git add <file>` or `git add -p`
5. **Verify**: No secrets, no debug logging, no unintended churn
6. **Commit**: `emoji type(scope): subject`

## Commit Format

```
✨ feat(auth): Add two-factor authentication

- Implement TOTP support
- Update user model

Closes #123
```

**Rules:**
- Subject: ≤50 chars, imperative mood
- Type: feat, fix, refactor, docs, test, perf, style, chore, ci, build
- Scope: feature area (auth, api, ui, db)

## Gitmoji Reference

| Type | Emoji | Keywords |
|------|-------|----------|
| Feature | ✨ | add, new, implement |
| Bug fix | 🐛 | fix, bug, error |
| Simple fix | 🩹 | typo, quick, one-liner, oops |
| Documentation | 📝 | doc, docs, readme |
| Tests | 🧪 | test, spec, integration |
| Refactor | ♻️ | refactor, extract, restructure |
| Performance | ⚡ | optimize, perf, cache, lazy |
| UI/Styles | 💄 | css, style, ui, design, theme |
| Dependencies | 📦 | npm, depend, package, install |
| Security | 🔐 | security, vulnerability, xss, cve |
| Config | ⚙️ | config, webpack, eslint, env |
| Remove | 🗑️ | remove, delete, deprecate |
| Major | 🔨 | rewrite, redesign, architect |
| Deploy | 🚀 | deploy, release, ship |
| SEO | 🔍 | seo, metadata |
| i18n | 🗣️ | translate, i18n, locale |
| Linter | 🚨 | eslint, prettier, lint |

## Special Cases (auto-detected)

| Emoji | When |
|-------|------|
| ⏪ | Revert commits |
| 🔀 | Merge commits |
| 🚑 | Hotfix |
| 🚧 | WIP |

## Helper Script

```bash
# Auto-detect emoji
bash scripts/gitmoji_selector.sh "fix critical bug"

# Conventional commits format
bash scripts/gitmoji_selector.sh --conventional feat auth "Add login"
```
