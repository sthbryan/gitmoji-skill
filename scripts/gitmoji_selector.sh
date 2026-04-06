#!/usr/bin/env bash
#===============================================================================
# Gitmoji Selector - Bash implementation
# Suggests appropriate gitmoji based on commit message analysis
# Universal: works on Linux, macOS, WSL (no dependencies required)
#===============================================================================

set -euo pipefail

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
    [[ "${DEBUG:-0}" == "1" ]] && echo "[DEBUG] $*" >&2
}

#-------------------------------------------------------------------------------
# Lowercase helper (portable)
#-------------------------------------------------------------------------------
lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

#-------------------------------------------------------------------------------
# Check if string contains substring (case-insensitive)
#-------------------------------------------------------------------------------
contains() {
    local text needle
    text=$(lowercase "$1")
    needle=$(lowercase "$2")
    [[ "$text" == *"$needle"* ]]
}

#-------------------------------------------------------------------------------
# Check for special commit types first
#-------------------------------------------------------------------------------
detect_special() {
    local msg="$1"
    local lower
    lower=$(lowercase "$msg")
    
    # Revert commits
    if contains "$msg" "revert"; then
        echo "$EMOJI_REVERT"
        return 0
    fi
    
    # Merge commits
    if contains "$msg" "merge"; then
        echo "$EMOJI_MERGE"
        return 0
    fi
    
    # Hotfix
    if contains "$msg" "hotfix"; then
        echo "$EMOJI_HOTFIX"
        return 0
    fi
    
    # WIP (Work in Progress)
    if [[ "$lower" == *"wip"* ]] || [[ "$lower" == *"work in progress"* ]]; then
        echo "$EMOJI_WIP"
        return 0
    fi
    
    # Squash / fixup commits
    if contains "$msg" "squash"; then
        echo "$EMOJI_WASTEBASKET"
        return 0
    fi
    
    return 1
}

