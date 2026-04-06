#!/usr/bin/env bash
#===============================================================================
# Gitmoji Selector Tests
# Run: bash scripts/test.sh
#===============================================================================

set +e  # Don't exit on failed assertions

cd "$(dirname "$0")/.."

echo "🧪 Testing gitmoji_selector.sh"
echo "=============================="

passed=0
failed=0

test_gitmoji() {
    local input="$1"
    local expected="$2"
    local result
    
    result=$(bash scripts/gitmoji_selector.sh "$input" 2>/dev/null | grep -o "\"emoji\": \"[^\"]*\"" | cut -d'"' -f4)
    
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

# Security (priority)
test_gitmoji "fix XSS vulnerability" "🔐"
test_gitmoji "patch security issue" "🔐"
test_gitmoji "CVE-2024 security fix" "🔐"

# Simple fixes
test_gitmoji "fix typo" "🩹"
test_gitmoji "quick fix" "🩹"
test_gitmoji "oops mistake" "🩹"
test_gitmoji "one-liner fix" "🩹"
test_gitmoji "formatting fix" "🩹"

# Bug fixes
test_gitmoji "fix null pointer" "🐛"
test_gitmoji "fix critical bug" "🐛"

# Features
test_gitmoji "add user auth" "✨"
test_gitmoji "new feature dark mode" "✨"

# Refactor
test_gitmoji "refactor database" "♻️"
test_gitmoji "extract helper" "♻️"

# Performance
test_gitmoji "optimize queries" "⚡"
test_gitmoji "add caching" "⚡"
test_gitmoji "add lazy loading" "⚡"

# Documentation
test_gitmoji "update docs" "📝"
test_gitmoji "add README" "📝"

# Tests
test_gitmoji "add unit tests" "🧪"
test_gitmoji "add integration tests" "🧪"

# UI/Styles
test_gitmoji "update button CSS" "💄"
test_gitmoji "add responsive design" "💄"

# Dependencies
test_gitmoji "add npm package" "📦"
test_gitmoji "update dependencies" "📦"

# Config
test_gitmoji "update webpack config" "⚙️"
test_gitmoji "setup CI/CD" "⚙️"

# Major
test_gitmoji "rewrite auth system" "🔨"
test_gitmoji "architect new system" "🔨"

# Remove
test_gitmoji "remove deprecated API" "🗑️"
test_gitmoji "delete unused files" "🗑️"

# Deploy
test_gitmoji "deploy to production" "🚀"
test_gitmoji "release v2.0" "🚀"

# Others
test_gitmoji "fix ESLint warnings" "🚨"
test_gitmoji "improve SEO" "🔍"
test_gitmoji "add Spanish translations" "🗣️"
test_gitmoji "add analytics" "📈"
test_gitmoji "setup GitHub Actions" "🔄"

# Conventional mode
echo ""
echo "📋 Testing --conventional mode"
result=$(bash scripts/gitmoji_selector.sh --conventional feat auth "Add login")
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
