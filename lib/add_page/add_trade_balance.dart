import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economy_condition/add_page/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../components/consonents.dart';

class AddTradeBalance extends StatefulWidget {
  const AddTradeBalance({super.key});

  @override
  State<AddTradeBalance> createState() => _AddLoanState();
}

class _AddLoanState extends State<AddTradeBalance> {
  /*
  필요한 input data
  수입, 수출, 무역수지

  수출 항목별(3): 반도체, 자동차, 전기차, 일반기계, 이차전지
  수출 지역별(): 중국, 미국, 아세안, Eu, 
   */
  final TextEditingController _tradeBalance = TextEditingController();
  final TextEditingController _importTotal = TextEditingController();
  final TextEditingController _exportTotal = TextEditingController();
  final TextEditingController _exportCar = TextEditingController();
  final TextEditingController _exportMachine = TextEditingController();
  final TextEditingController _exportSemiconductor = TextEditingController();
  final TextEditingController _exportSteel = TextEditingController();
  final TextEditingController _exportElectricCar = TextEditingController();
  final TextEditingController _exportBattery = TextEditingController();
  final TextEditingController _exportChina = TextEditingController();
  final TextEditingController _exportUS = TextEditingController();
  final TextEditingController _exportAsean = TextEditingController();
  final TextEditingController _exportEU = TextEditingController();

  late DateTime todayDate;

  double bankLoanSummary = 0;

  void postMessage() {
    if (_tradeBalance.text.isNotEmpty &&
        _exportTotal.text.isNotEmpty &&
        _importTotal.text.isNotEmpty &&
        _exportCar.text.isNotEmpty &&
        _exportMachine.text.isNotEmpty &&
        _exportSemiconductor.text.isNotEmpty &&
        _exportSteel.text.isNotEmpty &&
        _exportElectricCar.text.isNotEmpty &&
        _exportBattery.text.isNotEmpty &&
        _exportChina.text.isNotEmpty &&
        _exportUS.text.isNotEmpty &&
        _exportAsean.text.isNotEmpty &&
        _exportEU.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("trade balance").add({
        "date": todayDate,
        "tradeBalance": _tradeBalance.text,
        "exportTotal": _exportTotal.text,
        "importTotal": _importTotal.text,
        "exportCar": _exportCar.text,
        "exportMachine": _exportMachine.text,
        "exportSemiconductor": _exportSemiconductor.text,
        "exportSteel": _exportSteel.text,
        "exportElectricCar": _exportElectricCar.text,
        "exportBattery": _exportBattery.text,
        "exportChina": _exportChina.text,
        "exportUS": _exportUS.text,
        "exportAsean": _exportAsean.text,
        "exportEU": _exportEU.text,
      });

      setState(() {
        _tradeBalance.clear();
        _exportTotal.clear();
        _importTotal.clear();
        _exportCar.clear();
        _exportMachine.clear();
        _exportSemiconductor.clear();
        _exportSteel.clear();
        _exportElectricCar.clear();
        _exportBattery.clear();
      });
      Get.back();
    } else {
      Get.snackbar(
        '누락된 항목이 있습니다.',
        '모든 항목을 입력해주세요',
        backgroundColor: Colors.white.withOpacity(0.8),
        colorText: Colors.black,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    todayDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('수출입 동향 입력'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          )),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text(' 수출입 동향 입력(단위: 억달러)', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),

                  // * Released Date 입력 Field
                  BlankContainerDouble(
                      title: 'Released Date',
                      widget: GestureDetector(
                          onTap: () {
                            myDateTimePicker(context, (date) {
                              setState(() {
                                todayDate = date;
                              });
                            });
                          },
                          child: Text(
                            todayDate.toString().substring(0, 10),
                            style: TextStyle(fontSize: 16, color: activeTextColor),
                          ))),
                  const SizedBox(height: 5),

                  // * 수출입 동향
                  MyTextField(
                    controller: _tradeBalance,
                    hint: '무역수지',
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child: MyTextField(
                        controller: _exportTotal,
                        hint: '수출',
                        keyboardType: TextInputType.datetime,
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _importTotal,
                          hint: '수입',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(' 품목별 수출 상세(단위: 백만달러)', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _exportSemiconductor,
                          hint: '반도체',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _exportCar,
                          hint: '자동차',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _exportMachine,
                          hint: '일반기계',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _exportSteel,
                          hint: '철강',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _exportElectricCar,
                          hint: '전기차',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _exportBattery,
                          hint: '이차전지',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(' 국가별 수출 상세(단위: 백만달러)', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _exportChina,
                          hint: '중국',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _exportUS,
                          hint: '미국',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _exportAsean,
                          hint: '아세안',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _exportEU,
                          hint: 'EU',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ]),
          ),
        ),
      ),
      bottomNavigationBar: DecisionButton(
        onPressed: () => postMessage(),
        title: '저장하기',
      ),
    );
  }

  Future<dynamic> myDateTimePicker(BuildContext context, Function(DateTime) onChanged) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            // padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        'Select Date',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                      initialDateTime: DateTime(DateTime.now().year, DateTime.now().month, 31),
                      onDateTimeChanged: onChanged,
                      mode: CupertinoDatePickerMode.date,
                      minimumDate: DateTime(2000),
                      maximumDate: DateTime.now().add(const Duration(days: 1 * 365))),
                ),
                SubmmitButton(title: '확인', onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          );
        });
  }
}
