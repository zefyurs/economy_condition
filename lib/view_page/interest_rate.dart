import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economy_condition/add_page/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../components/consonents.dart';
import '../components/helper.dart';

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

  List<int> years = [2020, 2021, 2022, 2023];
  Set<int> yearSelected = {};
  int? minYear;
  int? maxYear;

  @override
  void initState() {
    super.initState();
    // minYear = years.first;
    // yearSelected.add(minYear);
  }

  // * 파이어베이스 금리
  final interestRateStreamChart = FirebaseFirestore.instance
      .collection("US CPI")
      .orderBy("date", descending: false)
      .snapshots(includeMetadataChanges: true);

  final cpiStreamChart = FirebaseFirestore.instance
      .collection("CPI")
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
            title: '주요국 금리 및 CPI 추이',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
                child: Column(children: [
                  // * 차트영역
                  //
                  // * 1) 한미금리 비교 차트
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

                        // * 한미 금리 격차 계산
                        List listChartUS = listChart.where((e) => e['country'] == '미국').toList();
                        List listChartKR = listChart.where((e) => e['country'] == '한국').toList();
                        double lastUSvalue = double.parse(listChartUS.last['value']);
                        double lastKRvalue = double.parse(listChartKR.last['value']);
                        // double interesterateGap = lastUSvalue - lastKRvalue;

                        // * 컨테이너 박스 외형
                        return ChartWidget(
                          chartIcon: Icons.traffic,
                          chartTitle: '한미 금리 추이(단위:%)',
                          onPress: () => showInterestRateDialog(),
                          chartHeight: 300,
                          child: interestRateChartProperty(listChart),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error : ${snapshot.error}'),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  //
                  const SizedBox(height: 5),
                  //

                  // * 2) 한미 CPI 비교 차트
                  StreamBuilder(
                    stream: cpiStreamChart,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // * 파이어베이스에서 데이터 가져오기
                        List cpiListChart = snapshot.data!.docs.map((e) {
                          return {
                            'country': e['country'],
                            'date': e['date'],
                            'value': e['cpi'],
                          };
                        }).toList();

                        return ChartWidget(
                          chartIcon: Icons.attach_money,
                          chartTitle: '한미 CPI 추이(단위:%)',
                          onPress: () => showCPIDialog(),
                          chartHeight: 250,
                          child: cpiChartProperty(cpiListChart),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error : ${snapshot.error}'),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SfCartesianChart interestRateChartProperty(List<dynamic> listChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        minimum: minYear == null
            ? DateTime.parse(listChart.first['date'].toDate().toString())
            : DateTime(int.parse(minYear.toString()), 1, 1),
        maximum: maxYear == null
            ? DateTime.parse(listChart.last['date'].toDate().toString())
            : DateTime(int.parse(maxYear.toString()), 12, 31),
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        plotOffset: 20.0,
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 5, color: inActiveBoxBorder),
        rangePadding: ChartRangePadding.auto,
        labelStyle: TextStyle(color: inActiveTextColor, fontSize: 10),
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
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
      series: <ChartSeries>[
        // * chart data
        StepLineSeries<dynamic, DateTime>(
          name: '미국',
          color: Colors.blue,
          width: 3,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              overflowMode: OverflowMode.none,
              isVisible: true,
              textStyle: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                // fontWeight: FontWeight.bold,
              )),
          dataSource: listChart.where((e) => e['country'] == '미국').toList(),
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => double.tryParse(data['value']),
        ),
        StepLineSeries<dynamic, DateTime>(
          name: '한국',
          color: Colors.red,
          width: 3,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              color: Colors.red,
              fontSize: 12,
              // fontWeight: FontWeight.bold,
            ),
          ),
          dataSource: listChart.where((e) => e['country'] == '한국').toList(),
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => double.tryParse(data['value']),
        ),
      ],
    );
  }

  SfCartesianChart cpiChartProperty(List<dynamic> cpiListChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        minimum: minYear == null
            ? DateTime.parse(cpiListChart.first['date'].toDate().toString())
            : DateTime(int.parse(minYear.toString()), 1, 1),
        maximum: maxYear == null
            ? DateTime.parse(cpiListChart.last['date'].toDate().toString())
            : DateTime(int.parse(maxYear.toString()), 12, 31),
        majorGridLines: MajorGridLines(width: 0, color: inActiveBoxColor),
        plotOffset: 20.0,
        axisLine: const AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 5, color: inActiveBoxBorder),
        rangePadding: ChartRangePadding.auto,
        labelStyle: TextStyle(color: inActiveTextColor, fontSize: 10),
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
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
      series: <ChartSeries>[
        // * chart data
        LineSeries<dynamic, DateTime>(
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.diamond,
            borderWidth: 1,
            height: 6,
            width: 6,
          ),
          name: '미국',
          color: Colors.blue,
          enableTooltip: true,
          dataSource: cpiListChart.where((e) => e['country'] == '미국').toList(),
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => double.tryParse(data['value']),
        ),
        LineSeries<dynamic, DateTime>(
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.diamond,
            borderWidth: 1,
            height: 6,
            width: 6,
          ),
          name: '한국',
          color: Colors.red,
          enableTooltip: true,
          dataSource: cpiListChart.where((e) => e['country'] == '한국').toList(),
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => double.tryParse(data['value']),
        ),
      ],
    );
  }

  void showInterestRateDialog() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15),
      title: 'Interst Rate',
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      content: Column(
        children: [
          const Text('이 차트는 한/미 금리차를 나타내고 있습니다. 국가별 데이터는 아래 사이트에서 확인가능합니다.'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Uri urlLink = Uri.parse('https://www.investing.com/economic-calendar/interest-rate-decision-168');
                      customLaunchUrl(urlLink);
                    },
                    child: const Text('미국금리')),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Uri urlLink =
                          Uri.parse('https://www.bok.or.kr/portal/singl/baseRate/list.do?dataSeCd=01&menuNo=200643');
                      customLaunchUrl(urlLink);
                    },
                    child: const Text('한국금리')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showCPIDialog() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15),
      title: 'CPI',
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      content: Column(
        children: [
          const Text(
              'CPI는 소비자물가(총지수)로, 소비자가 일정기간 동안 구입한 상품과 용역의 가격을 종합적으로 나타낸 지수입니다.\n해당 차트는 지수data가 아닌 전년동월비 data로, 아래 사이트에서 매월초 확인가능합니다.'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Uri urlLink = Uri.parse('https://in.investing.com/economic-calendar/cpi-733');
                      customLaunchUrl(urlLink);
                    },
                    child: const Text('미국CPI')),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Uri urlLink = Uri.parse('https://kostat.go.kr/cpidtval.es?mid=b70201010000');
                      customLaunchUrl(urlLink);
                    },
                    child: const Text('한국CPI')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
