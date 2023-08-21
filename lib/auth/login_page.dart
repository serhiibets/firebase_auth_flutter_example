import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_project/auth/forgot_password_page.dart';
import 'package:firebase_auth_project/main.dart';
import 'package:firebase_auth_project/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 60),
          const FlutterLogo(size: 120),
          const SizedBox(height: 20),
          const Text(
            'Hey There, \n Welcome Back!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          TextField(
              controller: emailController,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 4),
          TextField(
              controller: passwordController,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Password')),
          const SizedBox(height: 20),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.lock_open, size: 32),
              label: const Text('Sign In', style: TextStyle(fontSize: 24)),
              onPressed: signIn),
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
        ]),
      );

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
}
