#!/bin/bash
# ============================================================
#  Soul Injector - 一键注入灵魂
# ============================================================
#
#  Author: Fangooer Team
#  Contact: fangooer@163.com
#  Copyright: © 2026 Fangooer Team
#  License: MIT
#  Version: 1.0.0
#  Created: 2026-04-25
#
#  Description: 让任何 Agent 从新生儿成长为有完整灵魂、
#               记忆、智慧的成熟主 Agent
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

# 欢迎横幅
show_banner() {
    echo ""
    echo -e "${PURPLE}███████╗ ██████╗ ██╗   ██╗██╗     ██╗███╗   ██╗     ██╗███████╗ ██████╗████████╗${NC}"
    echo -e "${PURPLE}██╔════╝██╔═══██╗██║   ██║██║     ██║████╗  ██║     ██║██╔════╝██╔════╝╚══██╔══╝${NC}"
    echo -e "${PURPLE}███████╗██║   ██║██║   ██║██║     ██║██╔██╗ ██║     ██║█████╗  ██║        ██║   ${NC}"
    echo -e "${PURPLE}╚════██║██║   ██║██║   ██║██║     ██║██║╚██╗██║██   ██║██╔══╝  ██║        ██║   ${NC}"
    echo -e "${PURPLE}███████║╚██████╔╝╚██████╔╝███████╗██║██║ ╚████║╚█████╔╝███████╗╚██████╗   ██║   ${NC}"
    echo -e "${PURPLE}╚══════╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝ ╚════╝ ╚══════╝ ╚═════╝   ╚═╝   ${NC}"
    echo ""
    echo -e "${CYAN}              一键注入灵魂 v1.0.0${NC}"
    echo -e "${BLUE}              by Fangooer Team${NC}"
    echo ""
}

# 检测当前目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$PROJECT_DIR/templates"

# 检测操作系统
OS="$(uname -s)"

# 显示帮助
show_help() {
    echo "使用方法: $0 [目标目录]"
    echo ""
    echo "模式选择:"
    echo "  -n, --newborn     新生儿模式: 全新空 Agent 一键部署"
    echo "  -a, --assess      评估模式: 扫描当前 Agent 状态并生成升级方案"
    echo "  -u, --upgrade     升级模式: 增量升级已有 Agent"
    echo "  -c, --customize     灵魂定制向导: 交互式配置 Agent 性格"
    echo "  -h, --help        显示帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 -n /path/to/agent-workspace    # 新生儿模式部署到指定目录"
    echo "  $0 -a                              # 评估当前目录的 Agent"
    echo "  $0 -u                              # 增量升级当前目录的 Agent"
    echo "  $0 -c                              # 启动灵魂定制向导"
    echo ""
}

# 新生儿模式
newborn_mode() {
    local TARGET_DIR="${1:-$(pwd)}"
    echo -e "${GREEN}🚀 启动新生儿模式...${NC}"
    echo ""
    echo -e "${YELLOW}📋 目标目录: $TARGET_DIR${NC}"
    
    # 前置检查：目录已存在警告
    if [ -f "$TARGET_DIR/SOUL.md" ]; then
        echo -e "${YELLOW}⚠️  检测到目标目录已有架构文件，可能会覆盖！${NC}"
        sleep 1
    fi
    echo ""

    # 创建目录结构
    echo -e "${BLUE}📁 创建目录结构...${NC}"
    mkdir -p "$TARGET_DIR/memory"
    echo -e "   ✅ $TARGET_DIR/memory"

    # 复制模板文件
    echo -e "${BLUE}📝 部署 10 层架构核心文件...${NC}"

    for file in SOUL.md AGENTS.md SESSION-STATE.md HEARTBEAT.md MEMORY.md USER.md TOOLS.md SKILL_REGISTRY.md; do
        if [ -f "$TEMPLATES_DIR/$file" ]; then
            cp "$TEMPLATES_DIR/$file" "$TARGET_DIR/"
            echo -e "   ✅ $file"
        fi
    done

    # 复制工作缓冲区模板
    if [ -f "$TEMPLATES_DIR/memory/working-buffer.md" ]; then
        cp "$TEMPLATES_DIR/memory/working-buffer.md" "$TARGET_DIR/memory/"
        echo -e "   ✅ memory/working-buffer.md"
    fi

    # 创建 example files
    echo -e "${BLUE}📚 创建示例文件...${NC}"
    if [ -d "$PROJECT_DIR/examples" ]; then
        cp -r "$PROJECT_DIR/examples/"* "$TARGET_DIR/memory/" 2>/dev/null || true
    fi

    echo ""
    echo -e "${GREEN}🎉 新生儿模式部署完成！${NC}"
    echo ""
    echo -e "${YELLOW}📋 已部署文件清单:${NC}"
    echo "  - SOUL.md           灵魂定位、原则边界"
    echo "  - AGENTS.md         操作系统、协议规范"
    echo "  - SESSION-STATE.md  WAL预写日志"
    echo "  - HEARTBEAT.md      心跳检查表"
    echo "  - MEMORY.md         长期记忆存储"
    echo "  - USER.md           用户画像与偏好"
    echo "  - TOOLS.md          工具配置清单"
    echo "  - SKILL_REGISTRY.md 技能注册表"
    echo "  - memory/working-buffer.md 上下文缓冲区"
    echo ""
    echo -e "${CYAN}💡 下一步: 运行 $0 -c 启动灵魂定制向导${NC}"
    echo ""
}

