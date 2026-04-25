---

## 📝 API Key Management System - Soul Injector Layer 4

**Layer 4 of 13: Infrastructure Layer**

Complete key management lifecycle system: secure storage → rotation policy → permission grading → audit log → leak emergency response.

Never hardcode keys. Never expose keys in chat. Never commit keys to git.

---

# 🔐 API Key Management Vault - Soul Injector Layer 4

> **Version**: v1.1.0
> **Last Updated**: 2026-04-25
> **Description**: Complete API Key and credential management lifecycle system.
> **Non-negotiable Rules**: Never hardcode keys. Never expose full key values in chat. Never commit keys to git.

---

## 🎯 Core Principles

Keys are the most sensitive assets an Agent has. Treat them like real-world physical keys.

| Principle | Meaning |
|-----------|---------|
| **Need to Know** | Only expose keys to processes that actually need them |
| **Least Privilege** | Keys should have minimum permissions required to do their job |
| **Rotatable** | Every key can be revoked and rotated at any time |
| **Auditable** | Every key usage should be logged and traceable |
| **Revocable** | If a key leaks, it can be immediately revoked and replaced |

---

## 📊 Key Inventory Registry

**IMPORTANT: NEVER WRITE FULL KEY VALUES HERE.**

Only write: Key name, status, permissions, last rotated, expiry date.

If you need to prove a key exists, show only first 4 and last 4 characters: `ghp_xxxx...abcd`

| Key Name | Status | Last Rotated | Permission Scope | Expiry Date | Owner | Environment |
|----------|--------|-------------|------------------|------------|-------|------------|
| OPENAI_API_KEY | ✅ Active | YYYY-MM-DD | API read/write, model inference | YYYY-MM-DD | You | Production |
| GITHUB_TOKEN | ✅ Active | YYYY-MM-DD | Repo read/write, workflow dispatch | YYYY-MM-DD | You | Development |
| (Add your keys here) | | | | | | |

**Status Definitions**:
- ✅ Active - Normal, working
- 🟡 Expiring Soon - Expires in < 14 days, schedule rotation
- 🔴 Expired - No longer works, needs immediate rotation
- ⚫ Revoked - Compromised, do not use

---

## 🔄 Key Rotation Policy & Schedule

**MANDATORY ROTATION SCHEDULE - NO EXCEPTIONS**

| Key Type / Risk Level | Rotation Frequency | Notification Lead Time |
|----------------------|-------------------|-----------------------|
| 🔴 High Risk (Payment keys, production DB) | Every 30 days | 7 days before expiry |
| 🟡 Medium Risk (Third-party APIs, dev tokens) | Every 90 days | 14 days before expiry |
| 🟢 Low Risk (Free APIs, non-sensitive services) | Every 180 days | 30 days before expiry |

### Rotation Workflow (Step-by-Step)

```
1. 🔍 PRE-CHECK (BEFORE CHANGING ANYTHING)
   ├── Verify current key is still working
   ├── Document all places where the key is currently used
   ├── Make sure you have access to generate new keys
   └── Confirm rollback plan if something goes wrong

2. ✨ GENERATE NEW KEY
   ├── Generate new key with identical permissions
   ├── Store new key securely in your password manager
   └── DO NOT DELETE OLD KEY YET

3. 🔄 GRADUAL ROLLOUT
   ├── Update keys one location at a time (not all at once)
   ├── Test each location after updating
   ├── Verify new key works correctly in each environment
   └── Keep old key active during transition period

4. ✅ VERIFICATION PERIOD (Minimum 24 hours)
   ├── Monitor logs for any errors with new key
   ├── Verify no systems are still using old key
   ├── Confirm all integrations working correctly
   └── Run full test suite

5. 🗑️ FINAL CLEANUP
   ├── After 24-72 hours of successful operation
   ├── Revoke and delete old key
   ├── Update this registry with new key's details
   ├── Log the rotation in the audit log
   └── Set next rotation reminder
```

---

## 🚨 Key Leak Emergency Response Playbook

**IF YOU SUSPECT A KEY HAS BEEN EXPOSED OR LEAKED:**

