import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../add_page/widget.dart';
import '../components/consonents.dart';
import '../components/helper.dart';

class TradeBalancePage extends StatefulWidget {
  const TradeBalancePage({super.key});

  @override
  State<TradeBalancePage> createState() => _LoanPageState();
}

void signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _LoanPageState extends State<TradeBalancePage> {
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
  final tradeBalanceStreamChart = FirebaseFirestore.instance
      .collection("trade balance")
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

                        // * 컨테이너 박스 외형
                        return Column(children: [
                          ChartWidget(
                            chartIcon: Icons.traffic,
                            chartTitle: '무역수지 추이(단위: 억달러)',
                            onPress: () => showTradeBalanceDialog(),
                            chartHeight: 150,
                            child: tradeBalanceDetailChartProperty(tradeBalanceChart),
                          ),
                          const SizedBox(height: 5),
                          ChartWidget(
                            chartIcon: Icons.traffic,
                            chartTitle: '수출입 동향 추이(단위: 억달러)',
                            onPress: () => showTradeBalanceDialog(),
                            chartHeight: 250,
                            child: tradeBalanceChartProperty(tradeBalanceChart),
                          ),
                          const SizedBox(height: 5),
                          ChartWidget(
                              chartIcon: Icons.traffic,
                              chartTitle: '품목별 수출 추이(단위: 억달러)',
                              onPress: () {},
                              chartHeight: 400,
                              child: partExportComparisionChartProperty(tradeBalanceChart)),
                          const SizedBox(height: 5),
                          ChartWidget(
                              chartIcon: Icons.traffic,
                              chartTitle: '국가별 수출 추이(단위: 억달러)',
                              onPress: () {},
                              chartHeight: 320,
                              child: countryExportComparisionChartProperty(tradeBalanceChart))
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

  SfCartesianChart tradeBalanceChartProperty(List<dynamic> tradeBalanceChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      enableSideBySideSeriesPlacement: false,
      primaryXAxis: DateTimeAxis(
        minimum: minYear == null
            ? DateTime(
                DateTime.parse((tradeBalanceChart.first['date'].toDate()).toString()).year,
                DateTime.parse((tradeBalanceChart.first['date'].toDate()).toString()).month,
                DateTime.parse((tradeBalanceChart.first['date'].toDate()).toString()).day - 10)
            : DateTime(int.parse(minYear.toString()), 1, 1),
        maximum: maxYear == null
            ? DateTime(
                DateTime.parse((tradeBalanceChart.last['date'].toDate()).toString()).year,
                DateTime.parse((tradeBalanceChart.last['date'].toDate()).toString()).month,
                DateTime.parse((tradeBalanceChart.last['date'].toDate()).toString()).day + 10)
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
        minimum: 300,
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
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.xy, enablePanning: true),
      series: <ChartSeries>[
        // * 항목별 차트
        //
        LineSeries<dynamic, DateTime>(
          name: '수입액',
          width: 0.7,
          color: Colors.green,
          // borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.outer,
              angle: 270,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.green, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['importTotal']))!.round(),
        ),
        LineSeries<dynamic, DateTime>(
          width: 0.5,
          name: '수출액',
          color: Colors.red,
          // borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.bottom,
              isVisible: true,
              showZeroValue: false,
              angle: 270,
              textStyle: TextStyle(color: Colors.red, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['exportTotal']))!.round(),
        ),
        // LineSeries<dynamic, DateTime>(
        //   name: '무역수지',
        //   color: Colors.red,
        //   enableTooltip: true,
        //   // dataLabelSettings: const DataLabelSettings(
        //   //     labelAlignment: ChartDataLabelAlignment.top,
        //   //     isVisible: true,
        //   //     showZeroValue: false,
        //   //     textStyle: TextStyle(color: Colors.white, fontSize: 10)),
        //   dataSource: tradeBalanceChart,
        //   xValueMapper: (dynamic data, _) {
        //     final date = DateTime.parse(data['date'].toDate().toString());
        //     return date;
        //   },
        //   yValueMapper: (dynamic data, _) => (double.tryParse(data['tradeBalance']))!.round(),
        // ),

        // //
      ],
    );
  }

  SfCartesianChart tradeBalanceDetailChartProperty(List<dynamic> tradeBalanceChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      enableSideBySideSeriesPlacement: false,
      primaryXAxis: DateTimeAxis(
        minimum: minYear == null
            ? DateTime(
                DateTime.parse((tradeBalanceChart.first['date'].toDate()).toString()).year,
                DateTime.parse((tradeBalanceChart.first['date'].toDate()).toString()).month,
                DateTime.parse((tradeBalanceChart.first['date'].toDate()).toString()).day - 10)
            : DateTime(int.parse(minYear.toString()), 1, 1),
        maximum: maxYear == null
            ? DateTime(
                DateTime.parse((tradeBalanceChart.last['date'].toDate()).toString()).year,
                DateTime.parse((tradeBalanceChart.last['date'].toDate()).toString()).month,
                DateTime.parse((tradeBalanceChart.last['date'].toDate()).toString()).day + 10)
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
      // legend: const Legend(
      //   isVisible: true,
      //   position: LegendPosition.bottom,
      //   textStyle: TextStyle(color: Colors.white, letterSpacing: -1.0, fontSize: 10),
      // ),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.xy, enablePanning: true),
      series: <ChartSeries>[
        // * 항목별 차트
        LineSeries<dynamic, DateTime>(
          name: '무역수지',
          color: Colors.black87,
          width: 1.0,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.outer,
              // angle: 270,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.black54, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => (double.tryParse(data['tradeBalance']))!.round(),
        ),

        // //
      ],
    );
  }

  // * 품목별 수출 추이
  SfCartesianChart partExportComparisionChartProperty(List<dynamic> tradeBalanceChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        minimum: minYear == null
            ? DateTime.parse(tradeBalanceChart.first['date'].toDate().toString())
            : DateTime(int.parse(minYear.toString()), 1, 1),
        maximum: maxYear == null
            ? DateTime.parse(tradeBalanceChart.last['date'].toDate().toString())
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
        textStyle: TextStyle(color: Colors.white, letterSpacing: -1.0, fontSize: 10),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
      series: <ChartSeries>[
        // * 항목별 차트
        //

        LineSeries<dynamic, DateTime>(
          // trendlines: <Trendline>[
          //   Trendline(
          //     type: TrendlineType.linear,
          //     color: Colors.red,
          //     width: 2,
          //     dashArray: <double>[5, 5],
          //     opacity: 0.9,
          //     name: '추세선',
          //     legendIconType: LegendIconType.diamond,
          //     polynomialOrder: 3,
          //     backwardForecast: 0,
          //     forwardForecast: 0,
          //     isVisibleInLegend: true,
          //     intercept: 0,
          //     period: 2,
          //     // widthType: TrendlineWidthType.pixel,
          //     // value: 0.5,
          //   )
          // ],
          name: '반도체',
          color: Colors.red,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.red, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportSemiconductor']))!.round() / 100).ceil(),
        ),
        LineSeries<dynamic, DateTime>(
          name: '자동차',
          color: Colors.green,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.green, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportCar']))!.round() / 100).ceil(),
        ),

        LineSeries<dynamic, DateTime>(
          name: '철강제품',
          color: Colors.orange,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.orange, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportSteel']))!.round() / 100).ceil(),
        ),
        LineSeries<dynamic, DateTime>(
          name: '일반기계',
          color: Colors.grey,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.grey, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportMachine']))!.round() / 100).ceil(),
        ),
        LineSeries<dynamic, DateTime>(
          name: '배터리',
          color: Colors.lime,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.bottom,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.lime, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportBattery']))!.round() / 100).ceil(),
        ),
        LineSeries<dynamic, DateTime>(
          name: '전기차',
          color: Colors.blue,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.blue, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportElectricCar']))!.round() / 100).ceil(),
        ),
      ],
    );
  }

