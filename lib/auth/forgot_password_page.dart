// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/utils/utils.dart';
import 'package:firebase_auth_project/widgets/cupertino_widgets.dart';
import 'package:firebase_auth_project/widgets/material_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoForgotPasswordPage();
    } else {
      return _buildMaterialForgotPasswordPage();
    }
  }

  Widget _buildCupertinoForgotPasswordPage() {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Reset password'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const FlutterLogo(size: 120),
              const SizedBox(height: 20),
              cupertinoText('Enter an email to \n reset your password'),
              const SizedBox(height: 20),
              cupertinoEmailTextFormField(context, emailController),
              const SizedBox(height: 20),
              cupertinoButton(resetPassword, 'Reset password'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialForgotPasswordPage() {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Reset password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const FlutterLogo(size: 120),
              const SizedBox(height: 20),
              materialText('Enter an email to \n reset your password'),
              const SizedBox(height: 20),
              materialEmailTextFormField(context, emailController),
              const SizedBox(height: 20),
              materialElevatedButton(
                  resetPassword, 'Reset password', Icons.email_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    if (Platform.isIOS) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text("Info",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    content: const Text('Password reset email sent!',
                        style: TextStyle(fontSize: 16)),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                          child:
                              const Text('Ok', style: TextStyle(fontSize: 20)))
                    ]));
      } on FirebaseAuthException catch (error) {
        showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text("Error!", style: TextStyle(fontSize: 20)),
                    content: Text(error.toString(),
                        style: const TextStyle(fontSize: 16)),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.pop(context),
                          child:
                              const Text('Ok', style: TextStyle(fontSize: 16)))
                    ]));
      }
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        Utils.showSnackBar('Password reset email sent!');
        Navigator.of(context).popUntil((route) => route.isFirst);
      } on FirebaseAuthException catch (error) {
        if (kDebugMode) {
          print(error);
        }
        Utils.showSnackBar(error.message);
        Navigator.of(context).pop();
      }
    }
  }
}
