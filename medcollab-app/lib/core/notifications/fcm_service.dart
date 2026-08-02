import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medcollab_app/core/chat/active_chat_tracker.dart';
import 'package:medcollab_app/core/storage/secure_storage_service.dart';
import 'package:medcollab_app/features/auth/data/repositories/user_repository.dart';

/// Top-level background handler — must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Keep minimal — OS already shows the system notification when app is killed.
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase not configured on this build.
  }
}

/// Push notification payload used for deep-link routing after tap.
class PushPayload {
  const PushPayload({
    required this.type,
    this.notificationId,
    this.spaceId,
    this.channelId,
    this.messageId,
    this.handoffId,
    this.title,
    this.body,
  });

  factory PushPayload.fromMap(Map<String, dynamic> data) {
    return PushPayload(
      type: data['type']?.toString() ?? '',
      notificationId: data['notificationId']?.toString(),
      spaceId: data['spaceId']?.toString(),
      channelId: data['channelId']?.toString(),
      messageId: data['messageId']?.toString(),
      handoffId: data['handoffId']?.toString(),
      title: data['title']?.toString(),
      body: data['body']?.toString(),
    );
  }

  final String type;
  final String? notificationId;
  final String? spaceId;
  final String? channelId;
  final String? messageId;
  final String? handoffId;
  final String? title;
  final String? body;

  bool get isEmergency =>
      type.toLowerCase().contains('emergency') ||
      type == 'emergency_alert';

  bool get isHandoff => type.toLowerCase().contains('handoff');
}

/// Registers FCM tokens with the MedCollab API and shows foreground banners.
class FcmService {
  FcmService({
    required UserRepository userRepository,
    required SecureStorageService storage,
  })  : _userRepository = userRepository,
        _storage = storage;

  final UserRepository _userRepository;
  final SecureStorageService _storage;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  final _tapController = StreamController<PushPayload>.broadcast();

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _openedSub;

  bool _initialized = false;
  bool _firebaseReady = false;

  /// Stream of notification taps (foreground local + background/terminated).
  Stream<PushPayload> get onNotificationTap => _tapController.stream;

  bool get isReady => _firebaseReady;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    if (kIsWeb) return;

    try {
      await Firebase.initializeApp();
      _firebaseReady = true;
    } catch (e, st) {
      debugPrint('FCM: Firebase not configured — push disabled ($e)');
      debugPrint('$st');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _initLocalNotifications();
    await _requestPermissions();

    // Create Android channels matching backend `channelId` values.
    await _ensureAndroidChannels();

    _foregroundSub =
        FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    _openedSub =
        FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _emitTap(initial);
    }
  }

  /// Call after the user is authenticated so the token reaches our API.
  Future<void> registerTokenWithBackend() async {
    if (!_firebaseReady) return;

    try {
      await _requestPermissions();
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('FCM: no device token yet');
        return;
      }
      await _storage.saveFcmToken(token);
      await _userRepository.registerFcmToken(token);
      debugPrint('FCM: token registered with API');

      _tokenRefreshSub?.cancel();
      _tokenRefreshSub =
          FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await _storage.saveFcmToken(newToken);
        try {
          await _userRepository.registerFcmToken(newToken);
        } catch (e) {
          debugPrint('FCM: token refresh register failed: $e');
        }
      });
    } catch (e) {
      debugPrint('FCM: registerTokenWithBackend failed: $e');
    }
  }

  /// Best-effort: tell backend to drop this device token on logout.
  Future<String?> prepareLogoutToken() async {
    if (!_firebaseReady) return _storage.getFcmToken();
    try {
      return await FirebaseMessaging.instance.getToken() ??
          await _storage.getFcmToken();
    } catch (_) {
      return _storage.getFcmToken();
    }
  }

  Future<void> clearLocalToken() async {
    try {
      if (_firebaseReady) {
        await FirebaseMessaging.instance.deleteToken();
      }
    } catch (_) {}
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _foregroundSub?.cancel();
    await _openedSub?.cancel();
    await _tapController.close();
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final raw = response.payload;
        if (raw == null || raw.isEmpty) return;
        try {
          final map = jsonDecode(raw) as Map<String, dynamic>;
          _tapController.add(PushPayload.fromMap(map));
        } catch (_) {}
      },
    );
  }

  Future<void> _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      provisional: false,
    );

    if (Platform.isAndroid) {
      final android = _local.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.requestNotificationsPermission();
    }
  }

  Future<void> _ensureAndroidChannels() async {
    if (!Platform.isAndroid) return;
    final android = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        'messages',
        'Messages',
        description: 'Clinical chat, mentions, and updates',
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        'emergency',
        'Emergency',
        description: 'Emergency channel alerts — high priority',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;
    final title = notification?.title ?? data['title']?.toString() ?? 'Vocle';
    final body = notification?.body ?? data['body']?.toString() ?? '';
    final payload = PushPayload.fromMap({
      ...data,
      'title': title,
      'body': body,
    });

    // Already reading this chat — skip noisy local banner.
    if (!payload.isEmergency &&
        ActiveChatTracker.instance.isViewing(payload.channelId)) {
      return;
    }

    final channelId = payload.isEmergency ? 'emergency' : 'messages';
    final importance =
        payload.isEmergency ? Importance.max : Importance.high;
    final priority =
        payload.isEmergency ? Priority.max : Priority.high;

    await _local.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId == 'emergency' ? 'Emergency' : 'Messages',
          channelDescription: channelId == 'emergency'
              ? 'Emergency channel alerts'
              : 'Clinical chat and handoffs',
          importance: importance,
          priority: priority,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode({
        'type': payload.type,
        'notificationId': payload.notificationId,
        'spaceId': payload.spaceId,
        'channelId': payload.channelId,
        'messageId': payload.messageId,
        'handoffId': payload.handoffId,
      }),
    );
  }

  void _onMessageOpened(RemoteMessage message) => _emitTap(message);

  void _emitTap(RemoteMessage message) {
    final data = Map<String, dynamic>.from(message.data);
    if (message.notification?.title != null) {
      data.putIfAbsent('title', () => message.notification!.title);
    }
    if (message.notification?.body != null) {
      data.putIfAbsent('body', () => message.notification!.body);
    }
    _tapController.add(PushPayload.fromMap(data));
  }
}
