#!/bin/bash

# Auto-Fix CI/CD Issues Script
# Usage: ./scripts/auto-fix-ci.sh

set -e

echo "🔧 Auto-Fix CI/CD Issues"
echo "========================"
echo ""

cd "$(dirname "$0")/.."

# Fix YAML formatting
echo "1️⃣ Fixing YAML formatting..."
find src/skills -name "SKILL.md" | while read file; do
    # Add spaces after commas in arrays
    sed -i.bak 's/\[wc\]/[ wc ]/g' "$file"
    sed -i.bak 's/\[\([^,]*\),\([^]]*\)\]/[ \1, \2 ]/g' "$file"
    rm -f "$file.bak"
done
echo "   ✅ YAML formatting fixed"
echo ""

# Fix Markdown formatting
echo "2️⃣ Fixing Markdown formatting..."
find src/skills -name "SKILL.md" | while read file; do
    # Remove trailing whitespace
    sed -i.bak 's/[[:space:]]*$//' "$file"
    rm -f "$file.bak"
    
    # Ensure single newline at end
    # Remove multiple trailing newlines
    sed -i.bak -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$file"
    # Add single newline
    echo "" >> "$file"
    rm -f "$file.bak"
done
echo "   ✅ Markdown formatting fixed"
echo ""

# Validate fixes
echo "3️⃣ Validating fixes..."
errors=0

for file in src/skills/*/SKILL.md; do
    # Check line count
    lines=$(wc -l < "$file")
    if [ "$lines" -gt 500 ]; then
        echo "   ❌ $file: $lines lines (> 500)"
        errors=$((errors + 1))
    fi
done

if [ $errors -gt 0 ]; then
    echo ""
    echo "❌ Validation failed: $errors file(s) still have issues"
    exit 1
fi

echo "   ✅ All validations passed"
echo ""

# Show summary
echo "========================"
echo "✅ Auto-fix completed!"
echo ""
echo "Next steps:"
echo "1. Review changes: git diff"
echo "2. Commit changes: git add . && git commit -m 'fix: auto-fix CI issues'"
echo "3. Push to remote: git push"
echo ""
