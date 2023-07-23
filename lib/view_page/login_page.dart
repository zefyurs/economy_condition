import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../add_page/widget.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void signIn() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Icon(
                    Icons.lock,
                    size: 100,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 50),
                  const Text("환영합니다. 오래기다렸어요.", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 25),

                  // email text field
                  MyTextField(controller: emailTextController, hint: 'Email', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 10),

                  // password text field
                  MyTextField(
                      controller: passwordTextController,
                      hint: 'Password',
                      keyboardType: TextInputType.visiblePassword),
                  const SizedBox(height: 25),

                  // sign in button
                  SizedBox(child: SubmmitButton(title: '로그인', onPressed: signIn), width: double.infinity),
                  const SizedBox(height: 25),

                  // go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("계정이 없으신가요?", style: TextStyle(fontSize: 16)),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            '가입하기',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
