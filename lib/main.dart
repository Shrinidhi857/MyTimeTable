import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mytimetable/Theme/darkmode.dart';
import 'package:mytimetable/Theme/lightmode.dart';
import 'package:mytimetable/components/timepage.dart';
import 'package:mytimetable/pages/Forgot_password.dart';
import 'package:mytimetable/pages/home.dart';
import 'package:mytimetable/pages/settings.dart';
import 'package:mytimetable/pages/splash.dart';
import 'package:mytimetable/pages/timetable.dart';
import 'auth/auth.dart';
import 'components/dialogbox.dart';
import 'components/subjectbox.dart';
import 'firebase_options.dart';
// Import the file where you saved the widget

Future<void> main() async {
  await Hive.initFlutter();
  var box =await Hive.openBox('mybox');
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  TextEditingController controller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      darkTheme: darkMode,
      home:const AuthPage(),
      routes:{
        '/home':(context)=>HomePage(),
      '/settingspage':(context) =>SettingsPage(),
      '/forgotpage':(context)=>ForgotPage(),

    },
      debugShowCheckedModeBanner: false,
    );
  }
}
