#!/usr/bin/env python3
"""
Skill 质量审计工具
审计维度：结构完整性、文档质量、Token 效率、优化建议
"""

import os
import re
import json
from pathlib import Path
from datetime import datetime

# 审计配置
SKILLS_DIR = Path.home() / ".openclaw" / "workspace-skilldev" / "Agent-Testing-Skill-Suit" / "src" / "skills"
OUTPUT_DIR = Path.home() / ".openclaw" / "workspace-skilldev" / "Agent-Testing-Skill-Suit" / "docs"

# 评分权重
WEIGHTS = {
    "structure": 0.20,      # 结构完整性
    "documentation": 0.25,  # 文档质量
    "examples": 0.20,       # 示例质量
    "efficiency": 0.20,     # Token 效率
    "completeness": 0.15,   # 完整性
}

# 必需字段
REQUIRED_FIELDS = ["name", "description"]

# 质量阈值
THRESHOLDS = {
    "excellent": 90,
    "good": 75,
    "acceptable": 60,
    "poor": 0,
}


def parse_yaml_frontmatter(content):
    """解析 YAML 前置内容"""
    match = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
    if not match:
        return None
    
    yaml_str = match.group(1)
    metadata = {}
    
    for line in yaml_str.split('\n'):
        line = line.strip()
        if ':' in line and not line.startswith('#'):
            key, value = line.split(':', 1)
            metadata[key.strip()] = value.strip().strip('"\'')
    
    return metadata


