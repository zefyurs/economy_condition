import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economy_condition/add_page/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/consonents.dart';

class AddInterestRate extends StatefulWidget {
  const AddInterestRate({super.key});

  @override
  State<AddInterestRate> createState() => _AddInterestRateState();
}

class _AddInterestRateState extends State<AddInterestRate> {
  final TextEditingController _cpiController = TextEditingController();
  late DateTime todayDate;
  late String countryName;

  String countryChoose = '국가를 선택해주세요';
  List countryList = ['국가를 선택해주세요', '미국', '한국'];

  void postMessage() {
    if (_cpiController.text.isNotEmpty && countryChoose != '국가를 선택해주세요') {
      FirebaseFirestore.instance.collection("US CPI").add({
        "Country": countryChoose,
        "date": todayDate,
        "cpiValue": _cpiController.text,
      });
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 항목을 입력해주세요'),
        ),
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
          title: const Text('미국 CPI 등록'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      // bottomNavigationBar: SubmmitButton(title: '저장하기', onPressed: () => Navigator.of(context).pop()),
      bottomNavigationBar: DecisionButton(
        onPressed: () {
          postMessage();
        },
        title: '저장하기',
      ),
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
