import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economy_condition/add_page/widget.dart';
import 'package:economy_condition/view_page/test_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../components/consonents.dart';

class AddCpiPage extends StatefulWidget {
  const AddCpiPage({super.key});

  @override
  State<AddCpiPage> createState() => _AddCpiPageState();
}

class _AddCpiPageState extends State<AddCpiPage> {
  final TextEditingController _cpiController = TextEditingController();
  late DateTime todayDate;
  late String countryName;
  String result = "";
  String resp = "";

  String countryChoose = '국가를 선택해주세요';
  List countryList = ['국가를 선택해주세요', '미국', '한국'];

  void postMessage() {
    if (_cpiController.text.isNotEmpty && countryChoose != '국가를 선택해주세요') {
      FirebaseFirestore.instance.collection("US CPI").add({
        "country": countryChoose,
        "date": todayDate,
        "cpiValue": _cpiController.text,
      });
      Navigator.of(context).pop();
    } else {
      Get.snackbar(
        '누락된 항목이 있습니다.',
        '모든 항목을 입력해주세요',
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
      );
    }

    setState(() {
      _cpiController.clear();
    });
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
          title: const Text('CPI 등록'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    final resp = await Get.to(const TestPage());

                    setState(() {
                      if (resp != null) result = resp;
                    });
                  },
                  child: const Text('테스트 페이지로 이동'),
                ),

                Text(
                  result,
                  style: TextStyle(fontSize: 10),
                ),
                const Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                      'assets/images/cpi_text.jpg',
                    ),
                  ),
                ),
                const SizedBox(height: 80),

                const SizedBox(height: 16),
                BlankContainerSingle(
                  widget: DropdownButton<String>(
                    isExpanded: true,
                    style: TextStyle(
                        color: countryChoose != '국가를 선택해주세요' ? activeTextColor : inActiveTextColor, fontSize: 16),
                    value: countryChoose,
                    underline: const SizedBox(),
                    onChanged: (newValue) {
                      setState(() {
                        countryChoose = newValue.toString();
                      });
                    },
                    items: countryList.map<DropdownMenuItem<String>>((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(
                          valueItem,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

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
                const SizedBox(height: 16),

                // * CPI 입력 field
                MyTextField(
                  controller: _cpiController,
                  hint: 'CPI를 입력하세요',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
              ]),
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
                Expanded(
                  child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: onChanged,
                      mode: CupertinoDatePickerMode.date,
                      minimumDate: DateTime(2000),
                      maximumDate: DateTime.now().add(const Duration(days: 1 * 365))),
                ),
                DecisionButton(title: '확인', onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          );
        });
  }
}
