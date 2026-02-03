import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';

import 'app/app.dart';
import 'app/di/injection_container.dart';
import 'core/services/notifications_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notificationsService = NotificationsService.background();
    return await notificationsService.handleBackground(task, inputData);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await Workmanager().initialize(callbackDispatcher);
  await sl<NotificationsService>().init();
  await sl<NotificationsService>().requestPermissions();
  await launchWorker(sl<NotificationsService>());
  await dotenv.load(fileName: ".env");

  runApp(const SunSaveApp());
}
