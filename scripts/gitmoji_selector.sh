#!/usr/bin/env bash
#===============================================================================
# Gitmoji Selector - Bash implementation
# Suggests appropriate gitmoji based on commit message analysis
# Universal: works on Linux, macOS, WSL (no dependencies required)
#===============================================================================

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    set -euo pipefail
fi

# Emoji constants
EMOJI_SPARKLES="✨"      # New feature
EMOJI_BUG="🐛"           # Bug fix
EMOJI_MEMO="📝"          # Documentation
EMOJI_TEST="🧪"          # Tests
EMOJI_RECYCLE="♻️"        # Refactor
EMOJI_ZAP="⚡"            # Performance
EMOJI_LIPSTICK="💄"       # UI/Styles
EMOJI_PACKAGE="📦"        # Dependencies
EMOJI_LOCK="🔐"           # Security
EMOJI_GEAR="⚙️"           # Configuration
EMOJI_WASTEBASKET="🗑️"    # Remove/Delete
EMOJI_BROOM="🧹"          # Clean up
EMOJI_HAMMER="🔨"         # Major refactoring
EMOJI_ROCKET="🚀"         # Deploy
EMOJI_ADHESIVE_BANDAGE="🩹"  # Simple fix
EMOJI_REVERT="⏪"         # Revert
EMOJI_MERGE="🔀"          # Merge
EMOJI_HOTFIX="🚑"         # Hotfix
EMOJI_WIP="🚧"            # Work in progress
EMOJI_BOOKS="📚"          # Docs files
EMOJI_SPEECH="💬"         # Comments
EMOJI_LANG="🗣️"          # Translations
EMOJI_MAG="🔍"           # SEO
EMOJI_BULB="💡"           # Ideas
EMOJI_PERFORM="🎭"        # Mock
EMOJI_WARNING="🚨"        # Linter warnings
EMOJI_ARROW_UP="⬆️"       # Upgrade deps
EMOJI_ARROW_DOWN="⬇️"     # Downgrade deps
EMOJI_LABEL="🏷️"         # Release/Tag
EMOJI_CHART="📈"          # Analytics/Benchmarks
EMOJI_CHECK="✅"          # Tests passing
EMOJI_WRENCH="🔧"         # Config files
EMOJI_REPEAT="🔄"         # Automation

#-------------------------------------------------------------------------------
# Logging functions (debug mode)
#-------------------------------------------------------------------------------
debug() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo "[DEBUG] $*" >&2
    fi
    return 0
}

#-------------------------------------------------------------------------------
# Lowercase helper (portable)
#-------------------------------------------------------------------------------
lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

#-------------------------------------------------------------------------------
# Check if a lowercased string contains a substring
#-------------------------------------------------------------------------------
contains_lc() {
    [[ "$1" == *"$2"* ]]
}

#-------------------------------------------------------------------------------
# Check for special commit types first
#-------------------------------------------------------------------------------
detect_special() {
    local msg="$1"
    local lower
    lower=$(lowercase "$msg")

    contains_lc "$lower" "revert" && { echo "$EMOJI_REVERT"; return 0; }
    contains_lc "$lower" "merge" && { echo "$EMOJI_MERGE"; return 0; }
    contains_lc "$lower" "hotfix" && { echo "$EMOJI_HOTFIX"; return 0; }
    (contains_lc "$lower" "wip" || contains_lc "$lower" "work in progress") && { echo "$EMOJI_WIP"; return 0; }
    contains_lc "$lower" "squash" && { echo "$EMOJI_WASTEBASKET"; return 0; }

    return 1
}

#-------------------------------------------------------------------------------
# Detect simple/quick fixes (🩹)
#-------------------------------------------------------------------------------
detect_simple_fix() {
    local msg="$1"
    local lower
    lower=$(lowercase "$msg")

    local simple_patterns=(
        "typo" "typo:" "typo fix"
        "fix typo" "fix a typo"
        "fix small" "quick fix" "simple fix"
        "one-liner" "one liner" "oneliner"
        "minor fix" "trivial fix"
        "oops" "oops:" "oopsie"
        "mistake" "silly"
        "formatting" "fmt" "whitespace"
    )

    local pattern
    for pattern in "${simple_patterns[@]}"; do
        if contains_lc "$lower" "$pattern"; then
            debug "Simple fix detected: $pattern"
            echo "$EMOJI_ADHESIVE_BANDAGE"
            return 0
        fi
    done

    return 1
}

