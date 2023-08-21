import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/auth/forgot_password_page.dart';
import 'package:firebase_auth_project/main.dart';
import 'package:firebase_auth_project/utils/utils.dart';
import 'package:firebase_auth_project/widgets/material_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_project/widgets/cupertino_widgets.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginPage({super.key, required this.onClickedSignUp});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoLoginPage();
    } else {
      return _buildMaterialLoginPage();
    }
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      if (kDebugMode) {
        print(error);
        Utils.showSnackBar(error.message);
      }
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  // Build LoginPage for Android
  Widget _buildMaterialLoginPage() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 60),
          const FlutterLogo(size: 100),
          const SizedBox(height: 20),
          materialText('Hey There, \n Welcome Back!'),
          const SizedBox(height: 40),
          materialEmailTextFormField(context, emailController),
          const SizedBox(height: 4),
          materialPasswordTextFormField(context, passwordController),
          const SizedBox(height: 20),
          materialElevatedButton(() => signIn(), 'Sign In', Icons.lock_open),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage())),
            child: Text('Forgot your password?',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20)),
          ),
          const SizedBox(height: 16),
          RichText(
              text: TextSpan(
                  text: 'No account? ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24),
                  children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: 'Sign Up',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary))
              ]))
        ]));
  }

  // Build LoginPage for iOS
  Widget _buildCupertinoLoginPage() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 60),
          const FlutterLogo(size: 120),
          const SizedBox(height: 20),
          cupertinoText('Hey There, \n Welcome Back!'),
          const SizedBox(height: 40),
          cupertinoEmailTextFormField(context, emailController),
          const SizedBox(height: 4),
          cupertinoPasswordTextFormField(context, passwordController),
          const SizedBox(height: 20),
          cupertinoButton(() => signIn(), 'Sign In'),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => const ForgotPasswordPage())),
            child: Text('Forgot your password?',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20)),
          ),
          const SizedBox(height: 16),
          RichText(
              text: TextSpan(
                  text: 'No account? ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24),
                  children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: 'Sign Up',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary))
              ]))
        ]));
  }
}
