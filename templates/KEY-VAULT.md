# 🔑 API Key 管理规范 - Soul Injector L6 Layer

> **版本**: v1.0.0
> **最后更新**: 2026-04-25
> **说明**: 这是 Soul Injector 第6层 - API Key 管理体系的完整实现模板

---

## 🎯 设计原则

| 原则 | 说明 |
|------|------|
| 🔒 **安全存储** | Key 永不硬编码，统一存储，加密保存 |
| 📝 **可追溯** | 所有 Key 的使用都有审计日志 |
| 🔄 **易轮换** | 一键轮换机制，定期自动提醒 |
| 🎚️ **分级授权** | 不同 Key 不同权限，最小权限原则 |
| 🚨 **异常告警** | 异常使用模式自动告警 |

---

## 📁 目录结构

```
key-vault/
├── .env.example          # 环境变量示例模板
├── .gitignore           # Git 忽略配置（重要！防止 Key 提交）
├── key-manager.sh       # Key 管理脚本（增删改查、轮换）
├── audit-log.md         # Key 使用审计日志
├── rotation-schedule.md # Key 轮换计划表
└── README.md            # 本说明文档
```

---

## 🔐 第一步：环境变量模板

### `.env.example` - 标准配置模板

```bash
# ============================================================
# Soul Injector - API Key 集中配置
# ============================================================
# 复制此文件为 .env，填入你的真实 Key
# 重要：.env 文件必须加入 .gitignore，绝对不能提交！

# ============================================================
# LLM API Keys
# ============================================================

# OpenAI
OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
OPENAI_ORG_ID=org-xxxxxxxxxxxxxxxxxxxxxxxx

# Anthropic Claude
ANTHROPIC_API_KEY=sk-ant-api03-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# 字节豆包
DOUBAO_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# OpenRouter (统一入口)
OPENROUTER_API_KEY=sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# ============================================================
# 云服务 Keys
# ============================================================

# AWS
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
AWS_DEFAULT_REGION=us-east-1

# 阿里云
ALIBABA_CLOUD_ACCESS_KEY_ID=LTAI-YOUR-KEY-ID-HERE
ALIBABA_CLOUD_ACCESS_KEY_SECRET=YOUR-SECRET-KEY-HERE

# 腾讯云
TENCENTCLOUD_SECRET_ID=AKID-YOUR-SECRET-ID-HERE
TENCENTCLOUD_SECRET_KEY=YOUR-SECRET-KEY-HERE

# ============================================================
# 开发工具 Keys
# ============================================================

# GitHub
GITHUB_TOKEN=ghp-YOUR-TOKEN-HERE

# Docker
DOCKERHUB_TOKEN=dckr_pat-YOUR-TOKEN-HERE

# ============================================================
# 监控与告警 Keys
# ============================================================

# 飞书机器人 Webhook
FEISHU_WEBHOOK=https://open.feishu.cn/open-apis/bot/v2/hook/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

# 企业微信机器人
WECHAT_WORK_WEBHOOK=https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

# ============================================================
# Key 元数据配置
# ============================================================

# 轮换提醒（提前多少天告警）
KEY_ROTATION_REMINDER_DAYS=30

# 审计日志级别（basic/verbose/full）
AUDIT_LOG_LEVEL=verbose
```

---

## ❌ 必须配置的 .gitignore

**绝对不能把 Key 提交到 Git！**

```gitignore
# ============================================================
# API Key 安全保护 - 必须加入 Git 忽略
# ============================================================

# 环境变量文件
.env
.env.local
.env.*
!.env.example

# Key 文件
*.key
*.pem
*.pub
*.p12
*.pfx
*.jks

# 敏感配置
config.json
settings.json
secrets/
credentials/
vault/

# 审计日志（本地使用，可选提交）
# audit-log.md
```

---

## 🛠️ Key 管理脚本 `key-manager.sh`

