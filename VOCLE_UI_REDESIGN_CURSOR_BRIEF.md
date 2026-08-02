# Vocle — UI/UX Redesign Brief for Cursor Engineer
**Version:** 1.0 · **Date:** 2026-07-28  
**Project:** Vocle (package: `medcollab_app`)  
**API:** https://medcollab.up.railway.app  
**Goal:** Full visual redesign. Zero new features. Zero backend changes. Pure Flutter UI/UX work.

---

## 1. Design Principles

1. **Clinical first** — Every screen must feel like a professional medical tool, not a consumer chat app
2. **Information hierarchy** — A doctor glancing at the screen for 3 seconds must know what needs attention
3. **Emergency is always distinct** — Red. Loud. Unmissable. Never styled like a regular notification
4. **One-thumb usable** — Doctors use this walking between wards. All primary actions reachable with right thumb
5. **Dark navy header pattern** — Home and Chat headers use `#0D1B3E` background. Content areas use `#F5F7FA`

---

## 2. Color Token System

### Brand Colors
```dart
// lib/core/theme/app_colors.dart

class AppColors {
  // Brand
  static const navyPrimary     = Color(0xFF0D1B3E);  // Headers, nav bar, sent bubbles
  static const navySecondary   = Color(0xFF162952);  // Hover states, secondary surfaces
  static const tealPrimary     = Color(0xFF00C2A8);  // Active tab, CTAs, links
  static const tealDark        = Color(0xFF00A88F);  // Button text on teal bg, pressed
  static const tealTint        = Color(0xFFE8FBF8);  // Teal backgrounds, icon containers

  // Surfaces
  static const backgroundApp   = Color(0xFFF5F7FA);  // App background
  static const surfaceCard     = Color(0xFFFFFFFF);  // Cards, list rows
  static const surfaceInput    = Color(0xFFF5F7FA);  // Input fields

  // Text
  static const textPrimary     = Color(0xFF0D1B3E);  // Main text
  static const textSecondary   = Color(0xFF5A6A85);  // Subtitles, meta
  static const textMuted       = Color(0xFF9CA8B8);  // Timestamps, placeholders
  static const textOnDark      = Color(0xFFFFFFFF);  // Text on navy bg
  static const textOnDarkMuted = Color(0x8DFFFFFF);  // Muted text on navy bg

  // Borders
  static const borderDefault   = Color(0xFFE4E8EF);  // Card borders
  static const borderLight     = Color(0xFFF0F2F5);  // Dividers inside cards

  // Semantic — Emergency
  static const emergencyRed    = Color(0xFFDC2626);  // Emergency banner, red accents
  static const emergencyTint   = Color(0xFFFEE2E2);  // Emergency card background
  static const emergencyBorder = Color(0xFFFCA5A5);  // Emergency card border

  // Semantic — Status
  static const statusSuccess   = Color(0xFF059669);  // Available, Done
  static const statusSuccTint  = Color(0xFFD1FAE5);
  static const statusWarning   = Color(0xFFD97706);  // On call, Monitoring
  static const statusWarnTint  = Color(0xFFFEF3C7);
  static const statusPending   = Color(0xFFE8740A);  // Pending handoff accent
  static const statusPendTint  = Color(0xFFFFF3E0);
  static const statusError     = Color(0xFFDC2626);  // Not attended, critical
  static const statusErrorTint = Color(0xFFFEE2E2);
  static const statusNeutral   = Color(0xFF5A6A85);  // Off duty, In OT
  static const statusNeutTint  = Color(0xFFF1F2F4);
}
```

### Availability Status → Color Mapping
```dart
Color availabilityColor(String status) {
  switch (status) {
    case 'available':      return AppColors.statusSuccess;   // #059669 green
    case 'on_call':        return AppColors.statusWarning;   // #D97706 amber
    case 'in_ot':          return AppColors.statusNeutral;   // #5A6A85 grey
    case 'in_icu':         return AppColors.statusError;     // #DC2626 red
    case 'on_rounds':      return AppColors.tealPrimary;     // #00C2A8 teal
    case 'off_duty':       return AppColors.textMuted;       // #9CA8B8 muted
    case 'do_not_disturb': return AppColors.statusNeutral;   // #5A6A85 grey
    default:               return AppColors.textMuted;
  }
}
```

