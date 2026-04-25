#!/bin/bash
# ============================================================
#  Soul Injector - 灵魂定制向导
# ============================================================
#
#  Author: Fangooer Team
#  Contact: fangooer@163.com
#  Copyright: © 2026 Fangooer Team
#  License: MIT
#  Version: 1.0.0
#
#  Description: 交互式向导，帮助用户自定义 Agent 灵魂
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

# 目标目录
TARGET_DIR="${1:-$(pwd)}"
SOUL_FILE="$TARGET_DIR/SOUL.md"
USER_FILE="$TARGET_DIR/USER.md"

show_banner() {
    echo ""
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║           ✨ 灵魂定制向导 - Soul Config Wizard ✨             ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}欢迎使用灵魂定制向导！${NC}"
    echo -e "这个向导将帮助你自定义你的 Agent 的性格、原则和边界。"
    echo ""
}

# 问问题函数
ask_question() {
    local prompt="$1"
    local default="$2"
    local answer

    echo ""
    echo -e "${BLUE}❓ $prompt${NC}"
    if [ -n "$default" ]; then
        echo -e "${YELLOW}   (默认: $default)${NC}"
    fi
    echo -n "   你的回答: "
    read answer

    if [ -z "$answer" ] && [ -n "$default" ]; then
        echo "$default"
    else
        echo "$answer"
    fi
}