def count_examples(content):
    """统计示例数量"""
    # 匹配"示例"、"Example"、"用例"等
    patterns = [r'###?\s*示例', r'###?\s*Example', r'```', r'## TC-']
    count = 0
    for pattern in patterns:
        count += len(re.findall(pattern, content, re.IGNORECASE))
    return max(1, count // 3)  # 粗略估算


def estimate_tokens(content):
    """估算 Token 数量（中文字符≈1.5 tokens，英文字符≈0.25 tokens）"""
    chinese_chars = len(re.findall(r'[\u4e00-\u9fff]', content))
    english_chars = len(re.findall(r'[a-zA-Z]', content))
    code_blocks = len(re.findall(r'```', content)) * 50  # 代码块估算
    
    return int(chinese_chars * 1.5 + english_chars * 0.25 + code_blocks)


def audit_skill(skill_path):
    """审计单个 Skill"""
    with open(skill_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 1. 结构完整性 (0-100)
    structure_score = 0
    metadata = parse_yaml_frontmatter(content)
    
    if metadata:
        structure_score += 40  # 有 YAML 前置
        if 'name' in metadata:
            structure_score += 20
        if 'description' in metadata:
            structure_score += 20
        if 'metadata' in str(metadata) or 'references' in str(metadata):
            structure_score += 20
    else:
        # 检查是否有基本结构
        if '# ' in content:
            structure_score += 40
    
    # 2. 文档质量 (0-100)
    doc_score = 0
    sections = [
        r'##\s*角色定位', r'##\s*核心', r'##\s*使用',
        r'##\s*流程', r'##\s*验收', r'##\s*参考'
    ]
    for section in sections:
        if re.search(section, content, re.IGNORECASE):
            doc_score += 16
    doc_score = min(100, doc_score)
    
    # 3. 示例质量 (0-100)
    example_count = count_examples(content)
    example_score = min(100, example_count * 10)  # 每个示例 10 分，最多 100
    
    # 4. Token 效率 (0-100)
    token_count = estimate_tokens(content)
    # 理想范围：1000-5000 tokens
    if 1000 <= token_count <= 5000:
        efficiency_score = 100
    elif token_count < 1000:
        efficiency_score = 80  # 可能太简略
    elif token_count <= 8000:
        efficiency_score = 90
    else:
        efficiency_score = max(50, 100 - (token_count - 8000) // 500)
    
    # 5. 完整性 (0-100)
    completeness_score = 0
    checklist_items = [
        r'验收.*清单', r'检查.*清单', r'Entry Criteria', r'Exit Criteria',
        r'使用.*示例', r'参考.*资料'
    ]
    for item in checklist_items:
        if re.search(item, content, re.IGNORECASE):
            completeness_score += 16
    completeness_score = min(100, completeness_score)
    
    # 计算加权总分
    total_score = (
        structure_score * WEIGHTS["structure"] +
        doc_score * WEIGHTS["documentation"] +
        example_score * WEIGHTS["examples"] +
        efficiency_score * WEIGHTS["efficiency"] +
        completeness_score * WEIGHTS["completeness"]
    )
    
    # 确定等级
    if total_score >= THRESHOLDS["excellent"]:
        grade = "A"
    elif total_score >= THRESHOLDS["good"]:
        grade = "B"
    elif total_score >= THRESHOLDS["acceptable"]:
        grade = "C"
    else:
        grade = "D"
    
    return {
        "name": skill_path.parent.name,
        "file": str(skill_path),
        "scores": {
            "structure": structure_score,
            "documentation": doc_score,
            "examples": example_score,
            "efficiency": efficiency_score,
            "completeness": completeness_score,
            "total": round(total_score, 1),
        },
        "grade": grade,
        "tokens": token_count,
        "lines": len(content.split('\n')),
        "metadata": metadata is not None,
    }


def generate_recommendations(audit_result):
    """生成改进建议"""
    recommendations = []
    scores = audit_result["scores"]
    
    if scores["structure"] < 80:
        recommendations.append("📐 添加/完善 YAML 前置元数据（name, description, metadata）")
    
    if scores["documentation"] < 80:
        recommendations.append("📝 补充核心章节（角色定位、使用场景、工作流程）")
    
    if scores["examples"] < 80:
        recommendations.append("💡 增加使用示例（目标：5+ 个可执行示例）")
    
    if scores["efficiency"] < 80:
        recommendations.append("⚡ 优化内容长度，移除冗余描述")
    
    if scores["completeness"] < 80:
        recommendations.append("✅ 添加验收清单和参考资料")
    
    if not recommendations:
        recommendations.append("✨ 质量优秀，保持当前标准")
    
    return recommendations


def generate_report(audit_results):
    """生成审计报告"""
    report = []
    
    # 标题
    report.append("# 🔍 Skill 质量审计报告")
    report.append(f"\n**生成时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report.append(f"**审计范围**: {len(audit_results)} 个 Skill")
    report.append(f"**项目位置**: `~/.openclaw/workspace-skilldev/Agent-Testing-Skill-Suit/src/skills/`")
    report.append("")
    
    # 总体统计
    total_scores = [r["scores"]["total"] for r in audit_results]
    avg_score = sum(total_scores) / len(total_scores)
    grade_distribution = {}
    for r in audit_results:
        grade = r["grade"]
        grade_distribution[grade] = grade_distribution.get(grade, 0) + 1
    
    report.append("## 📊 总体统计")
    report.append("")
    report.append(f"- **平均分数**: {avg_score:.1f}/100")
    report.append(f"- **最高分数**: {max(total_scores):.1f}")
    report.append(f"- **最低分数**: {min(total_scores):.1f}")
    report.append(f"- **总 Token 数**: {sum(r['tokens'] for r in audit_results):,}")
    report.append(f"- **总行数**: {sum(r['lines'] for r in audit_results):,}")
    report.append("")
    
    report.append("### 等级分布")
    report.append("")
    report.append("| 等级 | 数量 | 占比 |")
    report.append("|------|------|------|")
    for grade in ["A", "B", "C", "D"]:
        count = grade_distribution.get(grade, 0)
        pct = count / len(audit_results) * 100
        report.append(f"| {grade} | {count} | {pct:.1f}% |")
    report.append("")
    
    # 详细评分
    report.append("## 📋 详细评分")
    report.append("")
    report.append("| Skill 名称 | 结构 | 文档 | 示例 | 效率 | 完整性 | 总分 | 等级 | Token |")
    report.append("|-----------|------|------|------|------|--------|------|------|-------|")
    
    # 按分数排序
    sorted_results = sorted(audit_results, key=lambda x: x["scores"]["total"], reverse=True)
    
    for r in sorted_results:
        s = r["scores"]
        report.append(
            f"| {r['name']} | {s['structure']:.0f} | {s['documentation']:.0f} | "
            f"{s['examples']:.0f} | {s['efficiency']:.0f} | {s['completeness']:.0f} | "
            f"**{s['total']:.1f}** | {r['grade']} | {r['tokens']:,} |"
        )
    report.append("")
    
    # 优化建议
    report.append("## 💡 优化建议")
    report.append("")
    
    # 按等级分组建议
    for grade in ["A", "B", "C", "D"]:
        grade_results = [r for r in sorted_results if r["grade"] == grade]
        if grade_results:
            report.append(f"### {grade} 级 Skill ({len(grade_results)}个)")
            report.append("")
            for r in grade_results:
                recommendations = generate_recommendations(r)
                report.append(f"**{r['name']}**:")
                for rec in recommendations:
                    report.append(f"- {rec}")
                report.append("")
    
    # Token 效率分析
    report.append("## ⚡ Token 效率分析")
    report.append("")
    
    high_token_skills = [r for r in sorted_results if r["tokens"] > 8000]
    low_token_skills = [r for r in sorted_results if r["tokens"] < 1000]
    
    if high_token_skills:
        report.append("### ⚠️ Token 数过高（>8000）")
        report.append("")
        for r in high_token_skills:
            report.append(f"- {r['name']}: {r['tokens']:,} tokens - 建议精简内容")
        report.append("")
    
    if low_token_skills:
        report.append("### ℹ️ Token 数过低（<1000）")
        report.append("")
        for r in low_token_skills:
            report.append(f"- {r['name']}: {r['tokens']:,} tokens - 可能内容不足")
        report.append("")
    
    # 最佳实践
    report.append("## 🏆 最佳实践示例")
    report.append("")
    top_skills = sorted_results[:3]
    report.append("以下 Skill 在质量审计中表现优异：")
    report.append("")
    for i, r in enumerate(top_skills, 1):
        report.append(f"**{i}. {r['name']}** (总分：{r['scores']['total']:.1f})")
        report.append(f"- 文件：`{r['file']}`")
        report.append(f"- Token: {r['tokens']:,} | 行数：{r['lines']:,}")
        report.append("")
    
    # 改进行动计划
    report.append("## 📅 改进行动计划")
    report.append("")
    report.append("### 优先级 1 - 立即改进（D 级 Skill）")
    d_grade = [r for r in sorted_results if r["grade"] == "D"]
    if d_grade:
        for r in d_grade:
            report.append(f"- [ ] {r['name']}: 重点改进 {generate_recommendations(r)[0]}")
    else:
        report.append("- ✅ 无 D 级 Skill")
    report.append("")
    
    report.append("### 优先级 2 - 近期改进（C 级 Skill）")
    c_grade = [r for r in sorted_results if r["grade"] == "C"]
    if c_grade:
        for r in c_grade:
            report.append(f"- [ ] {r['name']}: {generate_recommendations(r)[0]}")
    else:
        report.append("- ✅ 无 C 级 Skill")
    report.append("")
    
    report.append("### 优先级 3 - 持续优化（B 级 Skill）")
    b_grade = [r for r in sorted_results if r["grade"] == "B"]
    if b_grade:
        report.append(f"- 共 {len(b_grade)} 个 B 级 Skill，建议逐步提升至 A 级")
    else:
        report.append("- ✅ 无 B 级 Skill")
    report.append("")
    
    report.append("---")
    report.append("")
    report.append("*审计报告由 agent-audit 技能生成 | 基于 ISTQB 和 OpenClaw Skill 规范*")
    
    return "\n".join(report)


def main():
    """主函数"""
    print("🔍 开始 Skill 质量审计...\n")
    
    # 查找所有 SKILL.md 文件
    skill_files = list(SKILLS_DIR.glob("*/SKILL.md"))
    print(f"📁 找到 {len(skill_files)} 个 Skill 文件\n")
    
    # 审计每个 Skill
    audit_results = []
    for skill_file in skill_files:
        print(f"  审计中：{skill_file.parent.name}...")
        result = audit_skill(skill_file)
        audit_results.append(result)
    
    print(f"\n✅ 审计完成，生成报告...\n")
    
    # 生成报告
    report = generate_report(audit_results)
    
    # 保存报告
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    report_path = OUTPUT_DIR / "quality-audit-report.md"
    
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"📄 报告已保存：{report_path}")
    print(f"\n📊 总体统计:")
    total_scores = [r["scores"]["total"] for r in audit_results]
    print(f"   平均分数：{sum(total_scores)/len(total_scores):.1f}/100")
    print(f"   最高分数：{max(total_scores):.1f}")
    print(f"   最低分数：{min(total_scores):.1f}")
    
    # 打印等级分布
    grade_dist = {}
    for r in audit_results:
        grade_dist[r["grade"]] = grade_dist.get(r["grade"], 0) + 1
    print(f"\n   等级分布：{grade_dist}")


if __name__ == "__main__":
    main()
