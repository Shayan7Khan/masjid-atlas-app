import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_antonx_boilerplate/app.dart';
import 'package:flutter_antonx_boilerplate/core/enums/env.dart';
import 'package:flutter_antonx_boilerplate/core/others/logger_customizations/custom_logger.dart';
import 'package:flutter_antonx_boilerplate/core/utils.dart';
import 'package:flutter_antonx_boilerplate/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'locator.dart';

Future<void> main() async {
  final log = CustomLogger(className: 'main');
  try {
    log.i('Testing info logs');
    log.d('Testing debug logs');
    log.e('Testing error logs');
    // ignore: deprecated_member_use
    log.wtf('Testing WTF logs');
    WidgetsFlutterBinding.ensureInitialized();

    log.d('Initalising dotenv');
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      log.e('Failed to load .env file: $e');
    }
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_KEY'];

    log.d('Supabase URL: ${supabaseUrl ?? "NOT FOUND"}');
    log.d('Supabase Key: ${supabaseKey != null ? "EXISTS" : "NOT FOUND"}');

    log.d('Initialising firebase......');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log.d('Initialising supabase......');
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setupLocator(Env.dev);
    locator<Utils>().deepLinks();
    runApp(const MyApp(title: 'Dev - Masjid Atlas'));
  } catch (e, s) {
    log.d("$e");
    log.d("$s");
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final log = CustomLogger(className: 'main');
  await Firebase.initializeApp();
  log.d("Handling a background message: ${message.messageId}");
}
