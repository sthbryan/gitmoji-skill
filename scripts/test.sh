#!/usr/bin/env bash
#===============================================================================
# Gitmoji Selector Tests (fast path)
# Run: bash scripts/test.sh
#===============================================================================

set +e
cd "$(dirname "$0")/.."

# Source functions directly (much faster than spawning bash per test)
source scripts/gitmoji_selector.sh

echo "🧪 Testing gitmoji_selector.sh"
echo "=============================="

passed=0
failed=0

test_gitmoji() {
    local input="$1"
    local expected="$2"
    local result

    result=$(select_gitmoji "$input" 2>/dev/null)

    if [[ "$result" == "$expected" ]]; then
        echo "✅ $input"
        ((passed++))
    else
        echo "❌ $input"
        echo "   Got: $result, Expected: $expected"
        ((failed++))
    fi
}

test_conventional() {
    local type="$1"
    local scope="$2"
    local message="$3"
    local expected="$4"
    local result

    result=$(generate_conventional "$type" "$scope" "$message")

    if [[ "$result" == "$expected" ]]; then
        echo "✅ conventional: $type $scope $message"
        ((passed++))
    else
        echo "❌ conventional: $type $scope $message"
        echo "   Got: $result"
        echo "   Expected: $expected"
        ((failed++))
    fi
}

test_cli_error() {
    local cmd="$1"
    local label="$2"

    eval "$cmd" >/dev/null 2>&1
    local code=$?

    if [[ $code -ne 0 ]]; then
        echo "✅ $label"
        ((passed++))
    else
        echo "❌ $label"
        echo "   Expected non-zero exit code"
        ((failed++))
    fi
}

# Special cases
test_gitmoji "revert auth module" "⏪"
test_gitmoji "merge feature/auth" "🔀"
test_gitmoji "hotfix for crash" "🚑"
test_gitmoji "wip: adding feature" "🚧"

# Priority
test_gitmoji "fix XSS vulnerability" "🔐"
test_gitmoji "patch security issue" "🔐"
test_gitmoji "CVE-2024 security fix" "🔐"
test_gitmoji "fix ESLint warnings" "🚨"
test_gitmoji "all tests passing in CI" "✅"

# Simple fixes
test_gitmoji "fix typo" "🩹"
test_gitmoji "quick fix" "🩹"
test_gitmoji "oops mistake" "🩹"

# Core categories
test_gitmoji "fix critical bug" "🐛"
test_gitmoji "add user auth" "✨"
test_gitmoji "update docs" "📝"
test_gitmoji "add unit tests" "🧪"
test_gitmoji "refactor database" "♻️"
test_gitmoji "optimize queries" "⚡"
test_gitmoji "update button CSS" "💄"
test_gitmoji "add npm package" "📦"
test_gitmoji "update webpack config" "⚙️"
test_gitmoji "rewrite auth system" "🔨"
test_gitmoji "remove deprecated API" "🗑️"
test_gitmoji "deploy to production" "🚀"
test_gitmoji "improve SEO" "🔍"
test_gitmoji "add Spanish translations" "🗣️"
test_gitmoji "add analytics" "📈"
test_gitmoji "setup GitHub Actions workflow" "🔄"

# Added auto-detect emojis
test_gitmoji "upgrade dependencies" "⬆️"
test_gitmoji "bump package version" "⬆️"
test_gitmoji "downgrade dependency version" "⬇️"
test_gitmoji "rollback version of dependency" "⬇️"
test_gitmoji "update app settings" "🔧"
test_gitmoji "tune runtime settings" "🔧"
test_gitmoji "add types for api" "🏷️"
test_gitmoji "add type definitions" "🏷️"
test_gitmoji "update copy text" "💬"
test_gitmoji "change user-facing strings" "💬"
test_gitmoji "add inline comments" "💡"
test_gitmoji "add TODO note in code" "💡"
test_gitmoji "add API mocks" "🎭"
test_gitmoji "mock payment gateway in tests" "🎭"

# Priority/conflict regression tests
test_gitmoji "fix security bug in auth" "🔐"
test_gitmoji "revert security patch" "⏪"
test_gitmoji "hotfix security vulnerability" "🚑"
test_gitmoji "merge docs update" "🔀"

# CLI smoke tests (keep minimal)
echo ""
echo "📋 Testing CLI modes"

result=$(bash scripts/gitmoji_selector.sh --emoji-only "fix typo")
if [[ "$result" == "🩹" ]]; then
    echo "✅ --emoji-only works"
    ((passed++))
else
    echo "❌ --emoji-only failed"
    echo "   Got: $result"
    ((failed++))
fi

test_conventional "feat" "auth" "Add login" "✨ feat(auth): Add login"
test_conventional "fix" "" "Resolve crash" "🐛 fix: Resolve crash"

# CLI error handling
test_cli_error "bash scripts/gitmoji_selector.sh" "CLI fails without message"
test_cli_error "bash scripts/gitmoji_selector.sh --conventional feat" "CLI fails with incomplete --conventional"

echo ""
echo "=============================="
echo "Results: $passed passed, $failed failed"

if [[ $failed -eq 0 ]]; then
    echo "🎉 All tests passed!"
    exit 0
else
    echo "❌ Some tests failed"
    exit 1
fi