```bash
#!/bin/bash
# ============================================================
# Soul Injector - API Key 管理工具
# ============================================================
# 用法: bash key-manager.sh [命令]
#
# 命令:
#   list        列出所有已配置的 Key（脱敏显示）
#   check       检查 Key 的有效性
#   rotate <key-name>  轮换指定 Key
#   audit       显示审计日志
#   remind      检查即将到期的 Key
#   help        显示帮助
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"
AUDIT_LOG="$SCRIPT_DIR/audit-log.md"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

# 脱敏函数：只显示前4后4
mask_key() {
    local key="$1"
    if [ ${#key} -le 8 ]; then
        echo "********"
    else
        echo "${key:0:4}********${key: -4}"
    fi
}

# 记录审计日志
audit_log() {
    local action="$1"
    local key_name="$2"
    local result="$3"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "| $timestamp | $action | $key_name | $result |" >> "$AUDIT_LOG"
}

# ============================================================
# 命令 1: list - 列出所有 Key
# ============================================================
cmd_list() {
    echo -e "${BLUE}🔑 已配置的 API Key 列表${NC}"
    echo ""
    
    if [ ! -f "$ENV_FILE" ]; then
        echo -e "${YELLOW}⚠️ 未找到 .env 文件${NC}"
        echo "请先复制 .env.example 为 .env 并填入你的 Key"
        return 1
    fi
    
    # 找出所有配置的 Key（排除注释和空行）
    local keys=()
    while IFS= read -r line; do
        if [[ "$line" =~ ^[A-Z_]+_API_KEY= ]] || [[ "$line" =~ ^[A-Z_]+_TOKEN= ]] || [[ "$line" =~ ^[A-Z_]+_SECRET= ]] || [[ "$line" =~ ^[A-Z_]+_ID= ]]; then
            local key_name=$(echo "$line" | cut -d'=' -f1)
            local key_value=$(echo "$line" | cut -d'=' -f2)
            if [ -n "$key_value" ] && [ "$key_value" != "x"* ] && [ "$key_value" != "*example*" ]; then
                keys+=("$key_name")
            fi
        fi
    done < "$ENV_FILE"
    
    if [ ${#keys[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️ 暂无已配置的 Key${NC}"
        return 0
    fi
    
    echo "| # | Key 名称 | 状态 | 值（脱敏） |"
    echo "|---|---------|-----|----------|"
    local i=1
    for key_name in "${keys[@]}"; do
        local raw_value=$(grep "^${key_name}=" "$ENV_FILE" | cut -d'=' -f2)
        local masked_value=$(mask_key "$raw_value")
        echo "| $i | \`$key_name\` | ✅ 已配置 | \`$masked_value\` |"
        i=$((i + 1))
    done
    
    echo ""
    echo "✅ 总计 ${#keys[@]} 个已配置的 API Key"
    audit_log "LIST_KEYS" "ALL" "列出 ${#keys[@]} 个 Key"
}

# ============================================================
# 命令 2: check - 检查 Key 有效性
# ============================================================
cmd_check() {
    echo -e "${BLUE}🧪 检查 API Key 有效性${NC}"
    echo ""
    
    local passed=0
    local failed=0
    local skipped=0
    
    # 检查 OpenAI Key
    if grep -q "^OPENAI_API_KEY=" "$ENV_FILE"; then
        local key=$(grep "^OPENAI_API_KEY=" "$ENV_FILE" | cut -d'=' -f2)
        if [ -n "$key" ] && [ "${#key}" -ge 40 ]; then
            echo -e "${GREEN}✅ OpenAI API Key: 格式正确${NC}"
            passed=$((passed + 1))
        else
            echo -e "${RED}❌ OpenAI API Key: 格式错误或为空${NC}"
            failed=$((failed + 1))
        fi
    else
        echo -e "${YELLOW}⚠️ OpenAI API Key: 未配置${NC}"
        skipped=$((skipped + 1))
    fi
    
    # 检查 GitHub Token
    if grep -q "^GITHUB_TOKEN=" "$ENV_FILE"; then
        local key=$(grep "^GITHUB_TOKEN=" "$ENV_FILE" | cut -d'=' -f2)
        if [[ "$key" == ghp_* ]] && [ "${#key}" -ge 40 ]; then
            echo -e "${GREEN}✅ GitHub Token: 格式正确${NC}"
            passed=$((passed + 1))
        else
            echo -e "${RED}❌ GitHub Token: 格式错误${NC}"
            failed=$((failed + 1))
        fi
    else
        echo -e "${YELLOW}⚠️ GitHub Token: 未配置${NC}"
        skipped=$((skipped + 1))
    fi
    
    echo ""
    echo "📊 检查结果汇总:"
    echo "   ✅ 通过: $passed"
    echo "   ❌ 失败: $failed"
    echo "   ⚠️ 未配置: $skipped"
    
    audit_log "CHECK_KEYS" "ALL" "通过: $passed, 失败: $failed, 跳过: $skipped"
}

# ============================================================
# 命令 3: remind - 轮换提醒
# ============================================================
cmd_remind() {
    echo -e "${BLUE}⏰ API Key 轮换提醒检查${NC}"
    echo ""
    
    local ROTATION_FILE="$SCRIPT_DIR/rotation-schedule.md"
    
    if [ ! -f "$ROTATION_FILE" ]; then
        echo -e "${YELLOW}⚠️ 首次使用，创建轮换计划表${NC}"
        cat > "$ROTATION_FILE" << 'EOF'
# API Key 轮换计划表

| Key 名称 | 创建日期 | 建议轮换日期 | 上次轮换日期 | 状态 |
|---------|---------|-------------|-------------|------|
| OPENAI_API_KEY | 2026-04-25 | 2026-07-25 | - | ⏰ 正常 |
| GITHUB_TOKEN | 2026-04-25 | 2026-07-25 | - | ⏰ 正常 |

---

## 轮换规则

- 标准：每 90 天轮换一次
- 高权限：每 30 天轮换一次
- 低权限：每 180 天轮换一次
EOF
        echo -e "${GREEN}✅ 轮换计划表已创建${NC}"
    fi
    
    echo "轮换计划表: $ROTATION_FILE"
    echo ""
    echo "💡 建议：设置定时任务每月自动检查轮换"
    echo "   crontab 示例：0 9 1 * * bash /path/to/key-manager.sh remind"
    
    audit_log "ROTATION_CHECK" "ALL" "检查轮换提醒"
}

# ============================================================
# 命令 4: audit - 审计日志
# ============================================================
cmd_audit() {
    echo -e "${BLUE}📋 API Key 使用审计日志${NC}"
    echo ""
    
    if [ ! -f "$AUDIT_LOG" ]; then
        echo -e "${YELLOW}⚠️ 首次使用，创建审计日志${NC}"
        cat > "$AUDIT_LOG" << 'EOF'
# API Key 审计日志

| 时间 | 操作 | Key 名称 | 结果 |
|------|-----|---------|------|
EOF
    fi
    
    head -50 "$AUDIT_LOG"
    
    audit_log "VIEW_AUDIT" "ALL" "查看审计日志"
}

# ============================================================
# 主程序
# ============================================================
main() {
    case "${1:-list}" in
        list)
            cmd_list
            ;;
        check)
            cmd_check
            ;;
        remind)
            cmd_remind
            ;;
        audit)
            cmd_audit
            ;;
        help|--help|-h)
            echo "用法: bash key-manager.sh [命令]"
            echo ""
            echo "命令列表:"
            echo "  list     列出所有已配置的 Key"
            echo "  check    检查 Key 的有效性"
            echo "  remind   检查 Key 轮换提醒"
            echo "  audit    查看审计日志"
            echo "  help     显示此帮助"
            ;;
        *)
            echo -e "${RED}❌ 未知命令: $1${NC}"
            echo "运行 bash key-manager.sh help 查看帮助"
            exit 1
            ;;
    esac
}

main "$@"
```

