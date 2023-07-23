import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData(
      //   colorSchemeSeed: Colors.red,
      //   brightness: Brightness.dark,
      //   fontFamily: 'GmarketSansTTF',
      //   useMaterial3: true,
      // ),
      theme: ThemeData(
        colorSchemeSeed: Colors.yellowAccent,
        brightness: Brightness.dark,
        fontFamily: 'Pretendard',
        // fontFamily: GoogleFonts.nanumGothic().fontFamily,

        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}
