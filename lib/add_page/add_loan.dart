import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economy_condition/add_page/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../components/consonents.dart';

class AddLoan extends StatefulWidget {
  const AddLoan({super.key});

  @override
  State<AddLoan> createState() => _AddLoanState();
}

class _AddLoanState extends State<AddLoan> {
  final TextEditingController _totalLoan = TextEditingController();
  final TextEditingController _bankMorgageTotal = TextEditingController();
  final TextEditingController _bankMorgagePersonnel = TextEditingController();
  final TextEditingController _bankMorgagePolicy = TextEditingController();
  final TextEditingController _bankMorgageRent = TextEditingController();
  final TextEditingController _bankMorgageGroup = TextEditingController();
  final TextEditingController _bankCredit = TextEditingController();
  final TextEditingController _nonBankTotal = TextEditingController();

  late DateTime todayDate;
  late String countryName;

  double bankLoanSummary = 0;

  void getBankLoanSummary() {
    if (_bankMorgagePersonnel.text.isNotEmpty &&
        _bankMorgagePolicy.text.isNotEmpty &&
        _bankMorgageRent.text.isNotEmpty &&
        _bankMorgageGroup.text.isNotEmpty &&
        _bankCredit.text.isNotEmpty) {
      double summary = double.parse(_bankMorgagePersonnel.text) +
          double.parse(_bankMorgagePolicy.text) +
          double.parse(_bankMorgageRent.text) +
          double.parse(_bankMorgageGroup.text) +
          double.parse(_bankCredit.text);

      setState(() {
        bankLoanSummary = summary;
      });
    } else {
      Get.snackbar('은행대출 합계 검증 실패', '데이터 누락 발생');
    }
  }

  void postMessage() {
    if (_totalLoan.text.isNotEmpty &&
        _bankMorgageTotal.text.isNotEmpty &&
        _bankMorgagePersonnel.text.isNotEmpty &&
        _bankMorgagePolicy.text.isNotEmpty &&
        _bankMorgageRent.text.isNotEmpty &&
        _bankMorgageGroup.text.isNotEmpty &&
        _bankCredit.text.isNotEmpty &&
        _nonBankTotal.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("household loan").add({
        // *
        "date": todayDate,
        "totalLoan": _totalLoan.text,
        "bankMorgageTotal": _bankMorgageTotal.text,
        "nonBankTotal": _nonBankTotal.text,
        // *
        "bankMorgagePersonnel": _bankMorgagePersonnel.text,
        "bankMorgagePolicy": _bankMorgagePolicy.text,
        "bankMorgageRent": _bankMorgageRent.text,
        "bankMorgageGroup": _bankMorgageGroup.text,
        "bankCredit": _bankCredit.text,
      });

      setState(() {
        _totalLoan.clear();
        _bankMorgageTotal.clear();
        _bankMorgagePersonnel.clear();
        _bankMorgagePolicy.clear();
        _bankMorgageRent.clear();
        _bankMorgageGroup.clear();
        _bankCredit.clear();
        _nonBankTotal.clear();
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
          title: const Text('가계 대출 동향 입력'),
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
                  // const Center(
                  //   child: CircleAvatar(
                  //     radius: 100,
                  //     backgroundImage: AssetImage(
                  //       'assets/images/interest_text.jpg',
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 80),

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
                  const SizedBox(height: 5),

                  // * 전체 가계 대출
                  MyTextField(
                    controller: _totalLoan,
                    hint: '전 금융권 가계 대출 총액',
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child: MyTextField(
                        controller: _bankMorgageTotal,
                        hint: '은행권(합계)',
                        keyboardType: TextInputType.datetime,
                      )),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _nonBankTotal,
                          hint: '비은행권(합계)',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('  은행 부문별 가계 대출 상세', style: TextStyle(fontSize: 18)),
                  // const Divider(thickness: 0.5),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _bankMorgagePersonnel,
                          hint: '일반 개별 주담대',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _bankMorgagePolicy,
                          hint: '정책 모기지',
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
                          controller: _bankMorgageRent,
                          hint: '전세',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MyTextField(
                          controller: _bankMorgageGroup,
                          hint: '집단대출',
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
                          controller: _bankCredit,
                          hint: '기타대출',
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Expanded(child: SizedBox.shrink()),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                          child:
                              ElevatedButton(onPressed: () => getBankLoanSummary(), child: const Text('은행권 data 검증'))),
                      Expanded(child: Center(child: Text(bankLoanSummary.toString()))),
                    ],
                  ),
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