### Handoff Status → Badge Colors
```dart
// Accent bar (left 4px border)
Color handoffAccentColor(String status) {
  switch (status) {
    case 'submitted':     return AppColors.statusPending;   // orange
    case 'acknowledged':  return AppColors.statusSuccess;   // green
    case 'draft':         return AppColors.textMuted;       // grey
    default:              return AppColors.statusError;     // red = not attended
  }
}

// Badge chip
({Color bg, Color text}) handoffBadgeColors(String status) {
  switch (status) {
    case 'submitted':    return (bg: AppColors.statusPendTint,  text: Color(0xFF9A4F0A));
    case 'acknowledged': return (bg: AppColors.statusSuccTint,  text: Color(0xFF065F46));
    case 'draft':        return (bg: AppColors.statusNeutTint,  text: Color(0xFF374151));
    default:             return (bg: AppColors.statusErrorTint, text: Color(0xFF991B1B));
  }
}
```

---

## 3. Typography

**Font:** System default (`-apple-system` / `Roboto`). Do NOT import a custom font.  
Use `fontWeight` and `letterSpacing` to create hierarchy.

```dart
// lib/core/theme/app_text_styles.dart

class AppTextStyles {
  static const screenTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const doctorName  = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textOnDark);
  static const cardTitle   = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static const body        = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary);
  static const caption     = TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textMuted);
  static const timestamp   = TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textMuted);
  static const sectionLabel = TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
      color: AppColors.textMuted, letterSpacing: 0.7, /* uppercase in widget */);
  static const badge       = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);
  static const bubbleMine  = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.white, height: 1.45);
  static const bubbleTheirs = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.45);
}
```

---

## 4. Border Radius & Spacing

```dart
class AppRadius {
  static const chip    = BorderRadius.all(Radius.circular(4));
  static const button  = BorderRadius.all(Radius.circular(8));
  static const card    = BorderRadius.all(Radius.circular(12));
  static const sheet   = BorderRadius.all(Radius.circular(16));
  static const pill    = BorderRadius.all(Radius.circular(999));
  static const avatar  = BorderRadius.all(Radius.circular(999));
  static const groupIcon = BorderRadius.all(Radius.circular(10));
}

class AppSpacing {
  static const screenH  = 16.0;   // Horizontal screen padding
  static const cardV    = 12.0;   // Vertical padding inside cards
  static const cardH    = 14.0;   // Horizontal padding inside cards
  static const sectionGap = 16.0; // Gap between sections
  static const itemGap   = 6.0;   // Gap between list items
}
```

---

## 5. Screen-by-Screen Specs

---

### SCREEN 1 — Home

**Structure:** Two-zone layout
- Zone A: Dark navy header (`#0D1B3E`) — greeting + shift card
- Zone B: White/light body — emergency banner + widgets

**Header (Zone A):**
```
Background: #0D1B3E
Padding: top=20, horizontal=16, bottom=24

Row 1: "Good [morning/afternoon/evening]"  → fontSize 12, color white/55%
Row 2: "Dr. [Name]"                        → fontSize 20, weight 600, white
Row 3: Shift card (rounded inner card)
  ├─ Background: white/10% opacity
  ├─ BorderRadius: 12
  ├─ Left: "TODAY'S SHIFT" label (10px, uppercase, white/50%) + shift text (13px, white)
  └─ Right: Availability pill (teal border + teal dot + teal text)
```

**Body (Zone B):**
```
Background: #F5F7FA
Padding: 14 horizontal=16

[If emergency active]:
  Emergency Banner
  ├─ Background: #DC2626 (full red)
  ├─ BorderRadius: 12
  ├─ Left icon: rounded square, white/15% bg, ⚠ icon white
  ├─ Title: "Emergency alert" 13px 600 white
  ├─ Subtitle: "Open department emergency channel" 11px white/75%
  └─ Right chevron: white/60%

[Pending Handoffs section]:
  Section header: "PENDING HANDOFFS" (uppercase, 10px, #9CA8B8) + "See all" (11px, #00A88F)
  Cards: HandoffCard widget (see component specs)

[Quick Actions]:
  Section header: "QUICK ACTIONS"
  2-column grid:
    - New handoff: teal icon bg + handoff icon + label
    - New message: teal icon bg + message icon + label
```

**REMOVE from Home (already deferred per QA):**
- ~~"PG Preps" group name under doctor name~~
- ~~Recent patient discussions section~~
- ~~Recent DMs section~~
- ~~Hospital/Department announcements~~
- ~~Floating search FAB~~

---

