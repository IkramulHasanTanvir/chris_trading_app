import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/core/di/dependency_injection.dart';
import 'package:media_kit/media_kit.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    MediaKit.ensureInitialized();
  } catch (_) {
    // Media kit failure should not block app launch.
  }

  try {
    await CacheService().init();
  } catch (_) {
    // Cache init failure must not crash cold start (esp. offline).
  }

  try {
    await DependencyInjection.init();
  } catch (e, st) {
    debugPrint('DependencyInjection failed: $e\n$st');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}