#-------------------------------------------------------------------------------
# Priority detection - Security always wins
#-------------------------------------------------------------------------------
detect_priority() {
    local msg="$1"
    local lower
    lower=$(lowercase "$msg")

    local security_patterns=(
        "security" "vulnerability" "cve" "exploit"
        "xss" "csrf" "sql injection" "injection"
        "authentication bypass" "authorization" "auth bypass"
        "sensitive" "credentials" "secrets" "token"
        "patch security" "fix security" "security fix"
        "malicious" "attack" "breach"
    )

    local pattern
    for pattern in "${security_patterns[@]}"; do
        if contains_lc "$lower" "$pattern"; then
            debug "Security priority: $pattern"
            echo "$EMOJI_LOCK"
            return 0
        fi
    done

    # Linter/ESLint warnings
    if (contains_lc "$lower" "linter" || contains_lc "$lower" "eslint" || contains_lc "$lower" "prettier") \
       && (contains_lc "$lower" "fix" || contains_lc "$lower" "warning" || contains_lc "$lower" "error"); then
        echo "$EMOJI_WARNING"
        return 0
    fi

    # Explicit test pass/build pass
    if (contains_lc "$lower" "tests passing" || contains_lc "$lower" "all tests pass" || contains_lc "$lower" "green build" || contains_lc "$lower" "build passing"); then
        echo "$EMOJI_CHECK"
        return 0
    fi

    return 1
}

