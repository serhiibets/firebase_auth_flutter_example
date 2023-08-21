import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/main.dart';
import 'package:firebase_auth_project/utils/utils.dart';
import 'package:firebase_auth_project/widgets/cupertino_widgets.dart';
import 'package:firebase_auth_project/widgets/material_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpPage({super.key, required this.onClickedSignIn});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoSignUpPage();
    } else {
      return _buildMaterialSignUpPage();
    }
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

  Widget _buildCupertinoSignUpPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 60),
          const FlutterLogo(size: 120),
          const SizedBox(height: 20),
          cupertinoText('Hey There, \n Welcome to the App!'),
          const SizedBox(height: 40),
          cupertinoEmailTextFormField(context, emailController),
          const SizedBox(height: 4),
          cupertinoPasswordTextFormField(context, passwordController),
          const SizedBox(height: 4),
          cupertinoConfirmPasswordTextFormField(
              context, confirmPasswordController),
          const SizedBox(height: 20),
          cupertinoButton(() => signUp(), 'Sign Up'),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24),
                  children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignIn,
                    text: 'Log In',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary))
              ]))
        ]),
      ),
    );
  }

  Widget _buildMaterialSignUpPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 60),
          const FlutterLogo(size: 100),
          const SizedBox(height: 20),
          materialText('Hey There, \n Welcome to the App!'),
          const SizedBox(height: 20),
          materialEmailTextFormField(context, emailController),
          const SizedBox(height: 4),
          materialPasswordTextFormField(context, passwordController),
          const SizedBox(height: 4),
          materialConfirmPasswordTextFormField(
              context, confirmPasswordController, passwordController),
          const SizedBox(height: 20),
          materialElevatedButton(() => signUp(), 'Sign Up', Icons.lock_open),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24),
                  children: [
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignIn,
                    text: 'Log In',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary))
              ]))
        ]),
      ),
    );
  }
}
