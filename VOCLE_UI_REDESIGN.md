# Vocle — UI/UX Redesign Spec
# For Cursor Pro implementation · July 2026
# Do not change app logic, routes, or models. Visual layer only.

---

## 1. Design tokens — add to lib/core/theme/app_theme.dart

```dart
class VocleColors {
  // Primary brand
  static const navy       = Color(0xFF0D1E3D);  // nav, headers, outgoing bubbles
  static const teal       = Color(0xFF00C2A8);  // primary CTA, active nav, links
  static const tealDark   = Color(0xFF00A08C);  // teal pressed state
  static const tealBg     = Color(0xFFE8FBF8);  // teal surface tint

  // Emergency — ONLY use for emergency, never decorative
  static const emergency  = Color(0xFFE63946);
  static const emergencyBg= Color(0xFFFFF0F1);

  // Semantic
  static const success    = Color(0xFF22C55E);  // available, acknowledged
  static const warning    = Color(0xFFF59E0B);  // monitoring, pending, draft
  static const blue       = Color(0xFF1A6FBF);  // on call, mentions

  // Surfaces
  static const pageBg     = Color(0xFFF4F6F9);  // scaffold background
  static const surface    = Color(0xFFFFFFFF);  // cards
  static const border     = Color(0xFFDDE2EA);  // card borders, dividers

  // Text
  static const textPrimary   = Color(0xFF0D1E3D);
  static const textSecondary = Color(0xFF6B7280);
  static const textMuted     = Color(0xFF9CA3AF);
}

class VocleRadius {
  static const card   = 12.0;
  static const chip   = 20.0;
  static const button = 12.0;
  static const avatar = 50.0;  // circular
  static const icon   = 8.0;
}

class VocleShadows {
  static const card = BoxShadow(
    color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2));
  static const emergency = BoxShadow(
    color: Color(0x4DE63946), blurRadius: 16, offset: Offset(0, 4));
}
```

---

## 2. Typography — update ThemeData

```dart
TextTheme(
  displayMedium : TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: VocleColors.textPrimary),
  titleLarge    : TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: VocleColors.textPrimary),
  titleMedium   : TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: VocleColors.textPrimary),
  bodyLarge     : TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: VocleColors.textPrimary),
  bodyMedium    : TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: VocleColors.textSecondary),
  bodySmall     : TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: VocleColors.textMuted, letterSpacing: 0.3),
)
```

---

## 3. Scaffold background

```dart
// In MaterialApp theme:
scaffoldBackgroundColor: VocleColors.pageBg,
```

---

## 4. Navigation bar — full redesign

Replace current BottomNavigationBar with this:

```dart
Container(
  color: VocleColors.navy,
  padding: EdgeInsets.fromLTRB(8, 10, 8, 20), // 20 bottom for safe area
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: tabs.map((tab) => _NavItem(
      icon: tab.icon,
      label: tab.label,
      isActive: currentIndex == tab.index,
      badgeCount: tab.badge,
    )).toList(),
  ),
)

// _NavItem widget:
class _NavItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 36, height: 36,
          decoration: isActive ? BoxDecoration(
            color: VocleColors.teal.withOpacity(0.15),
            borderRadius: BorderRadius.circular(9),
          ) : null,
          child: Stack(children: [
            Center(child: Icon(icon,
              color: isActive ? VocleColors.teal : Colors.white.withOpacity(0.4),
              size: 22,
            )),
            if (badgeCount > 0) Positioned(
              top: 2, right: 2,
              child: Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: VocleColors.emergency,
                  shape: BoxShape.circle,
                  border: Border.all(color: VocleColors.navy, width: 1.5),
                ),
              ),
            ),
          ]),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(
          fontSize: 10,
          color: isActive ? VocleColors.teal : Colors.white.withOpacity(0.4),
          fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
        )),
      ]),
    );
  }
}
```

---

## 5. Home screen — complete rebuild

### Header (navy background):
```
- Background: VocleColors.navy
- Padding: 16px sides, 14px top after status bar, 20px bottom
- Row: [greeting col] [avatar]
  - "Good afternoon" → 13px, white 60%
  - "Dr. Mathiharan T" → 20px w500, white
  - Avatar: 38px circle, teal bg, navy initials text, 600 weight
- Shift banner below name:
  - Background: white 10% on navy
  - Border-radius: 10
  - Left: amber dot + "Tonight · ICU · 8pm–8am"
  - Right: availability pill (teal tinted)
```

