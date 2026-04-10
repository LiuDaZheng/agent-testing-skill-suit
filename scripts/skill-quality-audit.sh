#!/bin/bash
# Skill 质量审计脚本
# 检查 Skill 是否符合 OpenClaw 规范

SKILL_DIR="$1"
REPORT_FILE="$2"

if [ -z "$SKILL_DIR" ]; then
    echo "用法：$0 <skill-directory> [report-file]"
    exit 1
fi

# 初始化报告
if [ -n "$REPORT_FILE" ]; then
    echo "# Skill 质量审计报告" > "$REPORT_FILE"
    echo "**审计日期**: $(date '+%Y-%m-%d %H:%M')" >> "$REPORT_FILE"
    echo "**审计对象**: $SKILL_DIR" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

echo "开始审计：$SKILL_DIR"
echo ""

# 检查项
ISSUES=0
WARNINGS=0

# 1. 检查 SKILL.md 是否存在
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    echo "✅ SKILL.md 存在"
    [ -n "$REPORT_FILE" ] && echo "✅ SKILL.md 存在" >> "$REPORT_FILE"
    
    # 2. 检查文件大小
    SIZE=$(wc -c < "$SKILL_DIR/SKILL.md")
    LINES=$(wc -l < "$SKILL_DIR/SKILL.md")
    
    echo "📊 文件大小：$SIZE bytes, $LINES 行"
    [ -n "$REPORT_FILE" ] && echo "📊 文件大小：$SIZE bytes, $LINES 行" >> "$REPORT_FILE"
    
    if [ $SIZE -gt 4000 ]; then
        echo "⚠️  警告：文件超过 4000 字符 ($SIZE)"
        [ -n "$REPORT_FILE" ] && echo "⚠️  警告：文件超过 4000 字符 ($SIZE)" >> "$REPORT_FILE"
        ((WARNINGS++))
    fi
    
    if [ $LINES -gt 500 ]; then
        echo "⚠️  警告：文件超过 500 行 ($LINES)"
        [ -n "$REPORT_FILE" ] && echo "⚠️  警告：文件超过 500 行 ($LINES)" >> "$REPORT_FILE"
        ((WARNINGS++))
    fi
    
    # 3. 检查 YAML frontmatter
    if head -1 "$SKILL_DIR/SKILL.md" | grep -q "^---"; then
        echo "✅ YAML frontmatter 存在"
        [ -n "$REPORT_FILE" ] && echo "✅ YAML frontmatter 存在" >> "$REPORT_FILE"
        
        # 检查必需字段
        if grep -q "^name:" "$SKILL_DIR/SKILL.md"; then
            echo "✅ name 字段存在"
            [ -n "$REPORT_FILE" ] && echo "✅ name 字段存在" >> "$REPORT_FILE"
        else
            echo "❌ 错误：缺少 name 字段"
            [ -n "$REPORT_FILE" ] && echo "❌ 错误：缺少 name 字段" >> "$REPORT_FILE"
            ((ISSUES++))
        fi
        
        if grep -q "^description:" "$SKILL_DIR/SKILL.md"; then
            echo "✅ description 字段存在"
            [ -n "$REPORT_FILE" ] && echo "✅ description 字段存在" >> "$REPORT_FILE"
            
            # 检查描述长度
            DESC=$(grep "^description:" "$SKILL_DIR/SKILL.md" | sed 's/^description: *//')
            DESC_LEN=${#DESC}
            if [ $DESC_LEN -gt 100 ]; then
                echo "⚠️  警告：description 超过 100 字符 ($DESC_LEN)"
                [ -n "$REPORT_FILE" ] && echo "⚠️  警告：description 超过 100 字符 ($DESC_LEN)" >> "$REPORT_FILE"
                ((WARNINGS++))
            fi
        else
            echo "❌ 错误：缺少 description 字段"
            [ -n "$REPORT_FILE" ] && echo "❌ 错误：缺少 description 字段" >> "$REPORT_FILE"
            ((ISSUES++))
        fi
    else
        echo "❌ 错误：缺少 YAML frontmatter"
        [ -n "$REPORT_FILE" ] && echo "❌ 错误：缺少 YAML frontmatter" >> "$REPORT_FILE"
        ((ISSUES++))
    fi
    
    # 4. 检查 references 目录
    if [ -d "$SKILL_DIR/references" ]; then
        REF_COUNT=$(find "$SKILL_DIR/references" -type f -name "*.md" | wc -l)
        echo "✅ references 目录存在 ($REF_COUNT 个文件)"
        [ -n "$REPORT_FILE" ] && echo "✅ references 目录存在 ($REF_COUNT 个文件)" >> "$REPORT_FILE"
    else
        echo "⚠️  警告：缺少 references 目录"
        [ -n "$REPORT_FILE" ] && echo "⚠️  警告：缺少 references 目录" >> "$REPORT_FILE"
        ((WARNINGS++))
    fi
    
    # 5. 检查使用示例
    EXAMPLE_COUNT=$(grep -c "示例" "$SKILL_DIR/SKILL.md" || echo "0")
    if [ $EXAMPLE_COUNT -ge 3 ]; then
        echo "✅ 包含足够的示例 (检测到 $EXAMPLE_COUNT 个)"
        [ -n "$REPORT_FILE" ] && echo "✅ 包含足够的示例 (检测到 $EXAMPLE_COUNT 个)" >> "$REPORT_FILE"
    else
        echo "⚠️  警告：示例数量不足 (检测到 $EXAMPLE_COUNT 个，建议至少 3 个)"
        [ -n "$REPORT_FILE" ] && echo "⚠️  警告：示例数量不足 (检测到 $EXAMPLE_COUNT 个，建议至少 3 个)" >> "$REPORT_FILE"
        ((WARNINGS++))
    fi
    
    # 6. 检查参考资料
    if grep -qi "参考" "$SKILL_DIR/SKILL.md" || grep -qi "reference" "$SKILL_DIR/SKILL.md" || grep -q "https://" "$SKILL_DIR/SKILL.md"; then
        echo "✅ 包含参考资料"
        [ -n "$REPORT_FILE" ] && echo "✅ 包含参考资料" >> "$REPORT_FILE"
    else
        echo "⚠️  警告：缺少参考资料"
        [ -n "$REPORT_FILE" ] && echo "⚠️  警告：缺少参考资料" >> "$REPORT_FILE"
        ((WARNINGS++))
    fi
    
    # 7. 安全检查 (敏感信息)
    if grep -qiE "api_key|api-key|secret|password|token|credential" "$SKILL_DIR/SKILL.md" | grep -vqi "示例" || true; then
        echo "⚠️  警告：可能包含敏感关键词 (需人工审查)"
        [ -n "$REPORT_FILE" ] && echo "⚠️  警告：可能包含敏感关键词 (需人工审查)" >> "$REPORT_FILE"
        ((WARNINGS++))
    else
        echo "✅ 未检测到明显敏感信息"
        [ -n "$REPORT_FILE" ] && echo "✅ 未检测到明显敏感信息" >> "$REPORT_FILE"
    fi
    
else
    echo "❌ 错误：SKILL.md 不存在"
    [ -n "$REPORT_FILE" ] && echo "❌ 错误：SKILL.md 不存在" >> "$REPORT_FILE"
    ((ISSUES++))
fi

echo ""
echo "================================"
echo "审计结果总结"
echo "================================"
echo "❌ 问题数：$ISSUES"
echo "⚠️  警告数：$WARNINGS"

if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ 审计通过 - 优秀!"
    STATUS="PASS"
elif [ $ISSUES -eq 0 ]; then
    echo "✅ 审计通过 (有警告)"
    STATUS="PASS_WITH_WARNINGS"
else
    echo "❌ 审计失败 - 需要修复"
    STATUS="FAIL"
fi

[ -n "$REPORT_FILE" ] && echo "" >> "$REPORT_FILE"
[ -n "$REPORT_FILE" ] && echo "================================" >> "$REPORT_FILE"
[ -n "$REPORT_FILE" ] && echo "审计结果总结" >> "$REPORT_FILE"
[ -n "$REPORT_FILE" ] && echo "================================" >> "$REPORT_FILE"
[ -n "$REPORT_FILE" ] && echo "❌ 问题数：$ISSUES" >> "$REPORT_FILE"
[ -n "$REPORT_FILE" ] && echo "⚠️  警告数：$WARNINGS" >> "$REPORT_FILE"
[ -n "$REPORT_FILE" ] && echo "状态：$STATUS" >> "$REPORT_FILE"

# 返回状态码
if [ $ISSUES -gt 0 ]; then
    exit 1
else
    exit 0
fi