// * 국가별 수출 추이
  SfCartesianChart countryExportComparisionChartProperty(List<dynamic> tradeBalanceChart) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        minimum: minYear == null
            ? DateTime.parse(tradeBalanceChart.first['date'].toDate().toString())
            : DateTime(int.parse(minYear.toString()), 1, 1),
        maximum: maxYear == null
            ? DateTime.parse(tradeBalanceChart.last['date'].toDate().toString())
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
        minimum: 50,
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
        textStyle: TextStyle(color: Colors.white, letterSpacing: -1.0, fontSize: 10),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
      series: <ChartSeries>[
        // * 항목별 차트
        //

        LineSeries<dynamic, DateTime>(
          name: '중국',
          color: Colors.red,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.red, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportChina']))!.round() / 100).ceil(),
        ),
        LineSeries<dynamic, DateTime>(
          name: '미국',
          color: Colors.green,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.green, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportUS']))!.round() / 100).ceil(),
        ),
        LineSeries<dynamic, DateTime>(
          name: '아세안',
          color: Colors.orange,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.bottom,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.orange, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportAsean']))!.round() / 100).ceil(),
        ),
        LineSeries<dynamic, DateTime>(
          name: 'EU',
          color: Colors.blue,
          enableTooltip: true,
          dataLabelSettings: const DataLabelSettings(
              labelAlignment: ChartDataLabelAlignment.top,
              isVisible: true,
              showZeroValue: false,
              textStyle: TextStyle(color: Colors.blue, fontSize: 10)),
          dataSource: tradeBalanceChart,
          xValueMapper: (dynamic data, _) {
            final date = DateTime.parse(data['date'].toDate().toString());
            return date;
          },
          yValueMapper: (dynamic data, _) => ((double.tryParse(data['exportEU']))!.round() / 100).ceil(),
        ),
      ],
    );
  }

  void showTradeBalanceDialog() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15),
      title: '수추입 동향 추이',
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      content: Column(
        children: [
          const Text(
            '산업통상자원부에서 매월1일 발표함',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    Uri urlLink =
                        Uri.parse('https://www.motie.go.kr/motie/ne/presse/press2/bbs/bbsList.do?bbs_cd_n=81');
                    customLaunchUrl(urlLink);
                  },
                  child: const Text('산업통상자원부')),
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
