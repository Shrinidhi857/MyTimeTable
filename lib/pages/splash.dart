import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mytimetable/auth/auth.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String getThemedImage(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? 'assets/dark/logo.png' : 'assets/light/logo.png';
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthPage()));
    });
  }


  @override
  Widget build(BuildContext context){


    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(getThemedImage(context),scale: 3,),
            Text("MY TIME TABLE",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize:30,

              ),
            )
          ],
        ),
      ),
    );
  }
}