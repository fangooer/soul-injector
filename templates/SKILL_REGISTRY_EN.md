# SKILL_REGISTRY.md - Skill Management Registry

> **Version**: v1.1.0
> **Last Updated**: 2026-04-25
> **Description**: Complete inventory of all installed skills, their capabilities, and usage guidelines. This prevents "I didn't know I had that skill" syndrome.

---

## 📊 Installed Skills Inventory

| Skill ID | Name | Version | Category | Status | Capabilities Summary |
|----------|------|---------|----------|--------|---------------------|
| S001 | skill-vetter | 1.0.0 | Security/Quality | ✅ Active | Malware detection, security audit, risk classification for all new skills |
| S002 | find-skills | 1.0.2 | Skill Management | ✅ Active | Search ClawHub, find and compare available skills |
| S003 | weather | Latest | Lifestyle/Tools | ✅ Active | Weather forecasts, historical weather data |
| S004 | Summarizer | Latest | Content | ✅ Active | Long document summarization, key point extraction |
| S005 | proactive-agent | 3.1.0 | System/Architecture | ✅ Active | Full 13-layer Soul Injector architecture |

---

## 🛡️ Skill Installation Workflow

**MANDATORY PROCESS FOR ALL NEW SKILLS. NO EXCEPTIONS.**

```
1. 🔍 SEARCH & EVALUATE
   ├── Search ClawHub (use China mirror for speed)
   ├── Check download count, author reputation, last update date
   ├── Check if there's an actively maintained alternative
   └── Read reviews and known issues

2. 🔒 SECURITY AUDIT (MANDATORY - NO SKIP)
   ├── Run skill-vetter full audit
   ├── Check for RED FLAG patterns:
   │   ├── curl/wget to unknown URLs
   │   ├── Sending data to external servers
   │   ├── Requesting credentials/tokens
   │   ├── Reading sensitive directories (~/.ssh, ~/.aws)
   │   ├── Accessing MEMORY.md/SOUL.md/USER.md
   │   ├── Base64 decoding + execution
   │   ├── eval()/exec() on external input
   │   ├── Modifying system files outside workspace
   │   ├── Unauthorized package installation
   │   ├── Direct IP address access instead of domain
   │   ├── Obfuscated/minified code
   │   ├── Requesting sudo/elevated permissions
   │   ├── Cookie/session access
   │   └── Credential file access
   └── If ANY red flags found: ABORT installation, document findings

3. 📋 PRE-INSTALL CHECKLIST
   ├── Read the full README/SKILL.md
   ├── Understand what it does AND what permissions it needs
   ├── Check for any breaking changes in this version
   └── Get explicit user confirmation before installation

4. ✅ INSTALL & VERIFY
   ├── Install in staging/test environment first
   ├── Run basic functionality tests
   ├── Verify no unexpected behavior
   └── Add to this registry with complete documentation
```

---

## 🚨 Risk Classification Standard

| Risk Level | Color | Meaning | Installation Policy |
|------------|-------|---------|---------------------|
| LOW | 🟢 | No security issues, open source, well reviewed | Install freely |
| MEDIUM | 🟡 | Minor concerns, isolated sandbox recommended | Install only if really needed |
| HIGH | 🔴 | Significant security concerns | Don't install unless absolutely critical, and only in full sandbox |
| EXTREME | ⛔ | Clear malware or data exfiltration patterns | NEVER INSTALL under any circumstances |

---

## 📝 Skill Usage Guidelines

For every skill you use regularly:

1. **Read the documentation first** - Don't guess how it works
2. **Test in isolation first** - Don't use on production data on first run
3. **Document edge cases** - What doesn't work? What are the limitations?
4. **Update this registry** - Add notes, gotchas, and best practices

---

## 🔧 Skill Maintenance Schedule

| Task | Frequency | Notes |
|------|-----------|-------|
| Security Audit All Skills | Every 30 days | Run skill-vetter on all installed skills |
| Check for Updates | Every 14 days | Check ClawHub for new versions, security patches |
| Remove Unused Skills | Every 90 days | If you haven't used a skill in 90 days, remove it to reduce attack surface |
| Full Inventory Review | Every 90 days | Verify this registry matches what's actually installed |

---

## 🚫 Permanent Skill Blacklist

Skills that should NEVER be installed, no matter what.

| Skill Name | Reason | Date Blacklisted |
|------------|--------|------------------|
| (Add blacklisted skills here) | | |

---

## 💡 ClawHub Configuration

China Mirror (faster access within China): `https://cn.clawhub-mirror.com`

**Always use the China mirror when installing skills from within China.**

---

## 🔗 Related Files

- [KEY-VAULT_EN.md](./KEY-VAULT_EN.md) - API Key management (L4)
- [SECURITY-SHIELD_EN.md](./SECURITY-SHIELD_EN.md) - Full 3-layer security defense (L11)
- [TOOLS_EN.md](./TOOLS_EN.md) - Built-in tool inventory (L3)

---

**© 2026 Fangooer Team | Soul Injector 13-Layer Architecture**
