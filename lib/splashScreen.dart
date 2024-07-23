import 'package:cardapp/constants.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/AnimationLogo.png'),
          const Text("CardApp",style: TextStyle(fontSize: 20.0,fontFamily: 'JosefinSans',color: kbgColor),),
        ],
      ),
    );
  }
}
