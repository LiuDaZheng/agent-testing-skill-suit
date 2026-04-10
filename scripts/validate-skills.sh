#!/bin/bash

# =============================================================================
# Skill Quality Validation Script
# =============================================================================
# Validates all SKILL.md files in the project for:
# - Line count (< 500 lines)
# - YAML frontmatter presence
# - Basic structure checks
#
# Usage: ./scripts/validate-skills.sh
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MAX_LINES=500
SKILL_DIR="src/skills"

# Counters
total_skills=0
passed_skills=0
failed_skills=0
warnings=0

echo "============================================================================="
echo "  Skill Quality Validation"
echo "============================================================================="
echo ""
echo "Configuration:"
echo "  - Max lines per skill: $MAX_LINES"
echo "  - Skill directory: $SKILL_DIR"
echo ""
echo "============================================================================="
echo ""

# Check if skill directory exists
if [ ! -d "$SKILL_DIR" ]; then
    echo -e "${RED}❌ Error: Skill directory '$SKILL_DIR' not found${NC}"
    exit 1
fi

# Find all SKILL.md files
skill_files=$(find "$SKILL_DIR" -name "SKILL.md" -type f | sort)

if [ -z "$skill_files" ]; then
    echo -e "${RED}❌ Error: No SKILL.md files found in $SKILL_DIR${NC}"
    exit 1
fi

# Process each skill file
for skill_file in $skill_files; do
    total_skills=$((total_skills + 1))
    skill_name=$(basename $(dirname "$skill_file"))
    has_errors=0
    has_warnings=0
    
    echo -e "${BLUE}Validating: $skill_name${NC}"
    
    # Check 1: Line count
    line_count=$(wc -l < "$skill_file")
    if [ "$line_count" -ge "$MAX_LINES" ]; then
        echo -e "  ${RED}❌ Line count: $line_count (>= $MAX_LINES)${NC}"
        has_errors=1
    else
        echo -e "  ${GREEN}✅ Line count: $line_count${NC}"
    fi
    
    # Check 2: YAML frontmatter
    first_line=$(head -n 1 "$skill_file")
    if [ "$first_line" != "---" ]; then
        echo -e "  ${RED}❌ YAML frontmatter: Missing (first line should be '---')${NC}"
        has_errors=1
    else
        # Check for closing ---
        closing_line=$(grep -n "^---$" "$skill_file" | sed -n '2p' | cut -d: -f1)
        if [ -z "$closing_line" ]; then
            echo -e "  ${RED}❌ YAML frontmatter: Incomplete (missing closing '---')${NC}"
            has_errors=1
        else
            echo -e "  ${GREEN}✅ YAML frontmatter: Present${NC}"
            
            # Extract and validate YAML content
            yaml_content=$(awk 'NR>1 && /^---$/{exit} NR>1' "$skill_file")
            
            # Check for required fields
            if ! echo "$yaml_content" | grep -q "^name:"; then
                echo -e "  ${YELLOW}⚠️  Warning: Missing 'name' field in frontmatter${NC}"
                has_warnings=1
            fi
            
            if ! echo "$yaml_content" | grep -q "^description:"; then
                echo -e "  ${YELLOW}⚠️  Warning: Missing 'description' field in frontmatter${NC}"
                has_warnings=1
            fi
        fi
    fi
    
    # Check 3: File size (cognitive load)
    file_size=$(wc -c < "$skill_file")
    if [ "$file_size" -gt 50000 ]; then
        echo -e "  ${YELLOW}⚠️  Warning: File size: $file_size bytes (> 50KB)${NC}"
        has_warnings=1
    else
        echo -e "  ${GREEN}✅ File size: $file_size bytes${NC}"
    fi
    
    # Update counters
    if [ "$has_errors" -eq 0 ]; then
        passed_skills=$((passed_skills + 1))
    else
        failed_skills=$((failed_skills + 1))
    fi
    
    if [ "$has_warnings" -gt 0 ]; then
        warnings=$((warnings + has_warnings))
    fi
    
    echo ""
done

# Print summary
echo "============================================================================="
echo "  Validation Summary"
echo "============================================================================="
echo ""
echo -e "Total Skills:      ${BLUE}$total_skills${NC}"
echo -e "Passed:            ${GREEN}$passed_skills${NC}"
echo -e "Failed:            ${RED}$failed_skills${NC}"
echo -e "Warnings:          ${YELLOW}$warnings${NC}"
echo ""

if [ "$failed_skills" -gt 0 ]; then
    echo -e "${RED}❌ Validation FAILED: $failed_skills skill(s) did not pass${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Validation PASSED: All $total_skills skill(s) meet quality standards${NC}"
    exit 0
fi
