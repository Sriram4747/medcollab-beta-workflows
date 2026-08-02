import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcollab_app/app.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  AppDependencies.instance.init();
  // Soft-fail if google-services.json / Firebase not configured yet.
  await AppDependencies.instance.fcmService.initialize();

  runApp(const MedCollabApp());
}
