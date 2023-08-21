import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/auth/auth_page.dart';
import 'package:firebase_auth_project/auth/verify_email_page.dart';
import 'package:firebase_auth_project/firebase_options.dart';
import 'package:firebase_auth_project/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoApp();
    } else {
      return _buildMaterialApp();
    }
  }
}

CupertinoApp _buildCupertinoApp() {
  return CupertinoApp(
    title: 'Firebase Auth Flutter Demo',
    navigatorKey: navigatorKey,
    theme: const CupertinoThemeData(
      brightness: Brightness.light,
    ),
    home: const MainPage(),
    debugShowCheckedModeBanner: false,
  );
}

MaterialApp _buildMaterialApp() {
  return MaterialApp(
    title: 'Firebase Auth Flutter Demo',
    scaffoldMessengerKey: messengerKey,
    navigatorKey: navigatorKey,
    theme: ThemeData(
      brightness: Brightness.light,
      //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
    ),
    themeMode: ThemeMode.dark,
    home: const MainPage(),
    debugShowCheckedModeBanner: false,
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // if iOS platform => Cupertino
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
          child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                } else if (snapshot.hasData) {
                  return const VerifyEmailPage();
                } else {
                  return const AuthPage();
                }
              }));
    } else {
      // is Android platform => Material
      return Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                } else if (snapshot.hasData) {
                  return const VerifyEmailPage();
                } else {
                  return const AuthPage();
                }
              }));
    }
  }
}