#-------------------------------------------------------------------------------
# Main category detection with scoring
#-------------------------------------------------------------------------------
detect_category() {
    local msg="$1"
    local lower
    lower=$(lowercase "$msg")
    local score=0
    local best_category=""
    local best_score=0

    # Feature (✨)
    score=0
    contains_lc "$lower" "feat" && ((score+=3))
    contains_lc "$lower" "add" && ((score+=2))
    contains_lc "$lower" "new" && ((score+=2))
    contains_lc "$lower" "feature" && ((score+=3))
    contains_lc "$lower" "introduce" && ((score+=2))
    contains_lc "$lower" "implement" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_SPARKLES"; }

    # Bug fix (🐛)
    score=0
    contains_lc "$lower" "fix" && ((score+=3))
    contains_lc "$lower" "bug" && ((score+=3))
    contains_lc "$lower" "issue" && ((score+=1))
    contains_lc "$lower" "defect" && ((score+=2))
    contains_lc "$lower" "error" && ((score+=1))
    contains_lc "$lower" "exception" && ((score+=2))
    contains_lc "$lower" "crash" && ((score+=2))
    contains_lc "$lower" "fail" && ((score+=1))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_BUG"; }

    # Documentation (📝 / 📚)
    score=0
    contains_lc "$lower" "doc" && ((score+=3))
    contains_lc "$lower" "docs" && ((score+=3))
    contains_lc "$lower" "documentation" && ((score+=3))
    contains_lc "$lower" "readme" && ((score+=5))
    contains_lc "$lower" "guide" && ((score+=1))
    contains_lc "$lower" "manual" && ((score+=1))
    contains_lc "$lower" "changelog" && ((score+=2))
    contains_lc "$lower" ".md" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_MEMO"; }

    # Tests (🧪)
    score=0
    contains_lc "$lower" "test" && ((score+=3))
    contains_lc "$lower" "spec" && ((score+=2))
    contains_lc "$lower" "unit test" && ((score+=3))
    contains_lc "$lower" "integration test" && ((score+=3))
    contains_lc "$lower" "e2e" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_TEST"; }

    # Refactor (♻️)
    score=0
    contains_lc "$lower" "refactor" && ((score+=3))
    contains_lc "$lower" "refactoring" && ((score+=3))
    contains_lc "$lower" "restructure" && ((score+=2))
    contains_lc "$lower" "reorganize" && ((score+=2))
    contains_lc "$lower" "extract" && ((score+=1))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_RECYCLE"; }

    # Performance (⚡)
    score=0
    contains_lc "$lower" "perf" && ((score+=3))
    contains_lc "$lower" "performance" && ((score+=3))
    contains_lc "$lower" "optimize" && ((score+=3))
    contains_lc "$lower" "speed" && ((score+=2))
    contains_lc "$lower" "fast" && ((score+=1))
    contains_lc "$lower" "efficient" && ((score+=2))
    contains_lc "$lower" "caching" && ((score+=4))
    contains_lc "$lower" "lazy" && ((score+=3))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_ZAP"; }

    # UI/Styles (💄)
    score=0
    contains_lc "$lower" "style" && ((score+=2))
    contains_lc "$lower" "ui" && ((score+=2))
    contains_lc "$lower" "css" && ((score+=2))
    contains_lc "$lower" "design" && ((score+=1))
    contains_lc "$lower" "theme" && ((score+=2))
    contains_lc "$lower" "color" && ((score+=1))
    contains_lc "$lower" "layout" && ((score+=2))
    contains_lc "$lower" "responsive" && ((score+=2))
    contains_lc "$lower" "font" && ((score+=2))
    contains_lc "$lower" "icon" && ((score+=1))
    contains_lc "$lower" "button" && ((score+=1))
    contains_lc "$lower" "component" && ((score+=1))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_LIPSTICK"; }

    # Dependency direction (⬆️ / ⬇️ / 📦)
    score=0
    (contains_lc "$lower" "upgrade" || contains_lc "$lower" "bump") && ((score+=4))
    (contains_lc "$lower" "dependency" || contains_lc "$lower" "dependencies" || contains_lc "$lower" "package") && ((score+=3))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_ARROW_UP"; }

    score=0
    (contains_lc "$lower" "downgrade" || contains_lc "$lower" "rollback version") && ((score+=5))
    (contains_lc "$lower" "dependency" || contains_lc "$lower" "dependencies" || contains_lc "$lower" "package") && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_ARROW_DOWN"; }

    score=0
    contains_lc "$lower" "depend" && ((score+=3))
    contains_lc "$lower" "package" && ((score+=2))
    contains_lc "$lower" "npm" && ((score+=2))
    contains_lc "$lower" "yarn" && ((score+=2))
    contains_lc "$lower" "pip" && ((score+=2))
    contains_lc "$lower" "gem" && ((score+=2))
    contains_lc "$lower" "install" && ((score+=2))
    contains_lc "$lower" "uninstall" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_PACKAGE"; }
    
    # Configuration (⚙️ / 🔧)
    score=0
    contains_lc "$lower" "config" && ((score+=3))
    contains_lc "$lower" "setup" && ((score+=2))
    contains_lc "$lower" "env" && ((score+=2))
    contains_lc "$lower" "environment" && ((score+=2))
    contains_lc "$lower" "build" && ((score+=1))
    contains_lc "$lower" "webpack" && ((score+=2))
    contains_lc "$lower" "babel" && ((score+=2))
    contains_lc "$lower" "tsconfig" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_GEAR"; }

    score=0
    contains_lc "$lower" "settings" && ((score+=3))
    contains_lc "$lower" ".env" && ((score+=3))
    contains_lc "$lower" "properties" && ((score+=2))
    contains_lc "$lower" "ini" && ((score+=1))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_WRENCH"; }

    # Release / tags / types (🏷️)
    score=0
    contains_lc "$lower" "tag" && ((score+=3))
    contains_lc "$lower" "version" && ((score+=2))
    contains_lc "$lower" "types" && ((score+=4))
    contains_lc "$lower" "type definition" && ((score+=4))
    contains_lc "$lower" "type" && ((score+=2))
    contains_lc "$lower" "typedef" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_LABEL"; }

    # Major refactoring/rewrite (🔨)
    score=0
    contains_lc "$lower" "rewrite" && ((score+=3))
    contains_lc "$lower" "rework" && ((score+=2))
    contains_lc "$lower" "redesign" && ((score+=2))
    contains_lc "$lower" "architect" && ((score+=5))
    contains_lc "$lower" "migration" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_HAMMER"; }

    # Remove/Delete (🗑️)
    score=0
    contains_lc "$lower" "remove" && ((score+=3))
    contains_lc "$lower" "delete" && ((score+=3))
    contains_lc "$lower" "deprecat" && ((score+=3))
    contains_lc "$lower" "cleanup" && ((score+=1))
    contains_lc "$lower" "unused" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_WASTEBASKET"; }

    # Deploy (🚀)
    score=0
    contains_lc "$lower" "deploy" && ((score+=3))
    contains_lc "$lower" "release" && ((score+=2))
    contains_lc "$lower" "ship" && ((score+=2))
    contains_lc "$lower" "staging" && ((score+=1))
    contains_lc "$lower" "production" && ((score+=1))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_ROCKET"; }

    # SEO (🔍)
    score=0
    contains_lc "$lower" "seo" && ((score+=3))
    contains_lc "$lower" "metadata" && ((score+=2))
    contains_lc "$lower" "sitemap" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_MAG"; }

    # Translations (🗣️)
    score=0
    contains_lc "$lower" "translation" && ((score+=3))
    contains_lc "$lower" "i18n" && ((score+=3))
    contains_lc "$lower" "locale" && ((score+=2))
    contains_lc "$lower" "language" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_LANG"; }

    # Text / copy / comments (💬 / 💡)
    score=0
    contains_lc "$lower" "copy" && ((score+=3))
    contains_lc "$lower" "text" && ((score+=2))
    contains_lc "$lower" "string" && ((score+=2))
    contains_lc "$lower" "message" && ((score+=1))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_SPEECH"; }

    score=0
    contains_lc "$lower" "comment" && ((score+=3))
    contains_lc "$lower" "note" && ((score+=2))
    contains_lc "$lower" "todo" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_BULB"; }

    # Mocks (🎭)
    score=0
    contains_lc "$lower" "mock" && ((score+=4))
    contains_lc "$lower" "stub" && ((score+=3))
    contains_lc "$lower" "fake" && ((score+=2))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_PERFORM"; }

    # Analytics/Benchmarks (📈)
    score=0
    contains_lc "$lower" "analytics" && ((score+=3))
    contains_lc "$lower" "metrics" && ((score+=2))
    contains_lc "$lower" "dashboard" && ((score+=1))
    contains_lc "$lower" "benchmark" && ((score+=3))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_CHART"; }

    # Automation (🔄)
    score=0
    contains_lc "$lower" "automate" && ((score+=3))
    contains_lc "$lower" "ci/cd" && ((score+=2))
    contains_lc "$lower" "github" && ((score+=3))
    contains_lc "$lower" "github action" && ((score+=4))
    contains_lc "$lower" "workflow" && ((score+=1))
    (( score > best_score )) && { best_score=$score; best_category="$EMOJI_REPEAT"; }

    if [[ -n "$best_category" ]] && (( best_score > 0 )); then
        debug "Best category: $best_category (score: $best_score)"
        echo "$best_category"
        return 0
    fi

    return 1
}

