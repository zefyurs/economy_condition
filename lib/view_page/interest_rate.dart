import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../components/consonents.dart';

class InterestRate extends StatefulWidget {
  const InterestRate({super.key});

  @override
  State<InterestRate> createState() => _InterestRateState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _InterestRateState extends State<InterestRate> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          const Text('미국 CPI'),
          SizedBox(
            height: 300,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("US CPI")
                  .orderBy(
                    "date",
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var docs = snapshot.data!.docs;

                  // assuming date is unix timestamp in milliseconds and cpiValue is double
                  List<FlSpot> spots = docs.map((doc) {
                    final fbData = doc.data();
                    return FlSpot(
                      (fbData['date'].seconds.toDouble()), // x
                      (double.parse(fbData['cpiValue'])), // y
                    );
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: true),
                        titlesData: FlTitlesData(
                          show: true,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: false,
                              color: mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error : ${snapshot.error}'),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Text("${currentUser.email}"),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }
}
