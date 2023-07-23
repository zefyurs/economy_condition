import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../add_page/widget.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  void signUp() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage("비밀번호가 일치하지 않습니다.");
      return; // signUp 함수 종료
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // after creating the user, create a new document in cloud firestore called Users
      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
        'username': emailTextController.text.split('@')[0],
        'bio': 'Empty bio..'
        // add any additional fiels as needed
      });

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
                  const Text(
                    "환영합니다. 계정을 만들어주세요",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 25),

                  // email text field
                  MyTextField(
                    controller: emailTextController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),

                  // password text field
                  MyTextField(
                    controller: passwordTextController,
                    hint: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 10),

                  // confirm password text field
                  MyTextField(
                    controller: confirmPasswordTextController,
                    hint: 'Confirm Password',
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 25),

                  // sign in button
                  SizedBox(
                    width: double.infinity,
                    child: SubmmitButton(
                      title: '가입하기',
                      onPressed: signUp,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("이미 계정이 있으신가요?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            '로그인하기',
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