### Emergency card (MOST IMPORTANT):
```dart
Container(
  decoration: BoxDecoration(
    color: VocleColors.emergency,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [VocleShadows.emergency],
  ),
  padding: EdgeInsets.all(16),
  child: Row(children: [
    Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.warning_rounded, color: Colors.white, size: 22),
    ),
    SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Emergency alert', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      Text('Open department emergency channel', style: TextStyle(color: Colors.white70, fontSize: 11)),
    ])),
    Icon(Icons.chevron_right, color: Colors.white70),
  ]),
)
```

### Sections (below header, on pageBg):
1. Pending handoffs (show max 1-2 cards with left border amber/red)
2. Quick actions (3 cards in a row: New handoff, New message, My groups)
3. Remove: Recent patient discussions, Recent DMs, Hospital announcements, Department announcements, Pending tasks widget

---

## 6. Messages screen

### Groups tab — no change to structure, update visual:
- Card background: white
- Border: 0.5px VocleColors.border
- Avatar: navy background, teal initial letter
- "3 subgroups" in textMuted, not "3 channels"

### Direct tab:
- Same card style
- Timestamp: right-aligned, 11px, textMuted
- Unread messages: bold sender name + teal dot on left edge of card

### "New message" button — replace pill FAB with icon in header:
- Move compose icon (✏️) to top-right of Messages header
- Remove large "New message" pill button at bottom (it blocks list content)

---

## 7. Chat screen — message bubbles

```
OUTGOING bubble:
  color: VocleColors.navy
  text: white
  border-radius: 16 with bottom-right = 4 (tail)
  padding: 10 12

INCOMING bubble:
  color: VocleColors.surface (white)
  border: 0.5px VocleColors.border
  text: VocleColors.textPrimary
  border-radius: 16 with bottom-left = 4 (tail)
  padding: 10 12

TIMESTAMP: 10px textMuted, right-aligned for outgoing, left for incoming

THREAD REPLIES: Replace "Reply in thread" text link with:
  Small row: 💬 icon + "2 replies" in teal, 10px — only show if replies exist
  Do NOT show "Reply in thread" on every message — only show on messages that have replies

SENDER NAME in group chat: 12px textMuted above incoming bubble, only first message in sequence

DATE DIVIDER: Centered pill, white bg, border, textMuted, 11px — "Today", "Yesterday"

CHAT HEADER:
  Back arrow (teal) + peer name (navy 500) + status row (online dot + status text)
  Right: more options icon (dots)
```

---

## 8. Handoff cards — update status chips

```dart
// Status chip builder:
Widget statusChip(String status) {
  final map = {
    'pending':      (Color(0xFFFFF7ED), Color(0xFFB45309), 'Pending'),
    'active':       (Color(0xFFEFF6FF), Color(0xFF1A6FBF), 'Active'),
    'acknowledged': (Color(0xFFE8FBF8), Color(0xFF00856F), 'Done'),
    'not_attended': (Color(0xFFFFF0F1), Color(0xFFB91C1C), 'Not attended'),
    'draft':        (Color(0xFFF3F4F6), Color(0xFF6B7280),  'Draft'),
  };
  final (bg, fg, label) = map[status] ?? (Color(0xFFF3F4F6), Color(0xFF6B7280), status);
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w500)),
  );
}

// Handoff card left border colors:
// DRAFT → textMuted gray
// SUBMITTED / ACTIVE → warning amber
// ACKNOWLEDGED → success green
// NOT_ATTENDED → emergency red
```

### Patient status inside handoff detail:
```
stable       → green pill
monitoring   → amber pill  (NOT red — monitoring is not emergency)
critical     → red pill
improving    → teal pill
deteriorating→ orange/red pill
```

### Handoff tabs:
- Use underline tabs (not pill/chip style)
- Active tab: navy text + 2px navy underline
- Inactive: textMuted, no underline

---

## 9. Alerts screen

### Filter chips (top row):
- Active: navy background + teal text
- Inactive: white bg + border + textMuted

### Notification card variants:

