import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tcpsocketapp/routes/Routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      Navigator.of(context).pushReplacementNamed(MyRoutes().homePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            FlutterLogo(size:100,),
            Text("Socket App",style: TextStyle(fontSize:  24, fontFamily: 'SF Pro Display',fontWeight: FontWeight.w600),),
          ],
        ),
      ),
    );
  }
}