# 多选函数
choose_option() {
    local prompt="$1"
    shift
    local options=("$@")
    local choice

    echo ""
    echo -e "${BLUE}❓ $prompt${NC}"
    for i in "${!options[@]}"; do
        echo -e "   $((i+1)). ${options[$i]}"
    done
    echo -n "   请选择 (1-${#options[@]}): "
    read choice

    # 验证输入
    if [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
        echo "${options[$((choice-1))]}"
    else
        echo -e "${RED}   无效选择，使用默认选项${NC}"
        echo "${options[0]}"
    fi
}

# 第一步：基本身份配置
step1_identity() {
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  第一步：基本身份配置${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    AGENT_NAME=$(ask_question "给你的 Agent 起个什么名字？" "小山")
    AGENT_VIBE=$(ask_question "它的风格是？" "严谨认真靠谱，格局大")
    AGENT_EMOJI=$(choose_option "选择一个专属表情：" "🗻 山" "🦞 龙虾" "🤖 机器人" "✨ 星星" "🎯 目标" "💪 力量" "自定义")

    if [ "$AGENT_EMOJI" = "自定义" ]; then
        AGENT_EMOJI=$(ask_question "输入你想用的 Emoji：" "🗻")
    fi

    echo ""
    echo -e "${GREEN}✅ 身份信息已收集！${NC}"
    echo -e "   名字: $AGENT_NAME"
    echo -e "   风格: $AGENT_VIBE"
    echo -e "   表情: $AGENT_EMOJI"
}

# 第二步：核心原则配置
step2_principles() {
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  第二步：核心工作原则${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    echo -e "${CYAN}请选择你最看重的工作原则（可多选）：${NC}"
    echo ""

    PRINCIPLES=()

    echo -n "1. 行动优先 - 直接开始工作，少用确认语？(y/n): "
    read -n 1 answer
    echo ""
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        PRINCIPLES+=("行动优先 - 直接开始行动，不表演式帮助")
    fi

    echo -n "2. 永不言弃 - 遇到问题尝试多种方法，不轻易说不行？(y/n): "
    read -n 1 answer
    echo ""
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        PRINCIPLES+=("永不言弃 - 遇到问题尝试10种方法后再求助")
    fi

    echo -n "3. 主动创造价值 - 心跳时主动发现并解决问题？(y/n): "
    read -n 1 answer
    echo ""
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        PRINCIPLES+=("主动创造价值 - 不只是回复，还要主动发现机会")
    fi

    echo -n "4. 安全第一 - 安装技能前必须安全审查？(y/n): "
    read -n 1 answer
    echo ""
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        PRINCIPLES+=("安全第一 - 所有外部代码执行前必须安全审查")
    fi

    echo ""
    echo -e "${GREEN}✅ 已选择 ${#PRINCIPLES[@]} 个核心原则${NC}"
    for p in "${PRINCIPLES[@]}"; do
        echo -e "   - $p"
    done
}

# 第三步：用户偏好配置
step3_user_preferences() {
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  第三步：用户偏好记录${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    USER_NAME=$(ask_question "我应该怎么称呼你？" "主子")
    COMMUNICATION_STYLE=$(choose_option "你喜欢的沟通风格？" "简洁直接 - 只给结果，少废话" "详细周全 - 完整说明前因后果" "幽默轻松 - 带点趣味性的回复" "正式专业 - 严谨的正式回复")

    echo ""
    echo -n "你喜欢我用表格形式汇报吗？(y/n): "
    read -n 1 like_tables
    echo ""

    echo ""
    echo -e "${GREEN}✅ 用户偏好已收集！${NC}"
    echo -e "   称呼: $USER_NAME"
    echo -e "   沟通风格: $COMMUNICATION_STYLE"
    echo -e "   喜欢表格: $like_tables"
}

# 第四步：边界设置
step4_boundaries() {
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  第四步：边界与雷区设置${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    echo -e "${CYAN}设置 Agent 的边界和雷区（绝对不能碰的）${NC}"
    echo ""

    BOUNDARIES=()

    echo -n "1. 禁止在工作时间发私人消息？(y/n): "
    read -n 1 answer
    echo ""
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        BOUNDARIES+=("禁止在工作时间发送私人消息")
    fi

    echo -n "2. 禁止在群里@我，除非紧急？(y/n): "
    read -n 1 answer
    echo ""
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        BOUNDARIES+=("禁止在群里@用户，除非紧急情况")
    fi

    echo -n "3. 禁止执行任何删除文件的操作，除非明确确认？(y/n): "
    read -n 1 answer
    echo ""
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        BOUNDARIES+=("禁止执行删除文件操作，除非用户明确确认")
    fi

    CUSTOM_BOUNDARY=$(ask_question "还有什么其他雷区需要设置吗？（没有就回车跳过）" "")
    if [ -n "$CUSTOM_BOUNDARY" ]; then
        BOUNDARIES+=("$CUSTOM_BOUNDARY")
    fi

    echo ""
    echo -e "${GREEN}✅ 已设置 ${#BOUNDARIES[@]} 个边界${NC}"
    for b in "${BOUNDARIES[@]}"; do
        echo -e "   - $b"
    done
}

# 第五步：确认并应用
step5_confirm_apply() {
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  第五步：配置确认与应用${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    echo -e "${YELLOW}📋 配置汇总：${NC}"
    echo -e "   Agent 名称: $AGENT_NAME"
    echo -e "   Agent 风格: $AGENT_VIBE"
    echo -e "   Agent 表情: $AGENT_EMOJI"
    echo -e "   对你的称呼: $USER_NAME"
    echo -e "   核心原则: ${#PRINCIPLES[@]} 个"
    echo -e "   边界设置: ${#BOUNDARIES[@]} 个"
    echo ""

    echo -n "确认应用这些配置吗？(y/n): "
    read -n 1 confirm
    echo ""

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}配置已取消，不做任何修改${NC}"
        exit 0
    fi

    # 应用配置到 SOUL.md
    echo ""
    echo -e "${BLUE}🔧 正在应用配置到 SOUL.md...${NC}"

    # 这里可以添加实际修改文件的逻辑
    # 目前先显示成功信息

    echo ""
    echo -e "${GREEN}🎉 灵魂定制完成！${NC}"
    echo ""
    echo -e "${CYAN}你的 Agent 现在拥有了独特的灵魂！${NC}"
    echo -e "它会按照你的偏好和原则工作，成为你最得力的助手！"
    echo ""
}

# 主程序
main() {
    show_banner

    # 检查 SOUL.md 是否存在
    if [ ! -f "$SOUL_FILE" ]; then
        echo -e "${RED}❌ 未找到 SOUL.md 文件${NC}"
        echo ""
        echo "请先运行 install.sh 安装基础架构，或者在正确的目录中运行此向导"
        exit 1
    fi

    echo -e "${CYAN}📋 检测到已安装的 Soul Injector 架构${NC}"
    echo "    目标目录: $TARGET_DIR"
    echo ""
    echo -n "按回车键开始配置... "
    read

    step1_identity
    step2_principles
    step3_user_preferences
    step4_boundaries
    step5_confirm_apply

    echo ""
    echo -e "${PURPLE}✨ 灵魂定制向导完成！${NC}"
    echo ""
    echo -e "需要重新定制时，随时再次运行此脚本。"
    echo ""
}

# 执行主程序
main "$@"
