import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cardapp/Screens/HomeScreen.dart';
import 'package:cardapp/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAYN1snoiaiVhcbklqwruXpOpFLgtemx70", 
      appId: "1:862996107261:android:a04600851c4dc7df8d9394", 
      messagingSenderId: "862996107261", 
      projectId: "cardapp-e64be",
      authDomain: "cardapp-e64be.firebaseapp.com",
      databaseURL: "https://cardapp-e64be-default-rtdb.firebaseio.com/",
      storageBucket: "cardapp-e64be.appspot.com",
      ),
  );
   runApp(
  DevicePreview(
    builder: (context) => const MyApp(), 
  ),
  // const MyApp()
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
       home: AnimatedSplashScreen(
        splash: const Splash(),
        duration:4000,
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: double.infinity,
        nextScreen: const HomeScreen(title: 'Home Page',),
       ),
      // home: const HomeScreen(title: '',),
    );
  }
}



