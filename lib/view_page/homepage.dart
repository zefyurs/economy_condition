import 'package:economy_condition/components/consonents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../add_page/add_interest_rate.dart';
import 'interest_rate.dart';

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
      backgroundColor: bgColor,
      appBar: AppBar(title: const Text('주요 경제 지표'), actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            signOut();
          },
        )
      ]),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        unselectedFontSize: 14,
        selectedItemColor: mainColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.stacked_line_chart_rounded), label: "금리&CPI"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: "가계대출"),
          BottomNavigationBarItem(icon: Icon(Icons.sailing_outlined), label: "수출통계"),
          BottomNavigationBarItem(icon: Icon(Icons.house_outlined), label: "부동산통계"),
        ],
        currentIndex: currentIndex,
        onTap: (idx) {
          setState(() {
            currentIndex = idx;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        foregroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              // backgroundColor: Colors.white,
              builder: (ctx) {
                return SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Column(
                    children: [
                      TextButton(
                        child: const Text("금리 & CPI"),
                        onPressed: () async {
                          Navigator.of(context).pop();

                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const AddInterestRate()

                              // FoodAddPage(
                              //           food: Food(
                              //             id: 1,
                              //             date: Utils.getFormatTime(time),
                              //             kcal: 0,
                              //             memo: "",
                              //             type: 0,
                              //             image: "",
                              //           ),
                              ));
                        },
                      ),
                      TextButton(
                        child: const Text("운동"),
                        onPressed: () async {
                          // await Navigator.of(context).push(
                          //     MaterialPageRoute(builder: (ctx) => WorkoutAddPage(
                          //       workout: Workout(
                          //           date: Utils.getFormatTime(time),
                          //           time: 0,
                          //           memo: "",
                          //           name: "",
                          //           image: ""
                          //       ),
                          //     ))
                          // );
                          // getHistories();
                        },
                      ),
                      TextButton(
                        child: const Text("눈바디"),
                        onPressed: () async {
                          // await Navigator.of(context).push(
                          //     MaterialPageRoute(builder: (ctx) => EyeBodyAddPage(
                          //       eyeBody: EyeBody(
                          //           date: Utils.getFormatTime(time),
                          //           weight: 0,
                          //           image: ""
                          //       ),
                          //     ))
                          // );
                          // getHistories();
                        },
                      ),
                    ],
                  ),
                );
              });
        },
        tooltip: '추가',
        child: const Icon(Icons.add),
      ), //
    );
  }

  Widget getPage() {
    if (currentIndex == 0) {
      return InterestRate();
      // } else if (currentIndex == 1) {
      //   return const HistoryPage();
      // }else if(currentIndex == 2){
      //   return getChartPage();
      // }else if(currentIndex == 3){
      //   return getGalleryPage();
    }
    return Container();
  }
}
