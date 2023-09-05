import 'package:economy_condition/components/consonents.dart';
import 'package:economy_condition/view_page/summary_page.dart';
import 'package:economy_condition/view_page/tradeBalance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'interest_rate.dart';
import 'loan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  int currentIndex = 0;

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(),

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        unselectedFontSize: 14,
        selectedItemColor: mainColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "요약"),
          BottomNavigationBarItem(icon: Icon(Icons.stacked_line_chart_rounded), label: "금리&CPI"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: "가계대출"),
          BottomNavigationBarItem(icon: Icon(Icons.sailing_outlined), label: "수출통계"),
        ],
        currentIndex: currentIndex,
        onTap: (idx) {
          setState(() {
            currentIndex = idx;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () => Get.bottomSheet(
            Wrap(children: [
              ListTile(
                  leading: const Icon(Icons.trending_up_rounded),
                  title: const Text('CPI'),
                  onTap: () {
                    Get.back();
                    Get.toNamed('cpi');
                  }),
              ListTile(
                leading: const Icon(Icons.account_balance_rounded),
                title: const Text('금리'),
                onTap: () {
                  Get.back();
                  Get.toNamed('interestRate');
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart_rounded),
                title: const Text('가계대출'),
                onTap: () {
                  Get.back();
                  Get.toNamed('loan');
                },
              ),
              ListTile(
                leading: const Icon(Icons.sailing_outlined),
                title: const Text('수출입 동향'),
                onTap: () {
                  Get.back();
                  Get.toNamed('tradeBalance');
                },
              ),
              const SizedBox(height: 80),
            ]),
            backgroundColor: tertiaryCardColor),
        tooltip: '추가',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(Icons.add),
      ), //
    );
  }

  Widget getPage() {
    if (currentIndex == 0) {
      return const SummaryPage();
    } else if (currentIndex == 1) {
      return const InterestRate();
    } else if (currentIndex == 2) {
      return const LoanPage();
    } else if (currentIndex == 3) {
      return const TradeBalancePage();
    }
    return Container();
  }
}