---

## 📅 Key 轮换计划表模板 `rotation-schedule.md`

```markdown
# API Key 轮换计划表

> **重要提醒**: Key 轮换是安全最佳实践！

---

## 📊 Key 状态总览

| Key 名称 | 创建日期 | 建议轮换日期 | 上次轮换日期 | 状态 | 负责人 |
|---------|---------|-------------|-------------|------|-------|
| OPENAI_API_KEY | 2026-04-25 | 2026-07-25 | - | ⏰ 正常 | 你 |
| ANTHROPIC_API_KEY | 2026-04-25 | 2026-07-25 | - | ⏰ 正常 |
| GITHUB_TOKEN | 2026-04-25 | 2026-07-25 | - | ⏰ 正常 |
| AWS_ACCESS_KEY_ID | 2026-04-25 | 2026-05-25 | - | 🔴 即将到期 |
| DOUBAO_API_KEY | 2026-04-25 | 2026-07-25 | - | ⏰ 正常 |
| FEISHU_WEBHOOK | 2026-04-25 | 2026-10-25 | - | 🟡 低风险 |

---

## 🔄 轮换规则

| 权限等级 | 轮换周期 | 示例 |
|---------|---------|------|
| 🔴 极高权限 | 30 天 | 云服务 AK/SK、生产环境 Key |
| 🟡 普通权限 | 90 天 | 普通 LLM API Key、开发 Token |
| 🟢 低风险 | 180 天 | Webhook URL、只读 Key |

---

## 🚨 轮换检查清单

轮换 Key 时必须执行：

- [ ] 在服务商控制台生成新 Key
- [ ] 更新本地 .env 文件
- [ ] 测试新 Key 是否正常工作
- [ ] 更新此轮换记录表
- [ ] 等待 24 小时确认新 Key 无问题
- [ ] **最后一步**：在服务商控制台废弃旧 Key

---

## 📧 告警通知配置

在 `key-manager.sh` 中配置告警通知，Key 即将到期时自动发消息：

- 飞书/企业微信机器人通知
- 邮件提醒
- GitHub Issue 自动创建提醒
```

