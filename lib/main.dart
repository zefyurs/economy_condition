import 'package:economy_condition/add_page/add_cpi.dart';
import 'package:economy_condition/add_page/add_interest_rate.dart';
import 'package:economy_condition/add_page/add_trade_balance.dart';
import 'package:economy_condition/view_page/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'add_page/add_loan.dart';
import 'auth/auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('Ko', null).then((_) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.red,
        brightness: Brightness.dark,
        fontFamily: 'Pretendard',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff191919),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.doHyeon(fontSize: 20, color: Colors.amber),
          titleMedium: TextStyle(fontSize: 18, color: Colors.amber),
        ),
      ),
      theme: ThemeData(
        colorSchemeSeed: Colors.yellowAccent,
        brightness: Brightness.light,
        fontFamily: GoogleFonts.doHyeon().fontFamily,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const AuthPage(),
      getPages: [
        GetPage(name: '/auth', page: () => const AuthPage()),
        GetPage(name: '/cpi', page: () => const AddCpiPage()),
        GetPage(name: '/interestRate', page: () => const AddInterestRate()),
        GetPage(name: '/loan', page: () => const AddLoan()),
        GetPage(name: '/tradeBalance', page: () => const AddTradeBalance()),
      ],
    );
  }
}
