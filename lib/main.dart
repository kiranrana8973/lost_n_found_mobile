import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lost_n_found/app/app.dart';
import 'package:lost_n_found/core/di/service_locator.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // initialize Hive or other services if needed
  await HiveService().init();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize all dependencies via GetIt
  await initializeDependencies(sharedPreferences);

  runApp(const MyApp());
}
