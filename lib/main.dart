import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lun/firebase_option.dart';
// import 'package:lun/screens/home.dart';
// import 'package:lun/screens/register.dart';
// import 'package:lun/screens/signin.dart';
import 'package:lun/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
        // home: Signin()
        // home: Register()
        // home: Home()
        );
  }
}
