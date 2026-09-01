/// In-app legal copy for Vocle closed beta. Last updated 24 August 2026.
abstract final class LegalCopy {
  static const String lastUpdated = '24 August 2026';

  static const String privacyBody = '''
Vocle is a closed-beta clinical collaboration app operated for invited doctors in India. This policy explains what we collect and why.

1. Who we are
Vocle (product) is operated by the MedCollab pilot team. Contact: vocle.official@gmail.com.

2. What we collect
• Account: mobile number, name, role, speciality, institution, availability, and optional profile photo.
• Workspace data you create: group membership, messages, threads, reactions, pins, bookmarks, handoffs, and uploaded images or documents.
• Device: FCM push token, app version, and basic connection logs needed to deliver notifications and keep the session secure.
• Support tickets you submit (bug reports, feedback, feature requests).

3. What we do not collect
• We do not sell personal data.
• We do not use third-party advertising or product-analytics SDKs in this closed beta.
• We do not ask for contacts, calendar, or location.

4. How we use data
We use data only to operate Vocle: authenticate you, deliver messages and handoffs, send push notifications you opted into, diagnose outages, and improve the pilot with your explicit feedback.

5. Clinical content
Messages and handoffs may include patient-related information you choose to type or attach. You are responsible for following your hospital’s policies (minimum necessary information, no unnecessary identifiers). Vocle is a communication tool, not an EMR and not a medical device.

6. Sharing
We share data with subprocessors required to run the service: hosting (Railway), database (MongoDB Atlas), media (Cloudinary), SMS OTP (MSG91), and push (Firebase Cloud Messaging). We do not share clinical content with other hospitals or advertisers.

7. Retention
Pilot accounts and workspace data are retained for the duration of the closed beta and a reasonable wind-down period, then deleted or anonymised unless a longer period is required by law or a participating hospital’s agreement.

8. Security
Access is JWT-authenticated. Direct messages are limited to colleagues you share a group or institution with. Transport uses HTTPS. No system is perfectly secure; report suspected incidents to vocle.official@gmail.com.

9. Your choices
You can update profile fields in the app, mute notification categories, and request account deletion by emailing vocle.official@gmail.com.

10. Children
Vocle is for licensed or training doctors. It is not directed at children under 18.

11. Changes
We will update this policy in-app if practices change. Continued use after an update constitutes acceptance for the remainder of the pilot.
''';

  static const String termsBody = '''
These Terms govern use of Vocle during the closed beta (the “Pilot”). By signing in you agree to them.

1. Eligibility
You must be an invited doctor (or medical trainee) using Vocle for professional collaboration. Do not share your login OTP.

2. Licence
We grant you a personal, non-exclusive, revocable licence to use the Android Pilot APK. We may suspend access, rotate versions, or end the Pilot at any time.

3. Acceptable use
Do not use Vocle for harassment, spam, unlawful activity, or to exfiltrate patient data. Do not reverse-engineer the service except as permitted by law. Do not post content you are not authorised to share.

4. Clinical responsibility
Vocle does not provide medical advice. Treatment decisions remain yours and your institution’s. Confirm critical results through your hospital’s official systems when required.

5. Content
You retain rights in content you submit. You grant us a licence to store, transmit, and display that content solely to operate Vocle for your workspace members.

6. Beta software
The Pilot may contain bugs, downtime, or data loss. We provide Vocle “as is” without warranties of uninterrupted or error-free service.

7. Liability
To the extent permitted by Indian law, the Pilot team is not liable for indirect or consequential loss, or for clinical outcomes. Our aggregate liability for the Pilot is limited to INR 0 (the service is provided free during closed beta).

8. Termination
You may stop using Vocle at any time. We may terminate accounts that violate these Terms or hospital policy.

9. Governing law
These Terms are governed by the laws of India. Courts in India have exclusive jurisdiction, subject to mandatory consumer protections.

10. Contact
Questions: vocle.official@gmail.com · Instagram @thevocle
''';
}
