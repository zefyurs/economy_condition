import 'package:economy_condition/view_page/test_page.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class GetXPractice extends StatelessWidget {
  const GetXPractice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text('GetX Practice'),
            const Text('Navigation test'),
            ElevatedButton(
              onPressed: () {
                Get.to(const TestPage(), transition: Transition.fade);
              },
              child: const Text('GetX'),
            ),
            ElevatedButton(
                onPressed: () => Get.snackbar(
                      'title',
                      'message',
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(Icons.question_mark),
                    ),
                child: const Text('snackbar')),
            ElevatedButton(
              onPressed: () => Get.defaultDialog(
                title: 'title',
                middleText: 'middleText',
                textConfirm: 'textConfirm',
                confirmTextColor: Colors.white,
                onConfirm: () => Get.back(),
              ),
              child: Text('dialog'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.bottomSheet(
                    const SafeArea(
                      child: Wrap(children: [
                        Column(children: [
                          ListTile(
                            leading: Icon(Icons.car_crash),
                            title: Text('tt'),
                          ),
                          ListTile(
                            leading: Icon(Icons.car_crash),
                            title: Text('tt'),
                          ),
                          ListTile(
                            leading: Icon(Icons.car_crash),
                            title: Text('tt'),
                          ),
                          ListTile(
                            leading: Icon(Icons.car_crash),
                            title: Text('tt'),
                          ),
                        ]),
                      ]),
                    ),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    isDismissible: true,
                    enableDrag: true,
                    backgroundColor: Colors.white);
              },
              child: const Text('bottom sheet'),
            )
          ],
        ),
      ),
    );
  }
}
