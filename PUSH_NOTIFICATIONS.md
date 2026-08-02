# Vocle — Push Notifications (FCM) Setup

**Status (2026-08-02):** ✅ **LIVE on Android** — Railway `Firebase Admin connected`; two-phone QA confirmed (app killed → status-bar banner).

**Goal:** Doctors see banners on the phone status bar for new messages, mentions, handoffs, and **emergency** alerts — even when Vocle is closed.

---

## Production checklist (done)

| Step | Status |
|------|--------|
| Firebase Android app `com.example.medcollab_app` | ✅ `vocle-medapp-v0` |
| `google-services.json` in `medcollab-app/android/app/` | ✅ (gitignored) |
| Railway `FIREBASE_PROJECT_ID` / `CLIENT_EMAIL` / `PRIVATE_KEY` | ✅ |
| Backend modular Firebase Admin (`firebase-admin/app`) | ✅ on GitHub `master` |
| Flutter FCM client + deep links | ✅ |
| Release APK with FCM | ✅ `D:\MedCollab\MedCollab-beta.apk` |
| End-to-end QA | ✅ |

---

## 1. Create Firebase project (one-time)

1. Open [Firebase Console](https://console.firebase.google.com/)
2. **Add project** → name it `Vocle` (or `MedCollab`)
3. Inside the project → **Add app** → **Android**
4. Android package name must be exactly:
   ```
   com.example.medcollab_app
   ```
   (matches `android/app/build.gradle.kts` `applicationId`)
5. Download **`google-services.json`**
6. Copy it to:
   ```
   medcollab-app/android/app/google-services.json
   ```
   (gitignored — do not commit)

---

## 2. Service account for Railway (server push)

1. Firebase Console → Project settings → **Service accounts**
2. **Generate new private key** → download JSON
3. From that JSON, set these on **Railway → MedCollab service → Variables**:

| Railway variable | From JSON |
|------------------|-----------|
| `FIREBASE_PROJECT_ID` | `project_id` |
| `FIREBASE_CLIENT_EMAIL` | `client_email` |
| `FIREBASE_PRIVATE_KEY` | `private_key` (keep the `\n` escaped newlines as a single string) |

4. Deploy **Latest Commit** from GitHub **`master`** (not a design branch). Logs should show:
   ```text
   Firebase Admin connected
   ```

**Note:** `firebase-admin` v14 requires modular import (`cert` / `initializeApp` from `firebase-admin/app`). Fixed in production.

---

## 3. Rebuild APK

```powershell
cd D:\MedCollab\medcollab-app
.\scripts\build-release-apk.ps1 `
  -ApiBaseUrl "https://medcollab.up.railway.app" `
  -Msg91WidgetToken "YOUR_WIDGET_TOKEN" `
  -SkipAnalyze
Copy-Item build\app\outputs\flutter-apk\app-release.apk D:\MedCollab\MedCollab-beta.apk -Force
```

Install on a **physical phone**. On first login: **Allow notifications**.

### Windows build tips (this machine)
- If PKIX / Avast SSL fails: run `android/setup_gradle_truststore.ps1`
- If Google Services plugin won’t resolve: ensure `android/offline-m2/` mirror exists (see prior build notes; gitignored)
- Core library desugaring is required for `flutter_local_notifications`

---

## 4. What gets a push

| Event | Priority | Android channel |
|-------|----------|-----------------|
| `#emergency` message | High | `emergency` |
| @mention | Urgent | `messages` |
| New channel / DM message | Normal | `messages` |
| Handoff assigned to you | Urgent | `messages` |
| Handoff acknowledged | Normal | `messages` |

Respects Profile → Notification settings (and quiet hours for non-emergency).

Tap opens: chat, handoff detail, or Alerts tab.

---

## 5. Quick test

1. Two phones, two doctor accounts, same group  
2. Phone A: kill Vocle (swipe away)  
3. Phone B: send DM / submit handoff / post in `#emergency`  
4. Phone A status bar should show the banner within a few seconds  

If nothing appears:

- Confirm `google-services.json` package is `com.example.medcollab_app`
- Confirm Railway log has `Firebase Admin connected`
- Confirm phone allowed notifications for Vocle
- Confirm Notification settings toggles are ON
- Confirm user logged in after install (token register)

---

## Notes

- iOS / APNs not configured yet (Android-first beta)
- Emergency sound `emergency_alert` is referenced; falls back to default system sound until a custom asset is added
- Package id is still `com.example.medcollab_app` — change before Play Store
