import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget loadingPage() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

///num >= 100000 返回num / 10000 万字，否自返回num字
String convertNum(int number) {
  return number >= 100000 ? "${number ~/ 10000}万字" : "$number字";
}

///转换时间戳
/// * 如果timeStamp表示的时间在今天，那么就显示x小时前
/// * 如果timeStamp表示的时间为昨天，那么就显示昨天
/// * 否则显示为yyyy-MM-dd
String convertTime(String timeStamp) {
  DateTime time = DateTime.parse(timeStamp);

  DateTime now = DateTime.now();
  DateTime today = new DateTime(now.year, now.month, now.day); //今天 00：00
  DateTime yesterday = new DateTime(now.year, now.month, now.day - 1); //昨天00：00

  Duration duration = now.difference(time);
  if (time.isAfter(today) && now.isAfter(time)) {
    return "${duration.inHours}小时前";
  }
  if (time.isAfter(yesterday) && today.isAfter(time)) {
    return "昨天";
  }
  return "${time.year}-${time.month.toString().padLeft(2, "0")}-${time.day.toString().padLeft(2, "0")}";
}