#-------------------------------------------------------------------------------
# Detect simple/quick fixes (should return 🩹)
#-------------------------------------------------------------------------------
detect_simple_fix() {
    local msg="$1"
    local lower
    lower=$(lowercase "$msg")
    
    # Quick indicators that this is a simple fix
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
    
    for pattern in "${simple_patterns[@]}"; do
        if contains "$msg" "$pattern"; then
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
    
    # Security - HIGHEST PRIORITY
    local security_patterns=(
        "security" "vulnerability" "cve" "exploit"
        "xss" "csrf" "sql injection" "injection"
        "authentication bypass" "authorization" "auth bypass"
        "sensitive" "credentials" "secrets" "token"
        "patch security" "fix security" "security fix"
        "malicious" "attack" "breach"
    )
    
    for pattern in "${security_patterns[@]}"; do
        if contains "$msg" "$pattern"; then
            debug "Security priority: $pattern"
            echo "$EMOJI_LOCK"
            return 0
        fi
    done
    
    # Linter/ESLint warnings
    if contains "$msg" "linter" || contains "$msg" "eslint" || contains "$msg" "prettier"; then
        if contains "$msg" "fix" || contains "$msg" "warning" || contains "$msg" "error"; then
            echo "$EMOJI_WARNING"
            return 0
        fi
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
    
    #--------------------------------------------------------------------------
    # Feature (✨)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "feat" && ((score+=3))
    contains "$msg" "add" && ((score+=2))
    contains "$msg" "new" && ((score+=2))
    contains "$msg" "feature" && ((score+=3))
    contains "$msg" "introduce" && ((score+=2))
    contains "$msg" "implement" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_SPARKLES"
    fi
    
    #--------------------------------------------------------------------------
    # Bug fix (🐛)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "fix" && ((score+=3))
    contains "$msg" "bug" && ((score+=3))
    contains "$msg" "issue" && ((score+=1))
    contains "$msg" "defect" && ((score+=2))
    contains "$msg" "error" && ((score+=1))
    contains "$msg" "exception" && ((score+=2))
    contains "$msg" "crash" && ((score+=2))
    contains "$msg" "fail" && ((score+=1))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_BUG"
    fi
    
    #--------------------------------------------------------------------------
    # Documentation (📝)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "doc" && ((score+=3))
    contains "$msg" "docs" && ((score+=3))
    contains "$msg" "documentation" && ((score+=3))
    contains "$msg" "readme" && ((score+=5))
    contains "$msg" "guide" && ((score+=1))
    contains "$msg" "manual" && ((score+=1))
    contains "$msg" "changelog" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_MEMO"
    fi
    
    #--------------------------------------------------------------------------
    # Tests (🧪)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "test" && ((score+=3))
    contains "$msg" "spec" && ((score+=2))
    contains "$msg" "unit test" && ((score+=3))
    contains "$msg" "integration test" && ((score+=3))
    contains "$msg" "e2e" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_TEST"
    fi
    
    #--------------------------------------------------------------------------
    # Refactor (♻️)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "refactor" && ((score+=3))
    contains "$msg" "refactoring" && ((score+=3))
    contains "$msg" "restructure" && ((score+=2))
    contains "$msg" "reorganize" && ((score+=2))
    contains "$msg" "extract" && ((score+=1))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_RECYCLE"
    fi
    
    #--------------------------------------------------------------------------
    # Performance (⚡)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "perf" && ((score+=3))
    contains "$msg" "performance" && ((score+=3))
    contains "$msg" "optimize" && ((score+=3))
    contains "$msg" "speed" && ((score+=2))
    contains "$msg" "fast" && ((score+=1))
    contains "$msg" "efficient" && ((score+=2))
    contains "$msg" "caching" && ((score+=4))
    contains "$msg" "lazy" && ((score+=3))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_ZAP"
    fi
    
    #--------------------------------------------------------------------------
    # UI/Styles (💄)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "style" && ((score+=2))
    contains "$msg" "ui" && ((score+=2))
    contains "$msg" "css" && ((score+=2))
    contains "$msg" "design" && ((score+=1))
    contains "$msg" "theme" && ((score+=2))
    contains "$msg" "color" && ((score+=1))
    contains "$msg" "layout" && ((score+=2))
    contains "$msg" "responsive" && ((score+=2))
    contains "$msg" "font" && ((score+=2))
    contains "$msg" "icon" && ((score+=1))
    contains "$msg" "button" && ((score+=1))
    contains "$msg" "component" && ((score+=1))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_LIPSTICK"
    fi
    
    #--------------------------------------------------------------------------
    # Dependencies (📦)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "depend" && ((score+=3))
    contains "$msg" "package" && ((score+=2))
    contains "$msg" "npm" && ((score+=2))
    contains "$msg" "yarn" && ((score+=2))
    contains "$msg" "pip" && ((score+=2))
    contains "$msg" "gem" && ((score+=2))
    contains "$msg" "install" && ((score+=2))
    contains "$msg" "uninstall" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_PACKAGE"
    fi
    
    #--------------------------------------------------------------------------
    # Configuration (⚙️)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "config" && ((score+=3))
    contains "$msg" "setup" && ((score+=2))
    contains "$msg" "env" && ((score+=2))
    contains "$msg" "environment" && ((score+=2))
    contains "$msg" "build" && ((score+=1))
    contains "$msg" "webpack" && ((score+=2))
    contains "$msg" "babel" && ((score+=2))
    contains "$msg" "tsconfig" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_GEAR"
    fi
    
    #--------------------------------------------------------------------------
    # Major refactoring/rewrite (🔨)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "rewrite" && ((score+=3))
    contains "$msg" "rework" && ((score+=2))
    contains "$msg" "redesign" && ((score+=2))
    contains "$msg" "architect" && ((score+=5))
    contains "$msg" "migration" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_HAMMER"
    fi
    
    #--------------------------------------------------------------------------
    # Remove/Delete (🗑️)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "remove" && ((score+=3))
    contains "$msg" "delete" && ((score+=3))
    contains "$msg" "deprecat" && ((score+=3))
    contains "$msg" "cleanup" && ((score+=1))
    contains "$msg" "unused" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_WASTEBASKET"
    fi
    
    #--------------------------------------------------------------------------
    # Deploy (🚀)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "deploy" && ((score+=3))
    contains "$msg" "release" && ((score+=2))
    contains "$msg" "ship" && ((score+=2))
    contains "$msg" "staging" && ((score+=1))
    contains "$msg" "production" && ((score+=1))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_ROCKET"
    fi
    
    #--------------------------------------------------------------------------
    # SEO (🔍)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "seo" && ((score+=3))
    contains "$msg" "metadata" && ((score+=2))
    contains "$msg" "sitemap" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_MAG"
    fi
    
    #--------------------------------------------------------------------------
    # Translations (🗣️)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "translation" && ((score+=3))
    contains "$msg" "i18n" && ((score+=3))
    contains "$msg" "locale" && ((score+=2))
    contains "$msg" "language" && ((score+=2))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_LANG"
    fi
    
    #--------------------------------------------------------------------------
    # Analytics/Benchmarks (📈)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "analytics" && ((score+=3))
    contains "$msg" "metrics" && ((score+=2))
    contains "$msg" "dashboard" && ((score+=1))
    contains "$msg" "benchmark" && ((score+=3))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_CHART"
    fi
    
    #--------------------------------------------------------------------------
    # Automation (🔄)
    #--------------------------------------------------------------------------
    score=0
    contains "$msg" "automate" && ((score+=3))
    contains "$msg" "ci/cd" && ((score+=2))
    contains "$msg" "github" && ((score+=3))
    contains "$msg" "github action" && ((score+=4))
    contains "$msg" "workflow" && ((score+=1))
    
    if (( score > best_score )); then
        best_score=$score
        best_category="$EMOJI_REPEAT"
    fi
    
    #--------------------------------------------------------------------------
    # Return best match or default
    #--------------------------------------------------------------------------
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
    result=$(detect_special "$msg")
    if [[ -n "$result" ]]; then
        debug "Special: $result"
        echo "$result"
        return 0
    fi
    
    # 2. Priority cases (security, linter)
    result=$(detect_priority "$msg")
    if [[ -n "$result" ]]; then
        debug "Priority: $result"
        echo "$result"
        return 0
    fi
    
    # 3. Simple fixes (🩹)
    result=$(detect_simple_fix "$msg")
    if [[ -n "$result" ]]; then
        debug "Simple fix: $result"
        echo "$result"
        return 0
    fi
    
    # 4. Main category detection
    result=$(detect_category "$msg")
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
            --help|-h)
                echo "Usage: gitmoji_selector.sh [options] <message>"
                echo ""
                echo "Options:"
                echo "  --conventional, -c  Output in conventional commits format"
                echo "  --help, -h         Show this help"
                echo "  --debug            Enable debug output"
                echo ""
                echo "Examples:"
                echo "  gitmoji_selector.sh \"Add user authentication\""
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
    else
        if [[ -z "$message" ]]; then
            echo "Error: No message provided" >&2
            exit 1
        fi
        output_json "$message"
    fi
}

main "$@"
