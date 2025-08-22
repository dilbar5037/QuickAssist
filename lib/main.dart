import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickassitnew/common/splash_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/firebase_options.dart';
import 'package:quickassitnew/services/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with proper error handling
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
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
                iconTheme: IconThemeData(color: Colors.white)
            ),
            useMaterial3: true,
            textTheme: TextTheme(
                displayLarge: TextStyle(fontSize:22 ,color: Colors.white),
                displayMedium: TextStyle(fontSize: 18,color: Colors.white),
                displaySmall: TextStyle(fontSize: 16,color: Colors.white)
            )
        ),
        debugShowCheckedModeBanner: false,
        home: Splashpage(),
      ),
    );
  }
}


