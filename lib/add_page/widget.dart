import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/consonents.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.keyboardType,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: inActiveBoxColor,
              hoverColor: Colors.yellow.withOpacity(0.2),
              contentPadding: const EdgeInsets.all(24),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: activeBoxBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: inActiveBoxBorder),
              ),
              hintText: hint,
              hintStyle: TextStyle(color: inActiveTextColor, fontSize: 16),
            ),
            style: TextStyle(color: activeTextColor, fontSize: 16)));
  }
}

class BlankContainerSingle extends StatelessWidget {
  const BlankContainerSingle({super.key, required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: inActiveBoxColor,
        border: Border.all(color: inActiveBoxBorder),
      ),
      child: widget,
    );
  }
}

class BlankContainerDouble extends StatelessWidget {
  const BlankContainerDouble({super.key, required this.title, required this.widget});

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: inActiveBoxColor,
        border: Border.all(color: inActiveBoxBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 16,
                color: inActiveTextColor,
              )),
          widget
        ],
      ),
    );
  }
}

// * 하단 버튼 위젯
class SubmmitButton extends StatelessWidget {
  const SubmmitButton({super.key, required this.title, required this.onPressed});
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 70,
        // width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: onPressed,
            child: Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
            )),
      ),
    );
  }
}

// * 취소, 확인 버튼
class DecisionButton extends StatelessWidget {
  const DecisionButton({super.key, required this.title, required this.onPressed});
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: FilledButton.tonal(
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(inActiveBoxColor),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(color: inActiveTextColor, fontSize: 16),
                      )),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: FilledButton.tonal(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(mainColor)),
                      onPressed: onPressed,
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// * 시간 선택 picker

class ThemeContainer extends StatelessWidget {
  const ThemeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: inActiveBoxColor,
        border: Border.all(color: inActiveBoxBorder),
      ),
      child: Text(
        '날짜를 선택하세요',
        style: TextStyle(fontSize: 16, color: inActiveTextColor),
      ),
    );
  }
}

class SmallBotton extends StatelessWidget {
  const SmallBotton({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 16, color: inActiveTextColor),
      child: Container(
        alignment: Alignment.center,
        width: 70,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: inActiveBoxColor,
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}

// * 쿠퍼티노 세그먼트 컨트롤

Widget buildSegmentedControl(int? value, Map<int, Widget> children, ValueChanged<int?> onChanged) {
  return CupertinoSlidingSegmentedControl<int>(
    groupValue: value,
    children: children,
    onValueChanged: onChanged,
  );
}
