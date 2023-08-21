import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/main.dart';
import 'package:firebase_auth_project/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({super.key, required this.onClickedSignIn});

  @override
  State<SignUpWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpWidget> {
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
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 60),
            const FlutterLogo(size: 120),
            const SizedBox(height: 20),
            const Text(
              'Hey There, \n Welcome to the App!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: passwordController,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value) != null && (value.length < 8)
                  ? 'Enter min 8 characters'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => (value) != null &&
                      (value.length < 8) &&
                      (value != passwordController.text)
                  ? 'Passwords missmatch!'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.lock_open, size: 32),
                label: const Text('Sign Up', style: TextStyle(fontSize: 24)),
                onPressed: signUp),
            const SizedBox(height: 24),
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
}