#-------------------------------------------------------------------------------
# Main selector function
#-------------------------------------------------------------------------------
select_gitmoji() {
    local msg="${1:-}"
    
    if [[ -z "$msg" ]]; then
        echo "Error: No message provided" >&2
        return 1
    fi
    
    debug "Input: $msg"
    
    # 1. Special commits (highest priority)
    local result
    result=$(detect_special "$msg" || true)
    if [[ -n "$result" ]]; then
        debug "Special: $result"
        echo "$result"
        return 0
    fi
    
    # 2. Priority cases (security, linter)
    result=$(detect_priority "$msg" || true)
    if [[ -n "$result" ]]; then
        debug "Priority: $result"
        echo "$result"
        return 0
    fi
    
    # 3. Simple fixes (🩹)
    result=$(detect_simple_fix "$msg" || true)
    if [[ -n "$result" ]]; then
        debug "Simple fix: $result"
        echo "$result"
        return 0
    fi
    
    # 4. Main category detection
    result=$(detect_category "$msg" || true)
    if [[ -n "$result" ]]; then
        debug "Category: $result"
        echo "$result"
        return 0
    fi
    
    # 5. Default fallback
    debug "Default: ✨"
    echo "$EMOJI_SPARKLES"
}

#-------------------------------------------------------------------------------
# Generate conventional commits format
#-------------------------------------------------------------------------------
generate_conventional() {
    local type="${1:-}"
    local scope="${2:-}"
    local message="${3:-}"
    
    local emoji
    emoji=$(select_gitmoji "$type $message")
    
    local scope_str=""
    [[ -n "$scope" ]] && scope_str="($scope)"
    
    echo "$emoji $type$scope_str: $message"
}

