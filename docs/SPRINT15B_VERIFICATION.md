# Sprint 15B — Onboarding & profile UX (2026-08-31)

## Issues addressed (doctor beta feedback #7–10)

| # | Feedback | Fix |
|---|----------|-----|
| 7 | Profile setup fields not role-aware | Shared [`ProfileDetailsForm`](../medcollab-app/lib/features/profile/presentation/widgets/profile_details_form.dart) — intern skips required speciality; PG+ gets NEET PG dropdown |
| 8 | NEET PG subject list | 19 subjects in [`clinical_profile_options.dart`](../medcollab-app/lib/core/constants/clinical_profile_options.dart) |
| 9 | Tamil Nadu medical college autocomplete | [`tn_medical_colleges.json`](../medcollab-app/assets/data/tn_medical_colleges.json) + searchable field |
| 10 | Edit profile after onboarding | Profile → **Edit profile** → [`EditProfilePage`](../medcollab-app/lib/features/profile/presentation/pages/edit_profile_page.dart) (`PUT /api/users/me`) |

## App version

`1.0.0+16`

## Verify

- [ ] New user: intern → optional NEET PG prep, no required speciality
- [ ] New user: PG resident → speciality dropdown required
- [ ] Institution autocomplete suggests TN colleges
- [ ] Profile → Edit profile → change role/college → saves and reflects on profile header
- [ ] `flutter analyze` clean

## Build

```powershell
cd medcollab-app
flutter pub get
flutter analyze
cd ..
.\scripts\build-release-apk.ps1
```
