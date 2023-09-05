import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  String day = dateTime.day.toString();

  String formattedDate = "$year/$month/$day";

  return formattedDate;
}

void customLaunchUrl(url) async {
  if (await canLaunchUrl(url)) {
    launchUrl(url);
  } else {
    Get.snackbar('접속할 수 없습니다.', '다시 시도해주세요.');
  }
}