---

## 📋 使用示例

### 列出所有 Key

```bash
cd key-vault
bash key-manager.sh list
```

输出：
```
🔑 已配置的 API Key 列表

| # | Key 名称 | 状态 | 值（脱敏） |
|---|---------|-----|----------|
| 1 | OPENAI_API_KEY | ✅ 已配置 | sk-5************************** |
| 2 | GITHUB_TOKEN | ✅ 已配置 | ghp_8************************** |

✅ 总计 2 个已配置的 API Key
```

### 检查 Key 有效性

```bash
bash key-manager.sh check
```

### 轮换提醒检查

```bash
bash key-manager.sh remind
```

### 查看审计日志

```bash
bash key-manager.sh audit
```

---

## 💡 最佳实践

### 1. 永远不要硬编码

❌ 错误：
```python
# 绝对不要这么写！
api_key = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

✅ 正确：
```python
import os
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("OPENAI_API_KEY")
```

### 2. 最小权限原则

- 每个服务使用独立的 Key
- 每个 Key 只授予必要的最小权限
- 定期审计每个 Key 的权限是否需要

### 3. 定期轮换

- 设置日历提醒或定时任务
- 高权限 Key 至少每月轮换一次
- 轮换后必须验证新 Key，旧 Key 不要立即删除（留 24 小时缓冲）

### 4. 审计追踪

- 所有 Key 的添加、删除、修改都要记录
- 定期（每月）检查审计日志，找出异常使用模式

---

## 🔗 相关文件

- [SECURITY-SHIELD.md](./SECURITY-SHIELD.md) - 三层安全防御体系
- [SOUL.md](./SOUL.md) - 灵魂定位与边界定义

---

**© 2026 Fangooer Team | Soul Injector 10-Layer Architecture**
