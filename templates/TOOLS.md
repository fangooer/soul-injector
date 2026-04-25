---
name: Tools Configuration
description: 工具配置与凭证管理
architecture: Soul Injector v1.0.0
---

# TOOLS.md - 工具配置与凭证管理

**技能定义工具如何工作。这个文件记录你的具体情况——对你的设置独一无二的东西。**

---

## 📦 已安装技能清单

| ID | 技能名称 | 版本 | 分类 | 状态 | 文档位置 |
|----|---------|------|------|------|---------|
| S001 | **skill-vetter** | 1.0.0 | 安全/质量 | ✅ 激活 | `skills/skill-vetter/` |
| S002 | **openclaw-tavily-search** | 3.789 | 搜索/工具 | ✅ 激活 | `skills/openclaw-tavily-search/` |
| S003 | **find-skills** | 1.0.2 | 技能管理 | ✅ 激活 | `skills/find-skills/` |
| S004 | **weather** | - | 生活/工具 | ✅ 激活 | `skills/weather/` |
| S005 | **Summarizer** | - | 内容/摘要 | ✅ 激活 | `skills/summarizer/` |

---

## 🔧 系统配置信息

| 配置项 | 值 | 说明 |
|--------|---|------|
| **主工作区** | `/root/.openclaw/workspace/` | |
| **技能目录** | `skills/` | |
| **记忆目录** | `memory/` | |
| **向量库** | LanceDB | |
| **中国镜像站** | https://cn.clawhub-mirror.com | ClawHub 国内镜像 |

---

## 🗂️ 目录结构（10 层架构）

```
workspace/
├── SOUL.md            # 身份、原则、边界（灵魂）
├── AGENTS.md          # 操作系统、学到的教训、工作流
├── USER.md            # 人类的上下文、目标、偏好
├── MEMORY.md          # 精选长期记忆
├── SESSION-STATE.md   # ⭐ 活跃工作内存（WAL 目标）
├── HEARTBEAT.md       # 定期自我改进检查表
├── TOOLS.md           # 工具配置、注意事项、凭证（就是这个文件！）
├── IDENTITY.md        # 身份元数据
├── SKILL_REGISTRY.md  # 全局技能注册表
└── memory/
    ├── YYYY-MM-DD.md  # 每日原始记录
    └── working-buffer.md  # ⭐ 危险区日志
```

---

## 🔐 API Key 配置位置

| 服务 | 环境变量名 | 配置位置 | 状态 |
|------|-----------|---------|------|
| **Tavily Search** | `TAVILY_API_KEY` | `~/.openclaw/.env` | ⬜ 待配置 / ✅ 已配置 |
| **OpenAI** | `OPENAI_API_KEY` | `~/.openclaw/.env` | ⬜ 待配置 / ✅ 已配置 |
| **LanceDB** | `LANCEDB_URI` | `~/.openclaw/.env` | ⬜ 待配置 / ✅ 已配置 |
| **其他服务** | `XXX_API_KEY` | `~/.openclaw/.env` | ⬜ 待配置 / ✅ 已配置 |

**重要规则：**
- ✅ 子 Agent 需要凭据时，先从配置文件读取
- ❌ 禁止直接向用户索要凭证
- 🚫 API Key 永远不要输出到聊天中！
- 🔒 所有凭证必须保存在 `~/.openclaw/.env` 中

---

## 🛠️ 常用工具命令

### OpenClaw CLI 命令
```bash
# 查看状态
openclaw status

# 查看已安装技能
openclaw skills list

# 安装技能
openclaw skills install <skill-name>

# 查看帮助
openclaw help
```

### 项目管理命令
```bash
# 查看目录大小
du -sh *

# 查找文件
find . -name "*.md" | head -20

# 搜索内容
grep -r "关键词" --include="*.md"
```

---

## ⚠️ 已知问题与解决方案

| 问题 | 解决方案 | 状态 |
|------|---------|------|
| [问题 1] | [解决方案] | ✅ 已解决 / 🔄 处理中 |
| [问题 2] | [解决方案] | ✅ 已解决 / 🔄 处理中 |

---

## 📚 参考资源

- OpenClaw 官方文档：https://docs.openclaw.ai
- ClawHub 技能市场：https://cn.clawhub-mirror.com
- LanceDB 文档：https://lancedb.com/docs

---

## 🎯 工具使用最佳实践

1. **优先使用已安装技能** - 不要重复造轮子
2. **技能安装前必须审查** - 使用 skill-vetter 进行安全审查
3. **定期更新技能** - 保持技能版本最新
4. **报告工具 Bug** - 发现问题及时记录和反馈
5. **备份配置文件** - 定期备份 `~/.openclaw/.env`

---

_随着你了解对你的设置独一无二的东西，更新这个文件。这是你的小抄。_

---

✨ **本工具配置清单由 Soul Injector v1.0.0 创建**  
**© 2026 Fangooer Team - MIT License**
