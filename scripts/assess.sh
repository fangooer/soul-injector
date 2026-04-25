#!/bin/bash
# ============================================================
#  Soul Injector - 升级评估引擎
# ============================================================
#
#  Author: Fangooer Team
#  Contact: fangooer@163.com
#  Copyright: © 2026 Fangooer Team
#  License: MIT
#  Version: 1.0.0
#
#  Description: 8 维度扫描 Agent 状态，智能生成 3 套升级方案
#
#  扫描维度:
#   1. 灵魂定位 (SOUL.md)
#   2. 预写日志协议 (SESSION-STATE.md)
#   3. 记忆系统 (MEMORY.md + working-buffer)
#   4. 安全配置 (skill-vetter + 三层防御)
#   5. 技能管理 (SKILL_REGISTRY.md)
#   6. 心跳机制 (HEARTBEAT.md)
#   7. 工具配置 (TOOLS.md)
#   8. 用户画像 (USER.md)
#
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[0;35m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# 全局变量初始化（脚本开头即初始化，确保所有函数都能访问
SCORE_TOTAL=0
MAX_SCORE=100
RESULTS=()

# 评分函数
check_dimension() {
    local TARGET_DIR="$1"
    local name="$2"
    local file="$3"
    local desc="$4"
    local weight="$5"

    echo -n "  🔍 检查 $name... "

    if [ -f "$TARGET_DIR/$file" ]; then
        # 检查文件内容是否有实质内容
        local line_count
        line_count=$(wc -l < "$TARGET_DIR/$file" 2>/dev/null || echo "0")
        if [ -s "$TARGET_DIR/$file" ] && [ "$line_count" -gt 5 ]; then
            SCORE_TOTAL=$((SCORE_TOTAL + weight))
            echo -e "${GREEN}✅ 已配置 (${weight}分)${NC}"
            RESULTS+=("✅ $name: $desc - 已配置")
        else
            echo -e "${YELLOW}⚠️  文件存在但内容为空${NC}"
            RESULTS+=("⚠️  $name: $desc - 文件存在但需补充内容")
        fi
    else
        echo -e "${RED}❌ 未配置${NC}"
        RESULTS+=("❌ $name: $desc - 未配置")
    fi
    # 总是返回0，避免 set -e 模式下脚本退出（未配置不是错误，只是评估结果）
    return 0
}

# 检查记忆系统（特殊检查）
check_memory_system() {
    local TARGET_DIR="$1"
    local name="📚 记忆系统"
    local desc="MEMORY.md + working-buffer + 向量库支持"
    local weight=15
    local score=0

    echo -n "  🔍 检查 $name... "

    if [ -f "$TARGET_DIR/MEMORY.md" ] && [ -s "$TARGET_DIR/MEMORY.md" ]; then
        score=$((score + 8))
    fi

    if [ -d "$TARGET_DIR/memory" ] || [ -f "$TARGET_DIR/memory/working-buffer.md" ]; then
        score=$((score + 4))
    fi

    # 检查是否有向量库记忆文件（扩展检测）
    if [ -d "$TARGET_DIR/memory/vectors" ] || grep -q "lance\|weaviate\|pinecone" "$TARGET_DIR/TOOLS.md" 2>/dev/null; then
        score=$((score + 3))
    fi

    SCORE_TOTAL=$((SCORE_TOTAL + score))

    if [ $score -eq 15 ]; then
        echo -e "${GREEN}✅ 完整配置 (${weight}分)${NC}"
        RESULTS+=("✅ $name: $desc - 完整配置")
    elif [ $score -gt 5 ]; then
        echo -e "${YELLOW}⚠️  部分配置 (${score}/15分)${NC}"
        RESULTS+=("⚠️  $name: $desc - 部分配置")
    else
        echo -e "${RED}❌ 未配置${NC}"
        RESULTS+=("❌ $name: $desc - 未配置")
    fi
}

# 检查安全配置（特殊检查）
check_security_system() {
    local TARGET_DIR="$1"
    local name="🛡️ 安全配置"
    local desc="skill-vetter + 三层防御体系 + 注入防护"
    local weight=12
    local score=0

    echo -n "  🔍 检查 $name... "

    # 检查skill-vetter技能
    if [ -d "$TARGET_DIR/skills/skill-vetter" ] || [ -f "$TARGET_DIR/skills/skill-vetter/vet_skill.sh" ]; then
        score=$((score + 4))
    fi

    # 检查安全相关配置文件
    if [ -f "$TARGET_DIR/AGENTS.md" ] && grep -q "安全\|security\|Security\|注入\|injection" "$TARGET_DIR/AGENTS.md" 2>/dev/null; then
        score=$((score + 4))
    fi

    # 检查是否有安全协议文档
    if grep -q "三层防御\|防御体系\|安全加固" "$TARGET_DIR/SOUL.md" 2>/dev/null; then
        score=$((score + 4))
    fi

    SCORE_TOTAL=$((SCORE_TOTAL + score))

    if [ $score -ge 10 ]; then
        echo -e "${GREEN}✅ 良好 (${score}/12分)${NC}"
        RESULTS+=("✅ $name: $desc - 已配置")
    elif [ $score -gt 3 ]; then
        echo -e "${YELLOW}⚠️  基础配置 (${score}/12分)${NC}"
        RESULTS+=("⚠️  $name: $desc - 部分配置")
    else
        echo -e "${RED}❌ 未配置${NC}"
        RESULTS+=("❌ $name: $desc - 未配置")
    fi
}

# 生成方案
generate_plans() {
    local score=$1
    echo ""
    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  📊 生成升级方案${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo ""

    # 方案A: 保守方案
    echo -e "${CYAN}🟢 方案 A: 保守方案（基础核心）${NC}"
    echo "  └ 仅补充缺失的核心架构文件"
    echo "  └ 不修改任何现有文件"
    echo "  └ 部署内容: SOUL.md, SESSION-STATE.md, HEARTBEAT.md"
    echo ""

    # 方案B: 标准方案（推荐）
    echo -e "${YELLOW}🟡 方案 B: 标准方案（推荐）${NC}"
    echo "  └ 完整记忆系统部署"
    echo "  └ WAL 预写日志协议激活"
    echo "  └ 工作缓冲区上下文保护"
    echo "  └ 心跳主动检查机制"
    echo "  └ 工具配置清单模板"
    echo ""

    # 方案C: 完整方案
    echo -e "${BLUE}🔴 方案 C: 完整方案（全量升级）${NC}"
    echo "  └ 10层完整架构体系全部部署"
    echo "  └ skill-vetter安全审查机制"
    echo "  └ 完整技能注册表管理"
    echo "  └ 用户画像与偏好管理系统"
    echo "  └ 全量操作系统规范"
    echo ""

    # 智能推荐
    if [ $SCORE_TOTAL -lt 30 ]; then
        echo -e "${RED}💡 推荐: 方案 C (完整方案) - 系统架构缺失较多${NC}"
    elif [ $SCORE_TOTAL -lt 60 ]; then
        echo -e "${YELLOW}💡 推荐: 方案 B (标准方案) - 适合已有一定基础的系统${NC}"
    else
        echo -e "${GREEN}💡 推荐: 方案 A (保守方案) - 系统架构已比较完善${NC}"
    fi
}

# 执行升级
execute_upgrade() {
    local plan="$1"
    echo ""
    echo -e "${BLUE}🚀 执行升级方案: $plan${NC}"
    echo ""

    # 这里可以添加实际执行逻辑
    echo "升级执行功能开发中..."
    echo ""
}

# 主程序
main() {
    local TARGET_DIR="${1:-$(pwd)}"
    
    # 重置全局计数器（每次调用main时重置，确保多次调用互不影响）
    SCORE_TOTAL=0
    RESULTS=()
    
    echo ""
    echo -e "${BLUE}🔍 Soul Injector 升级评估引擎 v1.0.0${NC}"
    echo -e "${CYAN}   by Fangooer Team${NC}"
    echo ""
    echo -e "${YELLOW}📋 扫描目标: $TARGET_DIR${NC}"
    echo ""

    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  📊 8 维度架构扫描${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo ""
    
    # 8 维度检查
    check_dimension "$TARGET_DIR" "🧠 灵魂定位" "SOUL.md" "性格、原则、边界定义" 15
    check_dimension "$TARGET_DIR" "⚡ WAL预写日志" "SESSION-STATE.md" "关键信息写入机制" 12
    check_memory_system "$TARGET_DIR"
    check_security_system "$TARGET_DIR"
    check_dimension "$TARGET_DIR" "📦 技能管理" "SKILL_REGISTRY.md" "技能注册表、选型指南" 12
    check_dimension "$TARGET_DIR" "💓 心跳机制" "HEARTBEAT.md" "主动检查、价值创造" 12
    check_dimension "$TARGET_DIR" "🔧 工具配置" "TOOLS.md" "工具清单、凭证管理" 10
    check_dimension "$TARGET_DIR" "👤 用户画像" "USER.md" "用户偏好、目标画像" 12
    check_dimension "$TARGET_DIR" "📖 操作系统" "AGENTS.md" "完整操作协议与规范" 12

    # 显示总分
    echo ""
    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  📈 评估结果汇总${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo ""

    echo -e "${CYAN}  总得分: $SCORE_TOTAL / $MAX_SCORE${NC}"

    # 进度条
    local progress=$((SCORE_TOTAL * 20 / MAX_SCORE))
    echo -n "  ["
    for i in $(seq 1 20); do
        if [ $i -le $progress ]; then
            echo -n "█"
        else
            echo -n "░"
        fi
    done
    echo "] $((SCORE_TOTAL * 100 / MAX_SCORE))%"
    echo ""

    # 等级评价
    if [ $SCORE_TOTAL -ge 90 ]; then
        echo -e "${GREEN}  🏆 架构大师级!${NC}"
    elif [ $SCORE_TOTAL -ge 70 ]; then
        echo -e "${GREEN}  ✅ 架构良好!${NC}"
    elif [ $SCORE_TOTAL -ge 50 ]; then
        echo -e "${YELLOW}  ⚠️  基础架构，有提升空间${NC}"
    elif [ $SCORE_TOTAL -ge 30 ]; then
        echo -e "${YELLOW}  📉 架构不完整，建议升级${NC}"
    else
        echo -e "${RED}  ❌ 新生儿级，强烈建议完整部署${NC}"
    fi
    echo ""

    # 详细结果
    echo -e "${BLUE}📋 详细检查结果:${NC}"
    echo ""
    for result in "${RESULTS[@]}"; do
        echo "  $result"
    done

    # 生成升级方案
    generate_plans $SCORE_TOTAL

    echo ""
    echo -e "${CYAN}💡 接下来请选择升级方案并执行安装脚本${NC}"
    echo ""
}

# 执行主程序
main "$@"
