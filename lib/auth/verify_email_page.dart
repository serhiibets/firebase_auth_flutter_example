import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/home_page.dart';
import 'package:firebase_auth_project/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      _sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => _checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future _checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future _sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } on FirebaseAuthException catch (error) {
      if (kDebugMode) {
        print(error);
        Utils.showSnackBar(error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Check platform
    if (Platform.isIOS) {
      return isEmailVerified ? HomePage() : _buildCupertino();
    } else {
      return isEmailVerified ? HomePage() : _buildScaffold();
    }
  }

// Build Cupertino for iOS platform
  CupertinoPageScaffold _buildCupertino() => CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Verify email'),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const FlutterLogo(size: 120),
              const SizedBox(height: 40),
              const Text(
                'A verification email will be send!',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                  onPressed: canResendEmail ? _sendVerificationEmail : null,
                  child: const Text('Resend email',
                      style: TextStyle(fontSize: 24))),
              CupertinoButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: const Text('Cancel', style: TextStyle(fontSize: 24))),
            ],
          ),
        ),
      );

// Build Scaffold for Android platform
  Scaffold _buildScaffold() => Scaffold(
        appBar: AppBar(title: const Text('Verify email')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const FlutterLogo(size: 120),
              const SizedBox(height: 40),
              const Text(
                'A verification email will be send!',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  icon: const Icon(Icons.email, size: 32),
                  label: const Text('Resend email',
                      style: TextStyle(fontSize: 24)),
                  onPressed: canResendEmail ? _sendVerificationEmail : null),
              TextButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: const Text('Cansel', style: TextStyle(fontSize: 24))),
            ],
          ),
        ),
      );
}