### SCREEN 2 — Messages

**Header:**
```
Background: #FFFFFF
"Messages" title (18px 600 #0D1B3E) + Search icon + Compose icon (right)
Tab row: "Groups" | "Direct" (underline style)
  Active: #0D1B3E text + 2px #00C2A8 underline
  Inactive: #9CA8B8 text
```

**Groups tab — GroupRow widget:**
```
Background: #FFFFFF, BorderRadius: 10, Border: 0.5px #E4E8EF
Padding: 10 vertical, 12 horizontal
Left: Group avatar (40×40, #0D1B3E bg, rounded 10, teal icon)
Middle:
  ├─ Group name: 13px 500 #0D1B3E
  └─ Preview: "#subgroup · SenderName: last message" — 11px #9CA8B8, ellipsis
Right:
  ├─ Timestamp: 10px #9CA8B8
  └─ Unread badge (if >0): #00C2A8 bg, white text, pill shape
```

**Direct tab — DMRow widget:**
```
Same card structure as GroupRow but:
Left: Avatar circle (38×38) with colored initial letter
  ├─ Each DM gets a consistent color from name hash
  └─ Online indicator dot (9×9): #059669 green, bottom-right, white border
Middle: Name + last message preview
Right: Timestamp only (no unread badge in DMs for now)
```

**REMOVE:**
- ~~Large "New message" pill button floating above nav bar~~  
  → Replace with compose icon (✏) in top-right header

---

### SCREEN 3 — Group → Subgroups

**Header:**
```
Background: #FFFFFF
Back arrow (←) + Group name (18px 600) + Plus button (right, teal bg rounded 8)
```

**SubgroupRow widget:**
```
Background: #FFFFFF, BorderRadius: 10, Border: 0.5px #E4E8EF
Left icon (36×36, rounded 9):
  #emergency → #FEE2E2 bg + red ⚠ icon
  #general   → #E8FBF8 bg + teal 💬 icon  
  #academics → #EEF2FF bg + purple 📖 icon
  custom     → #F5F7FA bg + grey # icon
Middle: Subgroup name + last message preview
Right: Timestamp + unread badge OR draft badge
  Draft badge: #FFF3E0 bg, #9A4F0A text "Draft"
  Unread badge: #00C2A8 bg, white text
```

---

### SCREEN 4 — Chat (DM + Subgroup)

**Header:**
```
Background: #0D1B3E
Back arrow + Avatar (36×36 circle, teal border if online) + Name + Status + Menu (⋮)
Status line: "● Online · Available" in teal, OR "Offline · Available" in muted
```

**Chat body:**
```
Background: #F5F7FA
Date divider: pill-shaped, #E4E8EF bg, 10px #9CA8B8 text

SENT bubbles (mine / right-aligned):
  Background: #0D1B3E
  Text: white, 13px, height 1.45
  BorderRadius: 16, bottom-right corner = 4 (WhatsApp-style tail)
  No "Reply in thread" text link visible by default

RECEIVED bubbles (theirs / left-aligned):
  Background: #FFFFFF
  Border: 0.5px #E4E8EF
  Text: #0D1B3E, 13px
  BorderRadius: 16, bottom-left corner = 4
  Show sender name above (11px 600 #00A88F) for GROUP chats only, not DMs

Thread indicator (only when replies exist):
  Below bubble: "1 reply →" in 11px #00A88F — NOT on every single message
  Only show when replyCount > 0
```

**Composer:**
```
Background: #FFFFFF, border-top: 0.5px #E4E8EF
[+] button (32×32, #F5F7FA bg, rounded 8) — for attachments
Text field (flex, #F5F7FA bg, rounded 20, "Message… @ to mention" placeholder)
[↑] send button (34×34 circle, #0D1B3E bg, teal arrow icon)
```

**REMOVE:**
- ~~"Reply in thread" text link under EVERY message~~  
  → Only show thread indicator when `replyCount > 0`

---

### SCREEN 5 — Handoffs List

**Header:**
```
Background: #FFFFFF, border-bottom: 0.5px #E4E8EF
"Handoffs" title + Search icon + Plus icon (both in teal rounded containers)
```

**Filter tabs:**
```
Horizontal scrollable row (not full-width grid)
Pill-shaped tabs: Pending · Active · Done · Drafts
Active: #0D1B3E bg, white text
Inactive: white bg, #E4E8EF border, #9CA8B8 text
```

