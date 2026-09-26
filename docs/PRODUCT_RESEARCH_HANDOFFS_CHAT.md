# Vocle product research — handoffs & chat (2026-09-20)

## Are clinical handoffs useful for medicos?

**Yes — strongly evidenced.** Miscommunication is a major driver of preventable harm. Structured handoff programs (especially **I-PASS**) have **moderate-certainty** evidence for fewer handoff-related adverse events; **SBAR** has lower-certainty but useful nursing/physician utility ([AHRQ PSNet](https://psnet.ahrq.gov/primer/handoffs), [Making Healthcare Safer IV / BMJ Quality & Safety](https://qualitysafety.bmj.com/content/34/10/680), [I-PASS multicenter PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10964397/)).

Joint Commission expects handoff processes that allow **discussion** between giver and receiver (not one-way dump).

### What doctors actually need in a handoff product

| Need | Vocle implication |
|------|-------------------|
| Illness severity first | Priority / “watcher” flag on patients |
| Patient summary + action list | Structured patient cards (already started) |
| Contingency plans | “If X happens → call Y” field |
| **Receiver synthesis / write-back** | Assignee notes, “can’t cover”, redirect — **#3** |
| Searchable archive | Done tab + search (space + global) |
| Low friction on phone | Fast ack, offline-tolerant drafts |
| Not a second EMR | Keep Vocle as **team sign-out**, not full charting |

### Recommended Vocle handoff upgrades (phased)

1. **Now:** Clear overdue UX (Close as missed / I covered late); Done tab in groups; instant Home refresh after ack.
2. **Next:** Assignee reply thread on handoff (notes + reassign).
3. **Later:** Light I-PASS prompts (Illness / Actions / Contingency / Confirm read).

---

## Slack-for-medicos vs WhatsApp (migration thesis)

WhatsApp wins on speed and habit. Slack wins on **channels, threads, search, multi-person DMs, pins, @mentions**. Clinical papers describe Slack-style tools reducing email overload for physician groups ([PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC7821068/)). HIPAA Slack needs Enterprise Grid + BAA — Vocle can win India beta with **clinical workflows WhatsApp lacks** (handoffs, presence, group + privacy) without claiming EMR.

### Must-have chat (next targets)

1. **In-app forward** + message deep link (no OS share as primary) — **#15**
2. **Multi-person DM** (Slack-style) — **#16**
3. Hub IA: DMs / **Needl** (threads) / Groups — **#17**
4. Self notes DM — **#12**
5. Instant DM open + always scroll to latest — **#10**
6. Group member → request/chat without “Could not start” — **#11**

### Also liked by clinical teams

- On-call / availability already started — deepen escalation
- Mentions + saved messages
- Channel bookmarks / pins (partially present)
- Quiet hours (present)
- Optional dark theme for night shifts — **#9** (polish, not blocker)
- Audit-friendly searchable history

### Dark theme (#9)

Useful for night OT/ICU, but **don’t block** on it. First fix DM list hierarchy, contrast, and empty states; then add system/dark toggle.

---

## Scope split for this iteration vs later

| Ship now (bugs / small) | Document / next sprint |
|-------------------------|------------------------|
| Perf: home parallel load, DM scroll, don’t await push | Multi-person DM, Needl rename, full forward picker polish |
| Handoff overdue CTAs, Done tab, Home refresh | Handoff write-back + reassign |
| Profile labels, student role, specialty save | Full I-PASS template |
| Member Message → request; self-DM; lookup self | Dark theme |
| Forward sheet: copy link + pick Vocle chats | Slack feature parity backlog |
