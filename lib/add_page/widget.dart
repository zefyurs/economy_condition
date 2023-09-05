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
              labelText: hint,
              labelStyle: TextStyle(color: inActiveTextColor, fontSize: 16),
            ),
            style: TextStyle(color: activeTextColor, fontSize: 18)));
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
      child: Center(
        child: SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.9,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: onPressed,
              child: Text(
                title,
                style: TextStyle(color: bgColor, fontSize: 16),
              )),
        ),
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
                      style: TextStyle(color: bgColor, fontSize: 16),
                    )),
              ),
            ),
          ],
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

class ChartWidget extends StatelessWidget {
  const ChartWidget({
    super.key,
    required this.chartIcon,
    required this.chartTitle,
    required this.onPress,
    required this.chartHeight,
    required this.child,
  });

  final IconData chartIcon;
  final String chartTitle;
  final void Function() onPress;
  final double chartHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: tertiaryCardColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          // * 표 제목
          Row(
            children: <Widget>[
              Icon(chartIcon, color: mainColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  chartTitle,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              IconButton(onPressed: onPress, icon: const Icon(Icons.more_vert), color: inActiveTextColor)
            ],
          ),
          Container(
            height: chartHeight,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: child,
          ),
        ],
      ),
    );
  }
}

class CardWidgetBackground extends StatelessWidget {
  const CardWidgetBackground({super.key, required this.widget, required this.color});
  final Widget widget;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: widget);
  }
}

class ContryValue extends StatelessWidget {
  const ContryValue({super.key, required this.image, required this.title, required this.value, required this.date});

  final ImageProvider image;
  final String title;
  final String value;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: image,
          ),
          // const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 22, color: activeTextColor),
          ),
          Column(
            children: [
              Align(alignment: Alignment.centerRight, child: Text(value, style: recentValue)),
              Align(
                alignment: Alignment.centerRight,
                child: Text(date, style: recentDate),
              ),
            ],
          )
        ]);
  }
}

class GraphValue extends StatelessWidget {
  const GraphValue({super.key, required this.title, required this.widget, required this.date});

  final String title;
  final Widget widget;
  final String date;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22),
        ),
        SizedBox(
          // color: Colors.amber,
          height: 140,
          child: widget,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Text(date, style: recentDate.copyWith(color: Colors.grey.shade600))),
      ],
    );
  }
}

class ChartPageAppBar extends StatelessWidget {
  const ChartPageAppBar(
      {super.key, required this.title, required this.years, required this.yearSelected, required this.onChanged});

  final String title;
  final List<int> years;
  final Set<int> yearSelected;
  final void Function(Set<int>) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 70),
            Text(
              title,
              style: TextStyle(fontSize: 30, color: activeTextColor),
            ),
            const SizedBox(height: 20),
            Text(
              '검색하고 싶은 연도를 선택해주세요.',
              style: TextStyle(fontSize: 16, color: activeTextColor),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SegmentedButton(
                style: ButtonStyle(
                  side: MaterialStateBorderSide.resolveWith(
                    (states) => const BorderSide(color: Colors.white, width: 0.5),
                  ),
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(activeTextColor),
                  overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                segments: years.map((year) {
                  return ButtonSegment(
                    value: year,
                    label: Text(year.toString()),
                  );
                }).toList(),
                selected: yearSelected,
                emptySelectionAllowed: true,
                multiSelectionEnabled: true,
                onSelectionChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