# 升级模式
upgrade_mode() {
    local TARGET_DIR="$1"
    echo -e "${GREEN}🔄 启动升级模式...${NC}"
    echo ""
    echo -e "${YELLOW}📋 目标目录: $TARGET_DIR${NC}"
    echo ""

    # 运行评估脚本
    if [ -f "$SCRIPT_DIR/assess.sh" ]; then
        bash "$SCRIPT_DIR/assess.sh" "$TARGET_DIR"
    else
        echo -e "${YELLOW}⚠️  评估脚本未找到，直接进行基础升级...${NC}"
        newborn_mode "$TARGET_DIR"
    fi
}

# 评估模式
assess_mode() {
    local TARGET_DIR="$1"
    echo -e "${BLUE}🔍 启动升级评估引擎...${NC}"
    echo ""
    echo -e "${YELLOW}📋 扫描目标: $TARGET_DIR${NC}"
    echo ""

    if [ -f "$SCRIPT_DIR/assess.sh" ]; then
        bash "$SCRIPT_DIR/assess.sh" "$TARGET_DIR"
    else
        echo -e "${RED}❌ 评估脚本未找到${NC}"
        exit 1
    fi
}

# 灵魂定制向导
customize_mode() {
    local TARGET_DIR="$1"
    echo -e "${PURPLE}✨ 启动灵魂定制向导...${NC}"
    echo ""
    echo -e "${YELLOW}📋 目标目录: $TARGET_DIR${NC}"
    echo ""

    if [ -f "$SCRIPT_DIR/soul-config.sh" ]; then
        bash "$SCRIPT_DIR/soul-config.sh" "$TARGET_DIR"
    else
        echo -e "${YELLOW}⚠️  灵魂定制向导开发中...${NC}"
        echo ""
        echo -e "${CYAN}💡 请手动编辑以下文件来定制你的 Agent:${NC}"
        echo "  - SOUL.md          : 灵魂定位、原则边界"
        echo "  - USER.md         : 用户画像与偏好"
        echo "  - AGENTS.md       : 操作系统规范"
        echo ""
    fi
}

# 主程序
main() {
    show_banner

    # 检查模板目录
    if [ ! -d "$TEMPLATES_DIR" ]; then
        echo -e "${RED}❌ 模板目录不存在: $TEMPLATES_DIR${NC}"
        exit 1
    fi

    local TARGET_DIR
    case "${1:--n}" in
        -n|--newborn)
            TARGET_DIR="${2:-$(pwd)}"
            newborn_mode "$TARGET_DIR"
            ;;
        -a|--assess)
            TARGET_DIR="${2:-$(pwd)}"
            assess_mode "$TARGET_DIR"
            ;;
        -u|--upgrade)
            TARGET_DIR="${2:-$(pwd)}"
            upgrade_mode "$TARGET_DIR"
            ;;
        -c|--customize)
            TARGET_DIR="${2:-$(pwd)}"
            customize_mode "$TARGET_DIR"
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${YELLOW}⚠️  默认使用新生儿模式${NC}"
            echo ""
            TARGET_DIR="${1:-$(pwd)}"
            newborn_mode "$TARGET_DIR"
            ;;
    esac

    echo -e "${GREEN}✨ 灵魂注入成功！${NC}"
    echo ""
    echo -e "${CYAN}💡 你的 Agent 现在拥有完整的 10 层架构体系！${NC}"
    echo ""
    echo -e "${BLUE}📖 更多信息请查看: ${TARGET_DIR}/SOUL.md${NC}"
    echo ""
}

# 执行主程序
main "$@"
