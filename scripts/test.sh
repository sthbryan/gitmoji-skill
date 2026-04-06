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
test_gitmoji "downgrade dependency version" "⬇️"
test_gitmoji "update app settings" "🔧"
test_gitmoji "add types for api" "🏷️"
test_gitmoji "update copy text" "💬"
test_gitmoji "add inline comments" "💡"
test_gitmoji "add API mocks" "🎭"

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

result=$(generate_conventional "feat" "auth" "Add login")
if [[ "$result" == "✨ feat(auth): Add login" ]]; then
    echo "✅ Conventional format works"
    ((passed++))
else
    echo "❌ Conventional format failed"
    echo "   Got: $result"
    ((failed++))
fi

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
