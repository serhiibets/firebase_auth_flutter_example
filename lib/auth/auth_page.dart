import 'package:firebase_auth_project/auth/login_page.dart';
import 'package:firebase_auth_project/auth/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(onClickedSignUp: toggle)
        : SignUpPage(onClickedSignIn: toggle);
  }

  void toggle() => setState(() => isLogin = !isLogin);
}
