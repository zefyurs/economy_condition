import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economy_condition/add_page/widget.dart';
import 'package:economy_condition/components/consonents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  Color whiteText = Colors.white;
  DateTime today = DateTime.now();
  final currentUser = FirebaseAuth.instance.currentUser!;

  final interestRateStreamChart = FirebaseFirestore.instance
      .collection("US CPI")
      .orderBy("date", descending: false)
      .snapshots(includeMetadataChanges: true);

  final cpiStreamChart = FirebaseFirestore.instance
      .collection("CPI")
      .orderBy("date", descending: false)
      .snapshots(includeMetadataChanges: true);

  final householdLoanStreamChart = FirebaseFirestore.instance
      .collection("household loan")
      .orderBy("date", descending: false)
      .snapshots(includeMetadataChanges: true);

  final tradeBalanceStreamChart = FirebaseFirestore.instance
      .collection("trade balance")
      .orderBy("date", descending: false)
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MainAppbar(whiteText: whiteText, today: today),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // * 기준금리
                    const Text('주요국 금리 현황', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: cardHeight,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          StreamBuilder(
                            stream: interestRateStreamChart,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // * 파이어베이스에서 데이터 가져오기
                                List listChart = snapshot.data!.docs.map((e) {
                                  return {
                                    'country': e['country'],
                                    'date': e['date'],
                                    'value': e['cpiValue'],
                                  };
                                }).toList();
                                List listChartUS = listChart.where((e) => e['country'] == '미국').toList();
                                List listChartKR = listChart.where((e) => e['country'] == '한국').toList();
                                return Row(
                                  children: [
                                    // * 미국 기준 금리
                                    CardWidgetBackground(
                                        color: primaryCardColor,
                                        widget: ContryValue(
                                          image: const AssetImage('assets/images/flag_us.png'),
                                          title: '미국기준금리',
                                          value: '${listChartUS.last['value'].toString()} %',
                                          date: listChartUS.last['date'].toDate().toString().substring(0, 10),
                                        )),
                                    const SizedBox(width: 10),
                                    // * 한국 기준 금리
                                    CardWidgetBackground(
                                        color: secondaryCardColor,
                                        widget: ContryValue(
                                          image: const AssetImage('assets/images/flag_korea.png'),
                                          title: '한국기준금리',
                                          value: '${listChartKR.last['value'].toString()} %',
                                          date: listChartKR.last['date'].toDate().toString().substring(0, 10),
                                        )),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error : ${snapshot.error}'),
                                );
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    // * Cpi
                    const Text('주요국 CPI 현황', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: cardHeight,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          StreamBuilder(
                            stream: cpiStreamChart,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // * 파이어베이스에서 데이터 가져오기
                                List cpiChart = snapshot.data!.docs.map((e) {
                                  return {
                                    'country': e['country'],
                                    'date': e['date'],
                                    'value': e['cpi'],
                                  };
                                }).toList();
                                List cpiChartUS = cpiChart.where((e) => e['country'] == '미국').toList();
                                List cpiChartKR = cpiChart.where((e) => e['country'] == '한국').toList();
                                // * 컨테이너 박스 외형
                                return Row(
                                  children: [
                                    // * 미국 cpi
                                    CardWidgetBackground(
                                        color: primaryCardColor,
                                        widget: ContryValue(
                                          image: const AssetImage('assets/images/flag_us.png'),
                                          title: '미국CPI',
                                          value: '${cpiChartUS.last['value'].toString()} %',
                                          date: cpiChartUS.last['date'].toDate().toString().substring(0, 10),
                                        )),
                                    const SizedBox(width: 10),
                                    // * 한국 CPI
                                    CardWidgetBackground(
                                        color: secondaryCardColor,
                                        widget: ContryValue(
                                          image: const AssetImage('assets/images/flag_us.png'),
                                          title: '미국CPI',
                                          value: '${cpiChartKR.last['value'].toString()} %',
                                          date: cpiChartKR.last['date'].toDate().toString().substring(0, 10),
                                        )),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error : ${snapshot.error}'),
                                );
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                    ),

                    // * 가계대출 추이
                    const SizedBox(height: 25),
                    const Text('가계 대출 현황', style: TextStyle(fontSize: 22)),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 215,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
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
                                return Row(
                                  children: [
                                    // * 전체 가계 대출 추이
                                    CardWidgetBackground(
                                        color: tertiaryCardColor,
                                        widget: GraphValue(
                                            title: '가계대출추이',
                                            widget: loanShortTotalChartProperty(householdChart),
                                            date: householdChart.last['date'].toDate().toString().substring(0, 10))),
                                    const SizedBox(width: 10),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error : ${snapshot.error}'),
                                );
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                    ),
                    // * 무역수치 추이
                    const SizedBox(height: 25),
                    const Text('수출입 동향', style: TextStyle(fontSize: 22)),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 215,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          StreamBuilder(
                            stream: tradeBalanceStreamChart,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                // * 파이어베이스에서 데이터 가져오기
                                List tradeBalanceChart = snapshot.data!.docs.map((e) {
                                  return {
                                    'date': e['date'],
                                    "tradeBalance": e['tradeBalance'],
                                    "exportTotal": e['exportTotal'],
                                    "importTotal": e['importTotal'],
                                    "exportCar": e['exportCar'],
                                    "exportMachine": e['exportMachine'],
                                    "exportSemiconductor": e['exportSemiconductor'],
                                    "exportSteel": e['exportSteel'],
                                    "exportElectricCar": e['exportElectricCar'],
                                    "exportBattery": e['exportBattery'],
                                    "exportChina": e['exportChina'],
                                    "exportUS": e['exportUS'],
                                    "exportAsean": e['exportAsean'],
                                    "exportEU": e['exportEU'],
                                  };
                                }).toList();

                                return Row(
                                  children: [
                                    // * 전체 가계 대출 추이
                                    CardWidgetBackground(
                                        color: tertiaryCardColor,
                                        widget: GraphValue(
                                            title: '무역수지추이',
                                            widget: tradeBalanceShortChartProperty(tradeBalanceChart),
                                            date: tradeBalanceChart.last['date'].toDate().toString().substring(0, 10))),

                                    const SizedBox(width: 10),
                                    CardWidgetBackground(
                                        color: tertiaryCardColor,
                                        widget: GraphValue(
                                            title: '수출입동향',
                                            widget: exportImportShortChartProperty(tradeBalanceChart),
                                            date: tradeBalanceChart.last['date'].toDate().toString().substring(0, 10))),

                                    const SizedBox(width: 10),
                                    CardWidgetBackground(
                                        color: tertiaryCardColor,
                                        widget: GraphValue(
                                            title: '반도체수출',
                                            widget: semiExportShortChartProperty(tradeBalanceChart),
                                            date: tradeBalanceChart.last['date'].toDate().toString().substring(0, 10))),

                                    const SizedBox(width: 10),
                                    CardWidgetBackground(
                                        color: tertiaryCardColor,
                                        widget: GraphValue(
                                            title: '자동차수출',
                                            widget: carExportShortChartProperty(tradeBalanceChart),
                                            date: tradeBalanceChart.last['date'].toDate().toString().substring(0, 10))),

                                    const SizedBox(width: 10),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error : ${snapshot.error}'),
                                );
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SfCartesianChart loanShortTotalChartProperty(List<dynamic> householdChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0.5, color: inActiveBoxColor, dashArray: const <double>[5, 5]),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        rangePadding: ChartRangePadding.auto,
      ),
      series: <ChartSeries>[
        // * 항목별 차트

        LineSeries<dynamic, DateTime>(
          name: '대출순증',
          color: Colors.red,
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

  SfCartesianChart tradeBalanceShortChartProperty(List<dynamic> householdChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0.5, color: inActiveBoxColor, dashArray: const <double>[5, 5]),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        rangePadding: ChartRangePadding.auto,
      ),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom, padding: 5, itemPadding: 10),
      series: <ChartSeries>[
        // * 항목별 차트
        LineSeries<dynamic, DateTime>(
          name: '무역수지',
          color: Colors.red,
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['tradeBalance']))!.round(),
        ),
      ],
    );
  }

  SfCartesianChart exportImportShortChartProperty(List<dynamic> householdChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
          isVisible: false,
          majorGridLines: MajorGridLines(width: 0.5, color: inActiveBoxColor, dashArray: const <double>[5, 5]),
          axisLine: const AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
          minimum: 400,
          maximum: 700),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom, padding: 5, itemPadding: 10),
      series: <ChartSeries>[
        // * 항목별 차트

        LineSeries<dynamic, DateTime>(
          name: '수출',
          color: Colors.red,
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['exportTotal']))!.round(),
        ),
        LineSeries<dynamic, DateTime>(
          name: '수입',
          color: Colors.green,
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['importTotal']))!.round(),
        ),
      ],
    );
  }

  SfCartesianChart semiExportShortChartProperty(List<dynamic> householdChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0.5, color: inActiveBoxColor, dashArray: const <double>[5, 5]),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        // minimum: 400,
        // maximum: 700)
      ),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom, padding: 5, itemPadding: 10),
      series: <ChartSeries>[
        // * 항목별 차트

        LineSeries<dynamic, DateTime>(
          name: '반도체(수출)',
          color: Colors.indigoAccent,
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['exportSemiconductor']))!.round(),
        ),
      ],
    );
  }

  SfCartesianChart carExportShortChartProperty(List<dynamic> householdChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0.5, color: inActiveBoxColor, dashArray: const <double>[5, 5]),
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0, color: inActiveBoxBorder),
        // minimum: 400,
        // maximum: 700)
      ),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom, padding: 5, itemPadding: 10),
      series: <ChartSeries>[
        // * 항목별 차트

        LineSeries<dynamic, DateTime>(
          name: '자동차(수출)',
          color: Colors.green,
          dataSource: householdChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['exportCar']))!.round(),
        ),
      ],
    );
  }
}

class MainAppbar extends StatelessWidget {
  const MainAppbar({
    super.key,
    required this.whiteText,
    required this.today,
  });

  final Color whiteText;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            children: [
              Icon(
                Icons.bug_report,
                size: 20,
                color: whiteText,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  DateFormat('yy년 M월 d일(E)', 'ko').format(today),
                  style: TextStyle(fontSize: 20, color: whiteText),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.notifications,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            'Hello, Hyuckgoo!',
            style: TextStyle(fontSize: 30, color: whiteText),
          )
        ],
      ),
    );
  }
}
