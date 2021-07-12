import 'package:clipio/screens/splash_screen.dart';
import 'package:clipio/store/clipstore.dart';
import 'package:clipio/theme/style.dart';
import 'package:clipio/utils/auth.dart';
import 'package:clipio/utils/shared_prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> messageHandler(RemoteMessage message) async {
  print('Background message: ${message.data["clip"]}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  await Authentication.initializeFirebase();
  Get.put(ClipStore());
  Get.find<ClipStore>().loadCacheList();
  Get.find<ClipStore>().loadTitleList();
  FirebaseMessaging.onBackgroundMessage(messageHandler);

  runApp(MaterialApp(
    theme: ThemeData(
        scaffoldBackgroundColor: AppStyle.backgroundColor,
        // primaryColor: Colors.white,
        // accentColor: AppStyle.buttonBackgroundColor,
        // cardColor: AppStyle.buttonBackgroundColor,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
            brightness: Brightness.dark, color: AppStyle.backgroundColor)),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}
