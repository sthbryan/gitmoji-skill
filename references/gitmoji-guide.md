# Gitmoji Guide

Complete reference with all 71 gitmoji.dev emojis.

## Core Emojis (in script)

These are auto-detected by `gitmoji_selector.sh`:

| Emoji | Code | Use |
|-------|------|-----|
| ✨ | sparkles | New feature |
| 🐛 | bug | Bug fix |
| 🩹 | adhesive_bandage | Simple fix (typo, one-liner) |
| 📝 | memo | Documentation |
| 🧪 | test_tube | Tests |
| ♻️ | recycle | Refactor |
| ⚡ | zap | Performance |
| 💄 | lipstick | UI/Styles |
| 📦 | package | Dependencies |
| 🔐 | lock | Security |
| ⚙️ | gear | Config/Setup |
| 🔧 | wrench | Config files |
| 🗑️ | wastebasket | Remove/Delete |
| 🔨 | hammer | Major refactor/scripts |
| 🚀 | rocket | Deploy |
| ⏪ | rewind | Revert |
| 🔀 | twisted_rightwards_arrows | Merge |
| 🚑 | ambulance | Hotfix |
| 🚧 | construction | WIP |
| 📚 | books | Docs files |
| 💬 | speech_balloon | Comments/text |
| 🗣️ | speaking_head | Translations |
| 🔍 | mag | SEO |
| 💡 | bulb | Comments/ideas |
| 🎭 | performing_arts | Mock |
| 🚨 | rotating_light | Linter |
| ⬆️ | arrow_up | Upgrade deps |
| ⬇️ | arrow_down | Downgrade deps |
| 🏷️ | label | Types/Tags |
| 📈 | chart_with_upwards_trend | Analytics |
| ✅ | white_check_mark | Tests passing |
| 🔄 | repeat | Automation |
| 🧹 | broom | Cleanup |

## Extended Reference (manual use)

Use these for specific cases (not auto-detected):

### Structure & Format
| Emoji | Code | Use |
|-------|------|-----|
| 🎨 | art | Structure/format changes |

### Project & Release
| Emoji | Code | Use |
|-------|------|-----|
| 🎉 | tada | Begin project |
| 🔖 | bookmark | Release tags |
| 💥 | boom | Breaking changes |

### Security & Secrets
| Emoji | Code | Use |
|-------|------|-----|
| 🔒 | lock | Security/privacy issues |
| 👽 | alien | External API changes |

### CI/CD & Build
| Emoji | Code | Use |
|-------|------|-----|
| 👷 | construction_worker | CI build system |
| 💚 | green_heart | CI build passing |

### Dependencies
| Emoji | Code | Use |
|-------|------|-----|
| ➕ | heavy_plus_sign | Add dependency |
| ➖ | heavy_minus_sign | Remove dependency |
| 📌 | pushpin | Pin deps to versions |

### Code Quality
| Emoji | Code | Use |
|-------|------|-----|
| 🔥 | fire | Remove code/files |
| ⚰️ | coffin | Remove dead code |
| 💩 | poop | Bad code that needs improvement |
| 🍻 | beers | Drunk code |
| 🧐 | monocle_face | Data exploration/inspection |

### Database & Data
| Emoji | Code | Use |
|-------|------|-----|
| 🗃️ | card_file_box | Database changes |
| 🌱 | seedling | Seed files |

### UI & UX
| Emoji | Code | Use |
|-------|------|-----|
| 📱 | iphone | Responsive design |
| ♿️ | wheelchair | Accessibility |
| 🚸 | children_crossing | UX/usability |
| 💫 | dizzy | Animations/transitions |

### Infrastructure & DevOps
| Emoji | Code | Use |
|-------|------|-----|
| 🧱 | bricks | Infrastructure |
| 🛂 | passport_control | Auth/roles/permissions |
| 🩺 | stethoscope | Healthcheck |
| ✈️ | airplane | Offline support |

### Business & Logic
| Emoji | Code | Use |
|-------|------|-----|
| 👔 | necktie | Business logic |
| 🦺 | safety_vest | Validation |
| 🥅 | goal_net | Catch errors |
| 🧑‍💻 | technologist | Developer experience |
| 💸 | money_with_wings | Sponsorships |

### Code Structure
| Emoji | Code | Use |
|-------|------|-----|
| 🧵 | thread | Multithreading/concurrency |
| 🏗️ | building_construction | Architecture |
| 🦖 | t-rex | Backwards compatibility |

### Assets & Files
| Emoji | Code | Use |
|-------|------|-----|
| 🍱 | bento | Assets |
| 📸 | camera_flash | Snapshots |
| 📄 | page_facing_up | License |

### Meta
| Emoji | Code | Use |
|-------|------|-----|
| 👥 | busts_in_silhouette | Contributors |
| 🚩 | triangular_flag_on_post | Feature flags |
| ⚗️ | alembic | Experiments |
| 🥚 | egg | Easter egg |
| 🙈 | see_no_evil | .gitignore |
| 🤡 | clown_face | Mock things |

### Logs
| Emoji | Code | Use |
|-------|------|-----|
| 🔊 | loud_sound | Add logs |
| 🔇 | mute | Remove logs |

## Selection Priority

When selecting, check in this order:

1. **Special**: revert → ⏪, merge → 🔀, hotfix → 🚑, wip → 🚧
2. **Critical** (always wins): security → 🔐
3. **Simple fix**: typo, quick, one-liner → 🩹
4. **Main category**: feat, bug, docs, test, refactor, perf, etc.

## Simple vs Bug Fix

- **🩹 Simple** (trivial): typo, one-liner, quick, formatting
- **🐛 Bug** (real problem): null pointer, crash, logic error

## Format

```
emoji type(scope): subject

Body if needed.

Closes #123
```
