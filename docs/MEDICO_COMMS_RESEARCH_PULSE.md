# Medico communication research + Vocle differentiator

_Date: 2026-09-30_

## What doctors actually use social / chat for

Across Indian hospital WhatsApp use, orthopaedic trauma groups, NICU QI chats, and ED coordination research, the same jobs show up again and again:

1. **Shift handoff** — “What is pending for Bed 12?” before the next team arrives  
2. **Image consult** — X-ray / ECG / wound photo with a one-line ask  
3. **On-call escalation** — “Who is free?” / “Senior needed now”  
4. **Bed / OT / discharge logistics** — operational, not clinical debate  
5. **Academic / case discussion** — teaching clips, paper links, rare cases  
6. **Personal life bleed** — festival forwards, memes, burnout jokes (noise that buries clinical signal)

Pain points WhatsApp never solves for them:

- No urgency hierarchy (meme vs crash code looks the same)
- No durable handoff object (chat scrolls away)
- No audit / DPDP-friendly retention
- No “who is reading while I’m with a patient”
- Junior autonomy erosion from constant pinging

## What Vocle already owns

Handoffs + Needl + clinical spaces. That is the wedge. Do not invent a second chat app.

## Recommended unique feature: **Pulse**

**One-sentence pitch:**  
A living **ward pulse board** — every urgent clinical ask becomes a timed, assignable card that sits above chat, not buried inside it.

### Why this wins install hype

| WhatsApp | Slack | Vocle Pulse |
|---|---|---|
| Scroll forever | Channel noise | Timed clinical asks with owner + expiry |
| No “attended?” | Status optional | Explicit pending → acknowledged → done |
| Personal phones = record | Work-ish | Hospital-grade handoff continuity |

### Core loop (MVP)

1. From any Needl / channel, doctor taps **Pulse** → “Need senior review — Bed 7 ECG”  
2. Card appears on Home **Pulse strip** for the on-call / tagged people  
3. Tap card → opens chat + marks **seen**  
4. Owner taps **I’ll take it** or **Done** with optional note  
5. Unattended pulses after N minutes escalate (sound / next on-call)

### Why medicos will talk about it

- Replaces the “is anyone free???” spam  
- Survives shift change (Pulse cards travel with the ward, not the phone owner)  
- Marketing line: **“WhatsApp for doctors. Pulse for the ward.”**

### Not this sprint

Ship Needl polish first. Pulse is the next sprint candidate after this bug pack lands on Railway.

## Runner-up ideas (parked)

- **Silent hours by role** — interns get teaching pings; consultants get only Pulse + emergency  
- **Case capsule** — auto bundle of photos + labs tied to one patient alias for 24h  
- **Rounds mode** — one shared scrolling list for morning board with checkoffs
