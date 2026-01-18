import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'app/di/injection_container.dart';
import 'core/services/notifications_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  await sl<NotificationsService>().init();
  await sl<NotificationsService>().requestPermissions();
  await dotenv.load(fileName: ".env");

  runApp(const SunSaveApp());
}