**HandoffCard widget:**
```
Background: #FFFFFF, BorderRadius: 12, Border: 0.5px #E4E8EF
Left accent bar: 4px wide, color = handoffAccentColor(status)
Body padding: 11 vertical, 13 horizontal
Top row: title (13px 600 #0D1B3E) + status badge (right)
Bottom row: "Diagnosis · From Doctor · Shift · Date" (11px #9CA8B8)
```

**Status badge colors:** (see Section 2 — Handoff Status)

---

### SCREEN 6 — Handoff Detail

**Header:**
```
Background: #0D1B3E
Back arrow (white)
Shift name: "Night shift" (20px 600 white)
Date: "Jul 9, 2026" (12px white/55%)
```

**Meta card:**
```
White card, rounded 12
Rows: From · Assigned to (teal) · Status badge · Summary
Dividers: 0.5px #F0F2F5 between rows
```

**Patient card:**
```
White card, rounded 12, border 0.5px #E4E8EF
Header: dot color (monitoring=amber, critical=red, stable=green) + bed title + flag icon
Body: diagnosis text → status badge → pending tasks list (dot + task text)
```

**Acknowledge button (for submitted handoffs, receiver only):**
```
Full-width button at bottom
Background: #00C2A8
Text: "Acknowledge Handoff" 15px 600 white
BorderRadius: 12
```

---

### SCREEN 7 — Alerts

**Header:** "Alerts" (18px 600) + Settings gear icon

**Filter tabs:** All · Mentions · Channels · Handoffs (same pill style as Handoffs)

**Date section labels:** "TODAY" / "EARLIER" — 10px 600 #9CA8B8 uppercase

**AlertCard widget:**
```
Background: #FFFFFF, BorderRadius: 12, Border: 0.5px #E4E8EF
Left icon container (36×36, rounded 10):
  Emergency: #DC2626 bg + white ⚠ icon
  Mention:   #EEF2FF bg + purple @ icon  
  Message:   #E8FBF8 bg + teal 💬 icon
  Handoff:   #FFF3E0 bg + orange ⇄ icon

EMERGENCY card override:
  Background: #FFF5F5
  Border: 0.5px #FCA5A5
  Title color: #991B1B (dark red)
```

---

### SCREEN 8 — Profile

**Header:**
```
Background: #0D1B3E
Center-aligned layout:
  Avatar (64×64 circle, teal border 2.5px, #00C2A8 initial letter)
  Name: 18px 600 white
  Role · Speciality: 12px white/55%
  Availability pill: green bg/border, "● Available" in green
```

**Body sections:**
```
White card, rounded 12
Rows (each 44px height):
  Availability → green check icon
  Bookmarks    → bookmark icon
  My Groups    → grid icon  
  Notification settings → bell icon
Each row: icon (32×32 #F5F7FA bg rounded 8) + label (13px 500) + chevron

Sign out: separate card, red border, red text, red logout icon
```

**Availability bottom sheet:**
```
Each option has a colored dot + label + subtitle
Available:  ● green  "Visible to your team"
On call:    ● amber  "Reachable for emergencies"
In OT:      ● grey   "In operating theatre"
In ICU:     ● red    "Actively managing critical patient"
On rounds:  ● teal   "On ward rounds"
Off duty:   ● muted  "Not reachable"
Active option shows a teal checkmark on the right
```

---

### SCREEN 9 — Auth (Login + OTP)

**Login screen:**
```
Background: #F5F7FA
Center: Vocle full logo (assets/branding/vocle_full_logo.jpeg) — NOT the medical kit icon
Subtitle: "For doctors. Built for India." (13px #5A6A85)
Phone input: white bg, rounded 12, border #E4E8EF
Continue button: #0D1B3E bg, white text "Continue", rounded 12, full-width
Footer: "We'll send a 6-digit OTP" (11px #9CA8B8)
```

**OTP screen:**
```
Back arrow (top left)
Logo (smaller, 56×56)
"Verify OTP" (20px 600 #0D1B3E)
Subtitle: "Code sent to +91 XXXXX XXXXX" (13px #9CA8B8)
6-cell OTP input (each cell: 44×52, rounded 10, border that turns teal when focused)
"Verify & Continue" button: #0D1B3E bg, white, rounded 12
"Resend OTP" link: #00A88F teal text (only active after 30s countdown)
```

---

## 6. Navigation Bar

