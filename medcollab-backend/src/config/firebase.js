/**
 * FIREBASE ADMIN CONFIG
 *
 * Server-side FCM push. firebase-admin v14+ uses modular exports —
 * `admin.credential.cert` no longer exists (causes Railway error:
 * Cannot read properties of undefined (reading 'cert')).
 */

const { initializeApp, getApps, cert } = require('firebase-admin/app');
const { getMessaging } = require('firebase-admin/messaging');
const logger = require('../utils/logger');

let firebaseReady = false;

/**
 * Railway / dotenv often wrap values in quotes and store newlines as `\n`.
 */
function normalizePrivateKey(raw) {
  if (!raw) return null;
  let key = String(raw).trim();

  // Strip wrapping single/double quotes from Railway paste
  if (
    (key.startsWith('"') && key.endsWith('"')) ||
    (key.startsWith("'") && key.endsWith("'"))
  ) {
    key = key.slice(1, -1);
  }

  // Turn literal \n into real newlines
  key = key.replace(/\\n/g, '\n');

  return key;
}

const connectFirebase = () => {
  try {
    if (getApps().length > 0) {
      firebaseReady = true;
      logger.info('Firebase Admin already connected');
      return;
    }

    const projectId = process.env.FIREBASE_PROJECT_ID?.trim();
    const clientEmail = process.env.FIREBASE_CLIENT_EMAIL?.trim();
    const privateKey = normalizePrivateKey(process.env.FIREBASE_PRIVATE_KEY);

    if (!projectId || !clientEmail || !privateKey) {
      logger.warn(
        'Firebase credentials not set (need FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY). Push notifications disabled.'
      );
      return;
    }

    if (!privateKey.includes('BEGIN PRIVATE KEY')) {
      logger.error(
        'FIREBASE_PRIVATE_KEY looks invalid — must include BEGIN/END PRIVATE KEY block'
      );
      return;
    }

    initializeApp({
      credential: cert({
        projectId,
        clientEmail,
        privateKey,
      }),
    });

    firebaseReady = true;
    logger.info('Firebase Admin connected');
  } catch (error) {
    // Don't crash the server if Firebase fails — just disable notifications
    logger.error(`Firebase init failed: ${error.message}`);
    firebaseReady = false;
  }
};

const isFirebaseReady = () => firebaseReady;

/**
 * Returns firebase-admin messaging helper, or throws if not initialised.
 */
const getFirebaseMessaging = () => {
  if (!firebaseReady || getApps().length === 0) {
    throw new Error('Firebase not initialized');
  }
  return getMessaging();
};

module.exports = {
  connectFirebase,
  isFirebaseReady,
  getFirebaseMessaging,
  /** @deprecated use getFirebaseMessaging — kept for older callers */
  getFirebaseAdmin: () => {
    if (!firebaseReady) throw new Error('Firebase not initialized');
    // Minimal shim: notification.service expects admin.messaging().send(...)
    return {
      messaging: () => getMessaging(),
    };
  },
};