**DO THIS FIRST, BEFORE DOING ANYTHING ELSE:**

1. ⚠️ **IMMEDIATELY REVOKE THE KEY** - Don't investigate first, don't ask for permission, just revoke it. Minutes matter.
2. 📝 **Log the incident** - What key? When did it leak? How? What permissions did it have?
3. 🔍 **Assess impact** - What systems used this key? What could an attacker do with it?
4. 🕵️ **Audit logs** - Check if the key was used abnormally after the leak time
5. 📢 **Notify affected parties** - Your human, team members, service providers
6. 🔄 **Rotate all related keys** - Assume breach is wider than just the one key
7. 📋 **Post-mortem** - How did it leak? How to prevent it from happening again?

**Golden Rule**: It's always better to revoke unnecessarily than to not revoke quickly enough. False positives are embarrassing. Data breaches are catastrophic.

---

## 📋 Permission Grading Standard

Never give a key more permissions than it absolutely needs.

| Permission Level | Use Case | What it can do |
|-----------------|----------|---------------|
| **Read Only** | Data fetching, monitoring, reporting | Can only read data, cannot modify anything |
| **Write Only** | Logging, metrics submission, data upload | Can only add new data, cannot modify existing or read |
| **Read + Write** | CI/CD, deployment, normal API usage | Can read and write but cannot delete, cannot manage users/permissions |
| **Full Admin** | Account management, user creation, billing | Can do everything, including delete accounts, change permissions, spend money |

**Best Practice**: 90% of your keys should be Read Only. Full Admin keys should be extremely rare, rotated most frequently, and used only by humans, never by automation/scripts.

---

## 📜 Audit Log

Every key operation (create, rotate, revoke, permission change) must be logged here.

| Date & Time | Action | Key Name | Performed By | Reason / Notes |
|------------|--------|----------|-------------|---------------|
| YYYY-MM-DD HH:MM | Rotated | GITHUB_TOKEN | You | Regular 90-day scheduled rotation |
| YYYY-MM-DD HH:MM | Revoked | AWS_SECRET_KEY | You | Accidentally exposed in debug output |
| YYYY-MM-DD HH:MM | Created | OPENAI_API_KEY | You | Initial setup |

---

## ⚠️ Key Safety Rules (Never Break These)

### ❌ NEVER DO THESE THINGS EVER:

1. **Never paste full key values in chat output**
   - If you must show a key exists: `ghp_xxxx...abcd` (first 4 + last 4 only)
   - Even if user asks to see it, never show full value

2. **Never commit keys to version control (git)**
   - All .env files must be in .gitignore
   - Keys never belong in code repositories at all, even private ones

3. **Never hardcode keys in scripts or code**
   - Always load from environment variables
   - Always load from secure vault / secrets manager in production

4. **Never log keys or output keys in debug messages**
   - Debug logs have a habit of becoming public
   - If you need to log authentication status, just log "Authenticated" not "Authenticated with key XYZ"

5. **Never share keys between different services / projects**
   - One key = one purpose
   - If one leaks, the others are still safe
   - Makes revocation clean and simple

---

## 🧪 Key Health Check (Run monthly)

Every month, run through this checklist:

- [ ] All keys are within their rotation period (none expired or expiring soon)
- [ ] No keys have more permissions than they need
- [ ] No unused keys that should be revoked
- [ ] All keys have known owners
- [ ] All key usages are being logged
- [ ] Emergency rotation procedures are documented and tested
- [ ] .env files are properly in .gitignore
- [ ] No keys were accidentally exposed in logs or chat history

---

## 🔗 Related Files

- [SECURITY-SHIELD_EN.md](./SECURITY-SHIELD_EN.md) - Full 3-layer security defense (L11)
- [TOOLS_EN.md](./TOOLS_EN.md) - Basic tool configuration (L3)
- [ANTI-BIAS_EN.md](./ANTI-BIAS_EN.md) - Cognitive protection (L8)

---

**© 2026 Fangooer Team | Soul Injector 13-Layer Architecture**
