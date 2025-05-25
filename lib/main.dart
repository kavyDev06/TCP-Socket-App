import 'package:flutter/material.dart';
import 'package:tcpsocketapp/pages/home_page.dart';
import 'package:tcpsocketapp/pages/splash_page.dart';
import 'package:tcpsocketapp/routes/Routes.dart';

void main (){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      routes: {
       '/':(context)=>SplashPage(),
        MyRoutes().homePage:(context)=>HomePage(),
      },
    );
  }
}
