import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../add_page/widget.dart';
import '../components/consonents.dart';
import '../components/helper.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _LoanPageState extends State<LoanPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  List<int> years = [2020, 2021, 2022, 2023];
  Set<int> yearSelected = {};
  int? minYear;
  int? maxYear;

  @override
  void initState() {
    super.initState();
  }

  // * 파이어베이스 데이터
  final householdLoanStreamChart = FirebaseFirestore.instance
      .collection("household loan")
      .orderBy("date", descending: false)
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ChartPageAppBar(
            years: years,
            yearSelected: yearSelected,
            onChanged: (selected) {
              setState(() {
                yearSelected = selected;
                List<int> yearSelectedList = yearSelected.toList()..sort();
                yearSelected = yearSelectedList.toSet();

                if (yearSelected.isEmpty) {
                  minYear = null;
                  maxYear = null;
                } else {
                  minYear = yearSelected.first;
                  maxYear = yearSelected.last;
                }
              });
            },
            title: '가계대출 추이',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
                child: Column(children: [
                  StreamBuilder(
                    stream: householdLoanStreamChart,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // * 파이어베이스에서 데이터 가져오기
                        List householdChart = snapshot.data!.docs.map((e) {
                          return {
                            'date': e['date'],
                            'totalLoan': e['totalLoan'],
                            'bankMorgageTotal': e['bankMorgageTotal'],
                            'nonBankTotal': e['nonBankTotal'],
                            'bankMorgagePersonnel': e['bankMorgagePersonnel'],
                            'bankMorgagePolicy': e['bankMorgagePolicy'],
                            'bankMorgageRent': e['bankMorgageRent'],
                            'bankMorgageGroup': e['bankMorgageGroup'],
                            'bankCredit': e['bankCredit'],
                          };
                        }).toList();

                        // * 컨테이너 박스 외형
                        return Column(children: [
                          ChartWidget(
                            chartIcon: Icons.traffic,
                            chartTitle: '가계대출 추이',
                            onPress: () => showLoanTotalDialog(),
                            chartHeight: 300,
                            child: loanTotalChartProperty(householdChart),
                          ),
                          const SizedBox(height: 5),
                          ChartWidget(
                              chartIcon: Icons.traffic,
                              chartTitle: '은행 대출 항목별 추이(단위:조)',
                              onPress: () {},
                              chartHeight: 300,
                              child: loanDetailChartProperty(householdChart))
                        ]);
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error : ${snapshot.error}'),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SfCartesianChart loanDetailChartProperty(List<dynamic> householdChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        minimum: minYear == null
            ? DateTime(
                DateTime.parse((householdChart.first['date'].toDate()).toString()).year,
                DateTime.parse((householdChart.first['date'].toDate()).toString()).month,
                DateTime.parse((householdChart.first['date'].toDate()).toString()).day - 10)
            : DateTime(int.parse(minYear.toString()), 1, 1),
        maximum: maxYear == null
            ? DateTime(
                DateTime.parse((householdChart.last['date'].toDate()).toString()).year,
                DateTime.parse((householdChart.last['date'].toDate()).toString()).month + 1,
                DateTime.parse((householdChart.last['date'].toDate()).toString()).day)
            : DateTime(int.parse(maxYear.toString()), 12, 31),
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        plotOffset: 20.0,
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 5, color: inActiveBoxBorder),
        rangePadding: ChartRangePadding.auto,
        labelStyle: TextStyle(color: inActiveTextColor, fontSize: 10),
        intervalType: DateTimeIntervalType.months,
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0.5, color: yAxisLineColor, dashArray: const <double>[3, 3]),
        plotOffset: 5.0,
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        rangePadding: ChartRangePadding.auto,
        labelStyle: TextStyle(color: inActiveTextColor, fontSize: 10),
      ),
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        // overflowMode: LegendItemOverflowMode.wrap,
        // padding: 20,
        textStyle: TextStyle(color: Colors.white, letterSpacing: -1.0, fontSize: 10),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
      series: <ChartSeries>[
        // * 항목별 차트
        //
        //

        StackedColumnSeries<dynamic, DateTime>(
          name: '일반개별',
          color: Colors.red,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.middle,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.white, fontSize: 10)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['bankMorgagePersonnel']))!.round(),
        ),
        //
        StackedColumnSeries<dynamic, DateTime>(
          name: '집단대출',
          color: Colors.red.shade800,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.middle,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.white, fontSize: 10)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['bankMorgageGroup']))!.round(),
        ),
        //
        StackedColumnSeries<dynamic, DateTime>(
          name: '정책모기지',
          color: Colors.green,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.middle,
              isVisible: true,
              textStyle: TextStyle(color: Colors.white, fontSize: 10)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['bankMorgagePolicy']))!.round(),
        ),
        //
        StackedColumnSeries<dynamic, DateTime>(
          name: '전세',
          color: Colors.blue.shade800,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              showZeroValue: false,
              labelAlignment: ChartDataLabelAlignment.middle,
              isVisible: true,
              textStyle: TextStyle(color: Colors.white, fontSize: 10)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['bankMorgageRent']))!.round(),
        ),
        StackedColumnSeries<dynamic, DateTime>(
          name: '은행(기타신용)',
          color: Colors.grey,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.middle,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.white, fontSize: 10)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['bankCredit']))!.round(),
        ),
        LineSeries<dynamic, DateTime>(
          name: '은행',
          color: mainColor,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.middle,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.white, fontSize: 10)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['bankMorgageTotal']))!.round(),
        ),
      ],
    );
  }

  SfCartesianChart loanTotalChartProperty(List<dynamic> householdChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        minimum: minYear == null
            ? DateTime(
                DateTime.parse((householdChart.first['date'].toDate()).toString()).year,
                DateTime.parse((householdChart.first['date'].toDate()).toString()).month,
                DateTime.parse((householdChart.first['date'].toDate()).toString()).day - 10)
            : DateTime(int.parse(minYear.toString()), 1, 1),
        maximum: maxYear == null
            ? DateTime(
                DateTime.parse((householdChart.last['date'].toDate()).toString()).year,
                DateTime.parse((householdChart.last['date'].toDate()).toString()).month + 1,
                DateTime.parse((householdChart.last['date'].toDate()).toString()).day)
            : DateTime(int.parse(maxYear.toString()), 12, 31),
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        plotOffset: 20.0,
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 5, color: inActiveBoxBorder),
        rangePadding: ChartRangePadding.auto,
        labelStyle: TextStyle(color: inActiveTextColor, fontSize: 10),
      ),
      primaryYAxis: NumericAxis(
        // rangePadding: ChartRangePadding.round,

        majorGridLines: MajorGridLines(width: 0.5, color: yAxisLineColor, dashArray: const <double>[3, 3]),

        plotOffset: 5.0,
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        rangePadding: ChartRangePadding.auto,
        labelStyle: TextStyle(color: inActiveTextColor, fontSize: 10),
      ),
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: TextStyle(letterSpacing: -1.0, fontSize: 12),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
      series: <ChartSeries>[
        // * 항목별 차트
        //

        StackedColumnSeries<dynamic, DateTime>(
          name: '은행',
          color: primaryCardColor,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.middle,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.white, fontSize: 9)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['bankMorgageTotal']))!.round(),
        ),
        StackedColumnSeries<dynamic, DateTime>(
          name: '2금융권',
          color: secondaryCardColor,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.middle,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.white, fontSize: 9)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['nonBankTotal']))!.round(),
        ),
        //
        LineSeries<dynamic, DateTime>(
          name: '대출순증',
          color: Colors.black87,
          width: 1,
          enableTooltip: true,
          // dataLabelSettings: const DataLabelSettings(
          //     labelAlignment: ChartDataLabelAlignment.middle,
          //     isVisible: true,
          //     showZeroValue: false,
          //     textStyle: TextStyle(color: Colors.white, fontSize: 10)),
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['totalLoan']))!.round(),
        ),
      ],
    );
  }

  void showLoanTotalDialog() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15),
      title: '가계 대출 동향',
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      content: Column(
        children: [
          const Text(
            '금융위원회에서 매월 2주차 목요일 \n보도자료 발표',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    Uri urlLink = Uri.parse('https://www.fsc.go.kr/no010101');
                    customLaunchUrl(urlLink);
                  },
                  child: const Text('금융위원회 보도자료')),
            ),
            // Expanded(
            //   child: ElevatedButton(
            //     onPressed: () => Get.back(),
            //     child: const Text('닫기'),
            //   ),
            // )
          ]),
        ],
      ),
    );
  }
}