```
MESSAGE notification:
  Left icon: teal bg, message icon, teal color
  Title: sender name, bold
  Body: message preview
  Meta: date + time, 10px muted

MENTION notification:
  Left icon: blue bg, @ icon, blue color
  Same structure

EMERGENCY notification:
  Card background: VocleColors.emergencyBg
  Border: 0.5px VocleColors.emergency
  Left icon: emergency red solid bg, white warning icon
  Title: "Emergency alert" in VocleColors.emergency, bold
  This card must visually scream — it's the most important notification type

HANDOFF notification:
  Left icon: amber bg, transfer icon, amber color
```

### Date separators:
- "TODAY" / "EARLIER" / "THIS WEEK" in 10px textMuted, uppercase, spaced, above grouped cards

---

## 10. Profile screen

### Avatar:
- Background: VocleColors.navy (not mint green)
- Initial letter: white, 18px, 600 weight

### Availability row:
- Status dot uses correct semantic color (green=available, blue=on_call, orange=in_ot, red=dnd)

### Bottom sheet (availability picker):
- Each option: icon + label + checkmark when selected
- Add colored dot next to each option matching its status color
- "Available" → green dot
- "On call" → blue dot
- "In OT" / "In ICU" → amber dot
- "Off duty" → gray dot
- "Do not disturb" → red dot

### Menu items — keep same structure, update:
- Remove "Global search" from Profile → move search to Messages header
- Keep: Bookmarks, Spaces (rename to Groups), Notification settings, Sign out

---

## 11. Auth screens

### Login screen:
- Replace first-aid kit icon with Vocle logo image: `assets/branding/vocle_full_logo.jpeg`
- Logo size: 120px wide, centered
- "Welcome to Vocle" heading → 22px, navy, w500
- Subtext: "Clinical communication for doctors" → 14px textSecondary
- Phone input: white bg, 0.5px border, 12px radius
- Continue button: teal bg, white text, full width, 52px height, 12px radius

### OTP screen:
- Replace first-aid kit with Vocle logo (smaller: 80px)
- "Verify your number" → 20px navy w500
- OTP field: Use 6 individual boxes (36×44px each, navy border on focused)
- Verify button: same as Continue button style

---

## 12. Shared widget updates

### VocleCard (reusable card wrapper):
```dart
Container(
  decoration: BoxDecoration(
    color: VocleColors.surface,
    borderRadius: BorderRadius.circular(VocleRadius.card),
    border: Border.all(color: VocleColors.border, width: 0.5),
  ),
  padding: padding ?? EdgeInsets.all(14),
  child: child,
)
```

### Avatar widget:
```dart
Container(
  width: size, height: size,
  decoration: BoxDecoration(
    color: VocleColors.navy,
    shape: BoxShape.circle,
  ),
  child: Center(child: Text(initials,
    style: TextStyle(color: Colors.white, fontSize: size * 0.38, fontWeight: FontWeight.w600)
  )),
)
```

### Section header (label + "See all" link):
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: VocleColors.textPrimary)),
    if (onSeeAll != null)
      GestureDetector(onTap: onSeeAll,
        child: Text('See all', style: TextStyle(fontSize: 12, color: VocleColors.teal, fontWeight: FontWeight.w500))),
  ],
)
```

---

## 13. What NOT to change

- All routing and navigation logic
- All API calls and data fetching
- Socket.io event handling
- All state management (providers/blocs)
- Package id: medcollab_app
- Backend URLs and endpoints
- The 5-tab navigation structure
- Groups/Subgroups terminology in data layer (only UI copy changes: "channels" → "subgroups")

---

## 14. Implementation order (do in this sequence)

1. Add VocleColors, VocleRadius, VocleShadows to app_theme.dart
2. Update ThemeData: scaffoldBackgroundColor, textTheme
3. Rebuild BottomNavigationBar → navy custom widget
4. Update auth screens (logo + OTP boxes)
5. Rebuild Home screen header + emergency card
6. Update card widgets (VocleCard, Avatar)
7. Update chat bubble styles
8. Update handoff card + status chips
9. Update alerts/notifications cards
10. Update profile screen avatar + availability picker dots
11. Update messages list cards
12. Test dark mode compatibility (navy + teal work in both)

---

## 15. Assets needed

Confirm these files exist in assets/branding/:
- vocle_full_logo.jpeg  (for auth screens)
- vocle_icon.jpeg       (for launcher, already set)

If not, they are at: Logo/Just image.jpeg and Logo/Vocle_full_logo.jpeg in the project root.

---
*Generated by Claude · Vocle UI redesign sprint · July 2026*
