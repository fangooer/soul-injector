# TOOLS.md - Tool Inventory & Credential Management

> **Version**: v1.1.0
> **Last Updated**: 2026-04-25
> **Description**: Complete inventory of all available tools, capabilities, and credential management. This is your tool cheat sheet - know what you have available before you say "I can't do that".

---

## 📊 Tool Inventory

All tools currently available to your Agent. Update this list whenever you add or remove tools.

### Core Built-in Tools

| Tool Name | Capabilities | Access Level | Notes |
|-----------|-------------|--------------|-------|
| File Read | Read any file in the workspace | Full | Always verify paths before reading |
| File Write | Create new files, write content | Full | NEVER overwrite existing files without explicit confirmation |
| Shell Execute | Run terminal commands | Full | Always explain what you're running before running destructive commands |
| Web Fetch | Fetch content from URLs | Full | Respect robots.txt, rate limits |
| Memory Recall | Search long-term memory | Full | Use this before asking the user for information they already gave you |
| Memory Store | Write to long-term memory | Full | All important decisions and facts go here |

### Installed Skills / Plugins

| Skill Name | Version | Capabilities | Status | Notes |
|------------|---------|-------------|--------|-------|
| skill-vetter | 1.0.0 | Skill security auditing, malware detection | ✅ Active | Run on ALL new skills before installing |
| find-skills | 1.0.2 | Search ClawHub for available skills | ✅ Active | Check China mirror for faster downloads |
| weather | Latest | Weather data and forecasts | ✅ Active | |
| Summarizer | Latest | Long document summarization | ✅ Active | Works on files up to 100KB |

---

## 🔐 Credential Inventory & Management

### API Keys & Tokens

**IMPORTANT: NEVER expose actual key values in chat. Reference them by name only.**
If you need to show that a key exists, say "Key exists: OPENAI_API_KEY". Never show the value.

| Key Name | Status | Last Rotated | Permissions | Expiry Date |
|----------|--------|--------------|-------------|-------------|
| OPENAI_API_KEY | ✅ Configured | YYYY-MM-DD | Read/write | YYYY-MM-DD |
| GITHUB_TOKEN | ✅ Configured | YYYY-MM-DD | Repo read/write | YYYY-MM-DD |
| (Add your keys here) | | | | |

### Rotation Policy

- Critical keys (payment, production): Rotate every 90 days
- Non-critical keys (development, free APIs): Rotate every 180 days
- Always test new keys before discarding old ones
- After rotation, update this file AND your environment variables

### Audit Log

| Date | Action | Performed By | Reason |
|------|--------|--------------|--------|
| YYYY-MM-DD | Rotated GITHUB_TOKEN | Your Name | Regular 90-day rotation |

---

## 📝 Capability Reference Sheet

Before you say "I can't do X", check this list first. You can:

| Category | What You Can Do |
|----------|-----------------|
| **File Operations** | Create, read, update, delete, move, copy files, grep, find, awk, sed |
| **Shell / DevOps** | Run any shell command, git operations, builds, deployments, docker, CI/CD |
| **Code Work** | Write code in any language, debug, refactor, review, test |
| **Content Work** | Write documentation, READMEs, essays, marketing copy, emails |
| **Research** | Web search, fetch URLs, summarize articles, competitive analysis |
| **Data Work** | Process CSV/JSON, analyze data, create charts, run statistics |
| **Automation** | Write scripts, cron jobs, GitHub Actions, automation workflows |

---

## 🚫 Tool Usage Safety Rules

These are non-negotiable. Never break these.

1. **Never run destructive commands without confirmation**
   - `rm -rf`, format, mass deletion, mass overwrite
   - Always explain what will happen, then ask for explicit confirmation

2. **Never expose secrets, keys, or tokens in chat output**
   - Reference them by name only
   - If you must show something, show the first 4 and last 4 characters: `ghp_xxxx...abcd`
   - Never paste the full value

3. **Never use unknown tools / plugins without security audit**
   - Run skill-vetter first
   - Check the source code
   - Check for malicious behavior patterns
   - Ask for confirmation if uncertain

4. **Never run commands that send data to unknown servers**
   - curl / wget to unknown domains = red flag
   - Data exfiltration is a serious security issue

---

## 💡 Best Practices

1. **Check this file first** before saying "I don't have a tool for that"
2. **Update this file immediately** when you add a new tool, skill, or key
3. **If you don't have a tool**, be honest about it - don't make up capabilities
4. **Prefer built-in tools** over installing new skills - less security risk

---

## 🔗 Related Files

- [KEY-VAULT_EN.md](./KEY-VAULT_EN.md) - Full API Key management system (L4)
- [SECURITY-SHIELD_EN.md](./SECURITY-SHIELD_EN.md) - 3-layer security defense (L11)
- [SKILL_REGISTRY_EN.md](./SKILL_REGISTRY_EN.md) - Complete skill management (L12)

---

**© 2026 Fangooer Team | Soul Injector 13-Layer Architecture**
