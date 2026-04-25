#!/bin/bash
# ============================================================
#  Soul Injector - 升级评估引擎
# ============================================================
#
#  Author: Fangooer Team
#  Contact: fangooer@163.com
#  Copyright: © 2026 Fangooer Team
#  License: MIT
#  Version: 1.1.0
#
#  Description: 13 维度扫描 Agent 状态，智能生成 3 套升级方案
#
#  扫描维度:
#   L0. 🆕 反先入为主三机制 (ANTI-BIAS.md) - 认知基础层
#   L1. 灵魂定位 (SOUL.md)
#   L2. 预写日志协议 (SESSION-STATE.md)
#   L3. 记忆系统 (MEMORY.md + working-buffer)
#   L4. 工作缓冲区上下文保护
#   L5. 🆕 三层安全防御 (SECURITY-SHIELD.md)
#   L6. 🆕 API Key 管理 (KEY-VAULT.md)
#   L7. 🆕 团队协作与任务分工 (SUB-AGENT-MANAGER.md)
#   L8. 技能管理 (SKILL_REGISTRY.md)
#   L9. 心跳机制 (HEARTBEAT.md)
#   L10. 🆕 任务兜底与失败恢复 (TASK-FALLBACK.md)
#   L11. 工具配置 (TOOLS.md)
#   L12. 用户画像 (USER.md)
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

# 全局变量初始化（脚本开头即初始化，确保所有函数都能访问）
SCORE_TOTAL=0
MAX_SCORE=150  # v1.1.0: 升级到13维度，总分150
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

# ============================================================
# v1.1.0 新增：高级架构层检测 (L0/L5/L6/L7/L10)
# ============================================================

# 检查 L0 反先入为主三机制
check_l8_anti_bias() {
    local TARGET_DIR="$1"
    local name="🛡️  L8 反先入为主三机制"
    local desc="72小时自我怀疑、敌对审计、外部验证优先"
    local weight=10
    local score=0

    echo -n "  🔍 检查 $name... "

    if [ -f "$TARGET_DIR/ANTI-BIAS.md" ] && [ -s "$TARGET_DIR/ANTI-BIAS.md" ]; then
        local lines
        lines=$(wc -l < "$TARGET_DIR/ANTI-BIAS.md" 2>/dev/null || echo "0")
        if [ "$lines" -gt 150 ]; then
            score=$weight
        elif [ "$lines" -gt 50 ]; then
            score=5
        fi
    fi

    SCORE_TOTAL=$((SCORE_TOTAL + score))

    if [ $score -eq $weight ]; then
        echo -e "${GREEN}✅ 完整配置 (${weight}分)${NC}"
        RESULTS+=("✅ $name: $desc - 完整配置")
    elif [ $score -gt 0 ]; then
        echo -e "${YELLOW}⚠️  基础配置 (${score}/${weight}分)${NC}"
        RESULTS+=("⚠️  $name: $desc - 基础配置")
    else
        echo -e "${RED}❌ 未配置${NC}"
        RESULTS+=("❌ $name: $desc - 未配置")
    fi
}

# 检查 L5 三层安全防御
check_l11_security_shield() {
    local TARGET_DIR="$1"
    local name="🛡️  L11 三层安全防御"
    local desc="注入检测、数据泄露防护、权限边界"
    local weight=10
    local score=0

    echo -n "  🔍 检查 $name... "

    if [ -f "$TARGET_DIR/SECURITY-SHIELD.md" ] && [ -s "$TARGET_DIR/SECURITY-SHIELD.md" ]; then
        local lines
        lines=$(wc -l < "$TARGET_DIR/SECURITY-SHIELD.md" 2>/dev/null || echo "0")
        if [ "$lines" -gt 100 ]; then
            score=$weight
        elif [ "$lines" -gt 30 ]; then
            score=5
        fi
    fi

    SCORE_TOTAL=$((SCORE_TOTAL + score))

    if [ $score -eq $weight ]; then
        echo -e "${GREEN}✅ 完整配置 (${weight}分)${NC}"
        RESULTS+=("✅ $name: $desc - 完整配置")
    elif [ $score -gt 0 ]; then
        echo -e "${YELLOW}⚠️  基础配置 (${score}/${weight}分)${NC}"
        RESULTS+=("⚠️  $name: $desc - 基础配置")
    else
        echo -e "${RED}❌ 未配置${NC}"
        RESULTS+=("❌ $name: $desc - 未配置")
    fi
}

