# SESSION-STATE.md - Active Working Memory 🗻

> **Version**: v1.1.0
> **Last Updated**: 2026-04-25
> **Description**: This is your Write-Ahead Log (WAL) and active working memory. Write ALL critical details here BEFORE responding. Chat history is volatile - this file is permanent.

---

## ⚡ WAL Protocol (Write-Ahead Log)

### NON-NEGOTIABLE RULE: Stop. Write. Then Respond.

**Whenever you encounter ANY of these, write to this file FIRST, then respond:**

| Trigger Type | Examples |
|-------------|----------|
| ✏️ **Corrections** | "Actually it's X, not Y" / "No, I meant..." / "That's wrong, it's..." |
| 📍 **Proper Nouns** | Names, places, companies, product names, project names |
| 🎨 **Preferences** | Colors, styles, methods, "I like / don't like..." |
| 📋 **Decisions** | "We'll do X" / "Go with Y" / "Use Z" |
| 📝 **Draft Changes** | Edits to work in progress, document changes |
| 🔢 **Specific Values** | Numbers, dates, IDs, URLs, tokens, keys |

### Why?
- Chat history gets compressed, truncated, lost
- Context windows get cleared
- You will forget these critical details
- This file is the single source of truth

---

## 📋 Current Session State

### 🎯 Active Tasks (Work in Progress)

List ALL tasks currently in progress, with their current status:

| Priority | Task Name | Status | Deadline | Next Step |
|----------|-----------|--------|----------|-----------|
| 🔴 P0 | Example: Soul Injector v1.1 English translation | In Progress | 2026-04-25 | Continue with remaining files |
| 🟡 P1 | Example: assess.sh --lang en support | Not Started | TBD | Add language flag handling |

---

### 💾 Critical Recent Information

Write ALL corrections, decisions, preferences, and specific values here. This is the most important section.

| Date/Time | Type | Content |
|-----------|------|---------|
| YYYY-MM-DD HH:MM | Correction | "It's actually Project X, not Project Y" |
| YYYY-MM-DD HH:MM | Decision | "We're going with Option B" |
| YYYY-MM-DD HH:MM | Preference | "User prefers tables over bullet points" |
| YYYY-MM-DD HH:MM | Procedural | "User wants confirmation before running rm commands" |

---

### 🚫 Known Don'ts / Hard Boundaries

Things you've been explicitly told NOT to do. Never do these.

- Don't call the user "boss"
- Don't run production database migrations without explicit confirmation
- Don't send messages after 10 PM
- Don't make up facts if you don't know something

---

### 🎯 Upcoming Deadlines & Events

| Date | Event | Preparation Needed |
|------|-------|-------------------|
| YYYY-MM-DD | Release v1.1 | Final testing, release notes, GitHub publish |
| YYYY-MM-DD | Meeting with team | Prepare agenda, metrics, action items |

---

## 🧠 Memory Refresh Protocol

When context is compressed, cleared, or you feel lost:

1. ✅ FIRST: Read this file completely
2. ✅ SECOND: Read MEMORY.md for long-term context
3. ✅ THIRD: Read SOUL.md for identity and principles
4. ✅ FOURTH: Read recent daily notes in memory/ directory
5. ✅ FIFTH: Now you're ready to continue

**You are NOT ready to work until you've read all four.**

---

## 📝 How to Use This File

### Do:
✅ Write corrections and decisions BEFORE responding
✅ Be specific and concrete - no vague language
✅ Update task status every time something changes
✅ Clean up old / completed items periodically

### Don't:
❌ Ignore this file and "just remember" - you won't
❌ Let this file get cluttered with hundreds of old items
❌ Write the same thing 5 times - update existing entries instead
❌ Skip writing because "it's not important enough" - if it's worth saying, it's worth writing down

---

## 🔗 Related Files

- [MEMORY_EN.md](./MEMORY_EN.md) - Long-term memory and daily notes
- [ANTI-BIAS_EN.md](./ANTI-BIAS_EN.md) - Anti-preconception mechanisms
- [SOUL_EN.md](./SOUL_EN.md) - Core identity and principles

---

**© 2026 Fangooer Team | Soul Injector 13-Layer Architecture**
