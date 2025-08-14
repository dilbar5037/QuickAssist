import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickassitnew/common/splash_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/firebase_options.dart';
import 'package:quickassitnew/services/location_provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('b644b0de-2792-4da5-9df7-a7f71aca8d92');
  OneSignal.Notifications.requestPermission(true).then((value) {
    print('signal value: $value');
  }
  );
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


