# Sprint 17 — Live QR & handoff reposition (2026-08-31)

## Issues addressed (doctor beta feedback #6, #13)

| # | Feedback | Fix |
|---|----------|-----|
| 13 | QR should auto-scan when pointed at code | Live camera preview + periodic frame decode (`LiveQrScanner`, zxing2) |
| 6 | Handoffs vs 60-patient notebook | Repositioned copy in form, FAQ, empty states — critical/cross-cover only |

## App version

`1.0.0+18`

## Verify

- [ ] Join → Scan invite QR → live preview detects QR without taking a photo first
- [ ] From photo + manual code still work
- [ ] Create handoff shows reposition banner + shift note hint
- [ ] Help & FAQ reflects DM-by-phone and handoff scope

## Notes

- Live scan uses `camera` package (no ML Kit / mobile_scanner).
- Requires CAMERA permission (already in AndroidManifest).