#-------------------------------------------------------------------------------
# JSON output
#-------------------------------------------------------------------------------
output_json() {
    local msg="$1"
    local emoji
    emoji=$(select_gitmoji "$msg")
    
    # Get emoji name
    local emoji_name
    case "$emoji" in
        "$EMOJI_SPARKLES") emoji_name="sparkles" ;;
        "$EMOJI_BUG") emoji_name="bug" ;;
        "$EMOJI_MEMO") emoji_name="memo" ;;
        "$EMOJI_TEST") emoji_name="test_tube" ;;
        "$EMOJI_RECYCLE") emoji_name="recycle" ;;
        "$EMOJI_ZAP") emoji_name="zap" ;;
        "$EMOJI_LIPSTICK") emoji_name="lipstick" ;;
        "$EMOJI_PACKAGE") emoji_name="package" ;;
        "$EMOJI_LOCK") emoji_name="lock" ;;
        "$EMOJI_GEAR") emoji_name="gear" ;;
        "$EMOJI_WRENCH") emoji_name="wrench" ;;
        "$EMOJI_LABEL") emoji_name="label" ;;
        "$EMOJI_SPEECH") emoji_name="speech_balloon" ;;
        "$EMOJI_BULB") emoji_name="bulb" ;;
        "$EMOJI_PERFORM") emoji_name="performing_arts" ;;
        "$EMOJI_ARROW_UP") emoji_name="arrow_up" ;;
        "$EMOJI_ARROW_DOWN") emoji_name="arrow_down" ;;
        "$EMOJI_CHECK") emoji_name="white_check_mark" ;;
        "$EMOJI_WASTEBASKET") emoji_name="wastebasket" ;;
        "$EMOJI_BROOM") emoji_name="broom" ;;
        "$EMOJI_HAMMER") emoji_name="hammer" ;;
        "$EMOJI_ROCKET") emoji_name="rocket" ;;
        "$EMOJI_ADHESIVE_BANDAGE") emoji_name="adhesive_bandage" ;;
        "$EMOJI_REVERT") emoji_name="revert" ;;
        "$EMOJI_MERGE") emoji_name="merge" ;;
        "$EMOJI_HOTFIX") emoji_name="hotfix" ;;
        "$EMOJI_WIP") emoji_name="construction" ;;
        "$EMOJI_WARNING") emoji_name="rotating_light" ;;
        *) emoji_name="sparkles" ;;
    esac
    
    cat <<EOF
{
  "emoji": "$emoji",
  "emoji_name": "$emoji_name",
  "suggested_format": "$emoji $msg"
}
EOF
}

#-------------------------------------------------------------------------------
# CLI Entry Point
#-------------------------------------------------------------------------------
main() {
    local mode="auto"
    local type=""
    local scope=""
    local message=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --conventional|-c)
                mode="conventional"
                ;;
            --emoji-only|-e)
                mode="emoji"
                ;;
            --help|-h)
                echo "Usage: gitmoji_selector.sh [options] <message>"
                echo ""
                echo "Options:"
                echo "  --conventional, -c  Output in conventional commits format"
                echo "  --emoji-only, -e    Output only emoji"
                echo "  --help, -h          Show this help"
                echo "  --debug             Enable debug output"
                echo ""
                echo "Examples:"
                echo "  gitmoji_selector.sh \"Add user authentication\""
                echo "  gitmoji_selector.sh --emoji-only \"fix typo\""
                echo "  gitmoji_selector.sh --conventional feat auth \"Add login\""
                exit 0
                ;;
            --debug)
                DEBUG=1
                ;;
            *)
                if [[ "$mode" == "conventional" ]]; then
                    if [[ -z "$type" ]]; then
                        type="$1"
                    elif [[ -z "$scope" ]]; then
                        scope="$1"
                    else
                        message="$1"
                    fi
                else
                    message="$1"
                fi
                ;;
        esac
        shift
    done
    
    if [[ "$mode" == "conventional" ]]; then
        if [[ -z "$type" ]] || [[ -z "$message" ]]; then
            echo "Error: --conventional requires type and message" >&2
            exit 1
        fi
        generate_conventional "$type" "$scope" "$message"
        return
    fi

    if [[ -z "$message" ]]; then
        echo "Error: No message provided" >&2
        exit 1
    fi

    if [[ "$mode" == "emoji" ]]; then
        select_gitmoji "$message"
    else
        output_json "$message"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