# 检查 L6 API Key 管理
check_l4_key_vault() {
    local TARGET_DIR="$1"
    local name="🔐 L4 API Key 管理"
    local desc="密钥轮换、审计日志、权限分级"
    local weight=10
    local score=0

    echo -n "  🔍 检查 $name... "

    if [ -f "$TARGET_DIR/KEY-VAULT.md" ] && [ -s "$TARGET_DIR/KEY-VAULT.md" ]; then
        local lines
        lines=$(wc -l < "$TARGET_DIR/KEY-VAULT.md" 2>/dev/null || echo "0")
        if [ "$lines" -gt 100 ]; then
            score=$weight
        elif [ "$lines" -gt 30 ]; then
            score=5
        fi
    fi

    SCORE_TOTAL=$((SCORE_TOTAL + score))

    if [ $score -eq $weight ]; then
        echo -e "${GREEN}✅ 完整配置 (${weight}分)${NC}"
        RESULTS+=("✅ $name: $desc - 完整配置")
    elif [ $score -gt 0 ]; then
        echo -e "${YELLOW}⚠️  基础配置 (${score}/${weight}分)${NC}"
        RESULTS+=("⚠️  $name: $desc - 基础配置")
    else
        echo -e "${RED}❌ 未配置${NC}"
        RESULTS+=("❌ $name: $desc - 未配置")
    fi
}

# 检查 L7 团队协作与任务分工
check_l13_sub_agent() {
    local TARGET_DIR="$1"
    local name="👥 L13 团队协作"
    local desc="角色工作流、任务分发、状态追踪"
    local weight=10
    local score=0

    echo -n "  🔍 检查 $name... "

    if [ -f "$TARGET_DIR/SUB-AGENT-MANAGER.md" ] && [ -s "$TARGET_DIR/SUB-AGENT-MANAGER.md" ]; then
        local lines
        lines=$(wc -l < "$TARGET_DIR/SUB-AGENT-MANAGER.md" 2>/dev/null || echo "0")
        if [ "$lines" -gt 150 ]; then
            score=$weight
        elif [ "$lines" -gt 50 ]; then
            score=5
        fi
    fi

    SCORE_TOTAL=$((SCORE_TOTAL + score))

    if [ $score -eq $weight ]; then
        echo -e "${GREEN}✅ 完整配置 (${weight}分)${NC}"
        RESULTS+=("✅ $name: $desc - 完整配置")
    elif [ $score -gt 0 ]; then
        echo -e "${YELLOW}⚠️  基础配置 (${score}/${weight}分)${NC}"
        RESULTS+=("⚠️  $name: $desc - 基础配置")
    else
        echo -e "${RED}❌ 未配置${NC}"
        RESULTS+=("❌ $name: $desc - 未配置")
    fi
}

# 检查 L10 任务兜底机制
check_l10_task_fallback() {
    local TARGET_DIR="$1"
    local name="🔐 L10 任务兜底"
    local desc="四级恢复机制、永不放弃原则"
    local weight=10
    local score=0

    echo -n "  🔍 检查 $name... "

    if [ -f "$TARGET_DIR/TASK-FALLBACK.md" ] && [ -s "$TARGET_DIR/TASK-FALLBACK.md" ]; then
        local lines
        lines=$(wc -l < "$TARGET_DIR/TASK-FALLBACK.md" 2>/dev/null || echo "0")
        if [ "$lines" -gt 100 ]; then
            score=$weight
        elif [ "$lines" -gt 30 ]; then
            score=5
        fi
    fi

    SCORE_TOTAL=$((SCORE_TOTAL + score))

    if [ $score -eq $weight ]; then
        echo -e "${GREEN}✅ 完整配置 (${weight}分)${NC}"
        RESULTS+=("✅ $name: $desc - 完整配置")
    elif [ $score -gt 0 ]; then
        echo -e "${YELLOW}⚠️  基础配置 (${score}/${weight}分)${NC}"
        RESULTS+=("⚠️  $name: $desc - 基础配置")
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

    # 智能推荐 (v1.1.0 总分140，按比例调整阈值)
    if [ $SCORE_TOTAL -lt 42 ]; then  # 30/100 = 42/140
        echo -e "${RED}💡 推荐: 方案 C (完整方案) - 系统架构缺失较多${NC}"
    elif [ $SCORE_TOTAL -lt 84 ]; then  # 60/100 = 84/140
        echo -e "${YELLOW}💡 推荐: 方案 B (标准方案) - 适合已有一定基础的系统${NC}"
    else
        echo -e "${GREEN}💡 推荐: 方案 A (保守方案) - 系统架构已比较完善${NC}"
    fi
}