```dart
// Always dark navy background
BottomNavigationBar(
  backgroundColor: AppColors.navyPrimary,  // #0D1B3E
  selectedItemColor: AppColors.tealPrimary,
  unselectedItemColor: Colors.white.withOpacity(0.35),
  type: BottomNavigationBarType.fixed,
  selectedFontSize: 9,
  unselectedFontSize: 9,
  // Active item: add Container with teal/14% background, rounded 8
)

// Tabs in order:
// Home · Messages · Handoffs · Alerts · Profile
// Icons: home · message-circle · transfer/handshake · bell · user-circle
```

**Unread badge on nav:**
```
Messages tab: red dot (8×8) if any unread messages
Handoffs tab: red dot if any pending handoffs
Alerts tab: count badge if unread alerts > 0
```

---

## 7. Key Component Widgets to Create/Update

| Widget | File | Notes |
|--------|------|-------|
| `HandoffCard` | `widgets/handoff_card.dart` | accent bar + badge, reuse everywhere |
| `AlertCard` | `widgets/alert_card.dart` | emergency variant styling |
| `GroupRow` | `widgets/group_row.dart` | unread badge, last message preview |
| `DMRow` | `widgets/dm_row.dart` | online dot, avatar color from name hash |
| `SubgroupRow` | `widgets/subgroup_row.dart` | icon color by subgroup type |
| `AvailabilityPill` | `widgets/availability_pill.dart` | dot + label, color from status |
| `MessageBubble` | `widgets/message_bubble.dart` | mine=navy, theirs=white, tail radius |
| `EmergencyBanner` | `widgets/emergency_banner.dart` | always red, always on Home |
| `SectionHeader` | `widgets/section_header.dart` | uppercase label + optional "See all" |
| `AppNavBar` | `widgets/app_nav_bar.dart` | dark navy, teal active, badge support |

---

## 8. What NOT to Change

- All API calls and data models — zero backend changes
- Socket.io connection logic
- Handoff create/submit/acknowledge business logic
- Navigation routing (go_router routes stay the same)
- Authentication flow logic (only visual changes)
- Package name `medcollab_app`

---

## 9. Implementation Order for Cursor

Work in this order — each step is independently testable:

```
Step 1: Create app_colors.dart, app_text_styles.dart, app_radius.dart
        Update ThemeData in main.dart to use these

Step 2: Rebuild AppNavBar widget (dark navy, teal active)
        Apply to all screens immediately

Step 3: Rebuild Home screen
        - Dark header zone with shift card
        - Emergency banner (red, always visible if active)  
        - Pending handoffs widget
        - Quick actions 2×2 grid
        - Remove all deprecated sections

Step 4: Rebuild Messages screen
        - GroupRow and DMRow widgets
        - Remove floating "New message" pill → compose icon in header

Step 5: Rebuild Subgroup list screen
        - SubgroupRow with color-coded icons by type

Step 6: Rebuild Chat screen
        - Dark navy header
        - Navy sent bubbles / white received bubbles
        - Remove "Reply in thread" from every message
        - Thread indicator only when replyCount > 0

Step 7: Rebuild Handoffs list + detail screens
        - HandoffCard with accent bar
        - HandoffDetail with dark header + patient cards

Step 8: Rebuild Alerts screen
        - AlertCard with emergency variant
        - Date section grouping (Today / Earlier)

Step 9: Rebuild Profile screen
        - Dark navy header with avatar
        - Availability bottom sheet with colored dots

Step 10: Rebuild Auth screens
        - Replace medical kit icon with Vocle logo
        - 6-cell OTP input
        - Polish typography
```

---

## 10. Assets Required

```
assets/branding/
  vocle_full_logo.jpeg   → Auth screens splash/login
  vocle_icon.jpeg        → Launcher icon (already set)
  vocle_wordmark.jpeg    → Optional: header wordmark
```

Ensure in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/branding/
```

---

## 11. Do Not Do List

- ❌ Do not add any new screens or routes
- ❌ Do not change any API endpoint calls
- ❌ Do not rename any model fields
- ❌ Do not add animations (keep it for v2)
- ❌ Do not use any third-party UI package (just Flutter Material)
- ❌ Do not change the bottom nav tab order or labels
- ❌ Do not add splash screens or onboarding flows
- ❌ Do not touch the socket or notification logic

---

*This document is the single source of truth for the Vocle UI redesign sprint.*  
*Any ambiguity: default to the design system tokens in Section 2.*  
*Questions: reference the screen specs in Section 5.*
