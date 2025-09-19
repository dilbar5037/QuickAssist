/*
 * QuickAssist - Vehicle Service Booking App
 * 
 * Project Status: Firebase Integration Complete ✅
 * - Authentication: Working
 * - Database: Connected  
 * - Location: Permissions Added
 * - Storage: Ready for Blaze Plan Upgrade
 * 
 * Next Phase: Image Uploads and Storage Features
 * 
 * Developer: Dilbar Suhood M
 * Last Updated: August 2025
 */

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickassitnew/common/splash_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/firebase_options.dart';
import 'package:quickassitnew/services/location_provider.dart';
import 'package:quickassitnew/admin/addons_backfill_normalize.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with proper error handling
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
    // Enable App Check in debug mode to silence placeholder token warnings
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
      print('Firebase App Check activated (debug providers).');
    } catch (e) {
      print('App Check activation skipped: $e');
    }

    // Fire-and-forget normalization so startup is never blocked by network
    () async {
      try {
        await BackfillNormalizer.normalizeServices()
            .timeout(const Duration(seconds: 5));
        print('Backfill normalization completed');
      } catch (e) {
        print('Backfill normalization skipped: $e');
      }
    }();
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue with app even if Firebase fails
  }

  // Initialize OneSignal
  try {
    // TODO: Update this with your new OneSignal App ID
    // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    // OneSignal.initialize('YOUR_NEW_ONESIGNAL_APP_ID');
    // OneSignal.Notifications.requestPermission(true).then((value) {
    //   print('signal value: $value');
    // });
    print('OneSignal temporarily disabled - update with your App ID later');
  } catch (e) {
    print('OneSignal initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider())
      ],
      child: MaterialApp(
        title: 'Quick Assist',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: AppBarTheme(
            color: AppColors.scaffoldColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 22, color: Colors.white),
            displayMedium: TextStyle(fontSize: 18, color: Colors.white),
            displaySmall: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Splashpage(),
      ),
    );
  }
}
