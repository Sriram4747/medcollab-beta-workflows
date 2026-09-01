/// Closed-beta analytics policy.
///
/// Vocle does **not** ship third-party product analytics (Firebase Analytics,
/// Mixpanel, Amplitude, etc.). Clinical messaging apps should avoid sending
/// screen graphs or message metadata to ad/analytics vendors.
///
/// Allowed signals during closed beta:
/// - Server `/health` operational fields (no PII)
/// - Support tickets the user explicitly submits
/// - Railway / MongoDB / FCM infrastructure logs (ops only)
///
/// Verification: `GET https://medcollab.up.railway.app/health` should include
/// `"analytics":"none"` after the Sprint 14 backend deploy.
abstract final class AnalyticsPolicy {
  static const bool thirdPartyEnabled = false;
  static const String statusLabel = 'Disabled — no third-party analytics';
}