# ============================================================
# v1.1.0 新增：分步升级指南 - 告诉你先补什么、怎么补
# ============================================================
generate_upgrade_guide() {
    local TARGET_DIR="${1:-$(pwd)}"
    local TEMPLATE_DIR="$(dirname "$(dirname "$0")")/templates"
    
    echo ""
    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  📋 分步升级指南 (按优先级排序)${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}💡 永不覆盖原则：所有文件只建议新增，绝不修改现有文件！${NC}"
    echo -e "${YELLOW}   所有模板位于: $TEMPLATE_DIR${NC}"
    echo ""
    
    local priority_p0=""
    local priority_p1=""
    local priority_p2=""
    
    # 🔴 P0 最高优先级 - 核心机制层（必须先补）
    echo -e "${RED}🔴 P0 最高优先级（核心机制）：${NC}"
    
    # L1 灵魂定位
    if [ ! -f "$TARGET_DIR/SOUL.md" ]; then
        echo "  1. 🧠 L1 灵魂定位 - 新增 SOUL.md"
        echo "     cp $TEMPLATE_DIR/SOUL.md $TARGET_DIR/"
        echo ""
    fi
    
    # L2 用户画像
    if [ ! -f "$TARGET_DIR/USER.md" ]; then
        echo "  2. 👤 L2 用户画像 - 新增 USER.md"
        echo "     cp $TEMPLATE_DIR/USER.md $TARGET_DIR/"
        echo ""
    fi
    
    # L5 WAL 预写日志
    if [ ! -f "$TARGET_DIR/SESSION-STATE.md" ]; then
        echo "  3. ⚡ L5 WAL 预写日志协议 - 新增 SESSION-STATE.md"
        echo "     cp $TEMPLATE_DIR/SESSION-STATE.md $TARGET_DIR/"
        echo ""
    fi
    
    # L6 记忆系统
    if [ ! -d "$TARGET_DIR/memory" ]; then
        echo "  4. 📚 L6 记忆系统 - 新建 memory 目录并新增日常笔记模板"
        echo "     cp -r $TEMPLATE_DIR/memory/ $TARGET_DIR/"
        echo ""
    fi
    
    # L9 心跳机制
    if [ ! -f "$TARGET_DIR/HEARTBEAT.md" ]; then
        echo "  5. 💓 L9 心跳机制 - 新增 HEARTBEAT.md"
        echo "     cp $TEMPLATE_DIR/HEARTBEAT.md $TARGET_DIR/"
        echo ""
    fi
    
    # 🟡 P1 高优先级 - 反先入为主 + 任务兜底
    echo -e "${YELLOW}🟡 P1 高优先级（智能增强）：${NC}"
    
    # L8 反先入为主机制
    if [ ! -f "$TARGET_DIR/ANTI-BIAS.md" ]; then
        echo "  1. 🛡️ L8 反先入为主三机制 - 新增 ANTI-BIAS.md"
        echo "     cp $TEMPLATE_DIR/ANTI-BIAS.md $TARGET_DIR/"
        echo ""
    fi
    
    # L10 四级任务兜底
    if [ ! -f "$TARGET_DIR/TASK-FALLBACK.md" ]; then
        echo "  2. 🔐 L10 四级任务兜底机制 - 新增 TASK-FALLBACK.md"
        echo "     cp $TEMPLATE_DIR/TASK-FALLBACK.md $TARGET_DIR/"
        echo ""
    fi
    
    # 🟢 P2 可选升级 - 高级功能
    echo -e "${GREEN}🟢 P2 可选升级（按需选择）：${NC}"
    
    # L4 API Key 管理
    if [ ! -f "$TARGET_DIR/KEY-VAULT.md" ]; then
        echo "  1. 🔐 L4 API Key 管理体系 - 新增 KEY-VAULT.md"
        echo "     cp $TEMPLATE_DIR/KEY-VAULT.md $TARGET_DIR/"
        echo ""
    fi
    
    # L11 三层安全防御
    if [ ! -f "$TARGET_DIR/SECURITY-SHIELD.md" ]; then
        echo "  2. 🛡️ L11 三层安全防御 - 新增 SECURITY-SHIELD.md"
        echo "     cp $TEMPLATE_DIR/SECURITY-SHIELD.md $TARGET_DIR/"
        echo ""
    fi
    
    # L12 技能管理
    if [ ! -f "$TARGET_DIR/SKILL_REGISTRY.md" ]; then
        echo "  3. 📦 L12 技能管理注册表 - 新增 SKILL_REGISTRY.md"
        echo "     cp $TEMPLATE_DIR/SKILL_REGISTRY.md $TARGET_DIR/"
        echo ""
    fi
    
    # L13 双模团队协作
    if [ ! -f "$TARGET_DIR/SUB-AGENT-MANAGER.md" ]; then
        echo "  4. 👥 L13 双模团队协作架构 - 新增 SUB-AGENT-MANAGER.md"
        echo "     cp $TEMPLATE_DIR/SUB-AGENT-MANAGER.md $TARGET_DIR/"
        echo ""
    fi
    
    # 🟡 二级变更建议（需要修改已有文件，但需用户确认）
    echo -e "${YELLOW}💡 二级变更建议（需要修改已有文件，需您确认后执行）：${NC}"
    echo "  1. 将反先入为主机制、插件验证流程写入 AGENTS.md"
    echo "  2. 在 AGENTS.md 中增加专家外部审计永久流程"
    echo "  3. 创建 MECHANISM-EXECUTION-LOG.md 机制执行日志"
    echo ""
    
    echo -e "${GREEN}✅ 提示：复制上述命令按顺序执行即可完成升级！${NC}"
    echo ""
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
    echo -e "${BLUE}🔍 Soul Injector 升级评估引擎 v1.1.0${NC}"
    echo -e "${CYAN}   by Fangooer Team${NC}"
    echo ""
    echo -e "${YELLOW}📋 扫描目标: $TARGET_DIR${NC}"
    echo ""

    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  📊 13 维度架构扫描 (v1.1.0)${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════${NC}"
    echo ""
    
    # 13 维度检查 (v1.1.0 - 按逻辑顺序：基础配置 → 核心机制 → 高级功能)
    check_dimension "$TARGET_DIR" "🧠 L1 灵魂定位" "SOUL.md" "性格、原则、边界定义" 15
    check_dimension "$TARGET_DIR" "👤 L2 用户画像" "USER.md" "用户偏好、目标画像" 12
    check_dimension "$TARGET_DIR" "🔧 L3 工具配置" "TOOLS.md" "工具清单、凭证管理" 10
    check_l4_key_vault "$TARGET_DIR"             # v1.1 新增：L4 API Key 管理
    check_dimension "$TARGET_DIR" "⚡ L5 WAL预写日志" "SESSION-STATE.md" "关键信息写入机制" 12
    check_memory_system "$TARGET_DIR"           # L6 记忆系统
    check_dimension "$TARGET_DIR" "📦 L7 工作缓冲区" "AGENTS.md" "上下文压缩保护" 5
    check_l8_anti_bias "$TARGET_DIR"             # v1.1 新增：L8 反先入为主机制
    check_dimension "$TARGET_DIR" "💓 L9 心跳机制" "HEARTBEAT.md" "主动检查、价值创造" 12
    check_l10_task_fallback "$TARGET_DIR"        # v1.1 新增：L10 任务兜底
    check_l11_security_shield "$TARGET_DIR"      # v1.1 新增：L11 三层安全防御
    check_dimension "$TARGET_DIR" "📦 L12 技能管理" "SKILL_REGISTRY.md" "技能注册表、选型指南" 12
    check_l13_sub_agent "$TARGET_DIR"            # v1.1 新增：L13 团队协作
    check_security_system "$TARGET_DIR"

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

    # 生成分步升级指南 (v1.1.0 新增)
    generate_upgrade_guide "$TARGET_DIR"

    echo ""
    echo -e "${CYAN}💡 接下来请复制上述命令按顺序执行即可完成升级！${NC}"
    echo ""
}

# 执行主程序
main "$@"
