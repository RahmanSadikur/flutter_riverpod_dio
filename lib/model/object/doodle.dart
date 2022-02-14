import 'package:flutter/cupertino.dart';

class Doodle {
  final String title;
  final String content;
  final String icon;
  final String color;
  final bool isImportant;

  const Doodle({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
    required this.isImportant,
  });
}

class AcademicCalender {
  String semesterTitle;
  List<Doodle> doodles;
  AcademicCalender({required this.semesterTitle, required this.doodles});
}
