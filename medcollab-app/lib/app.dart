import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/constants/app_constants.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/lifecycle/app_lifecycle_handler.dart';
import 'package:medcollab_app/core/notifications/fcm_service.dart';
import 'package:medcollab_app/core/notifications/push_notification_router.dart';
import 'package:medcollab_app/core/presence/presence_cubit.dart';
import 'package:medcollab_app/core/theme/app_theme.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/notifications/presentation/cubit/notification_badge_cubit.dart';

class MedCollabApp extends StatefulWidget {
  const MedCollabApp({super.key});

  @override
  State<MedCollabApp> createState() => _MedCollabAppState();
}

class _MedCollabAppState extends State<MedCollabApp> {
  StreamSubscription<PushPayload>? _pushTapSub;

  @override
  void initState() {
    super.initState();
    final deps = AppDependencies.instance;
    _pushTapSub = deps.fcmService.onNotificationTap.listen((payload) {
      // Wait a frame so GoRouter / auth redirect settle after cold start.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = deps.appRouter.rootNavigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          PushNotificationRouter.open(ctx, payload);
        }
      });
    });
  }

  @override
  void dispose() {
    _pushTapSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: deps.authBloc),
        BlocProvider<PresenceCubit>.value(value: deps.presenceCubit),
        BlocProvider<NotificationBadgeCubit>.value(
          value: deps.notificationBadgeCubit,
        ),
      ],
      child: AppLifecycleHandler(
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: deps.appRouter.router,
        ),
      ),
    );
  }
}
