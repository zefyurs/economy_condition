import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view_page/homepage.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(), // tell us if user is logged in or not
      builder: (context, snapshot) {
        // user is logged in
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          // user is Not logged in
          return const LoginOrRegister();
        }
      },
    ));
  }
}
