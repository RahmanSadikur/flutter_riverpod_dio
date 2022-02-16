class Result {
  final int id;
  final String totalMark;
  final String totalBonus;
  final String passingMark;
  final String totalPercent;
  final String totalGrade;
  final List<String> teacherNames;
  List<Exam> exams;

  Result({
    required this.id,
    required this.totalBonus,
    required this.passingMark,
    required this.totalPercent,
    required this.totalMark,
    required this.totalGrade,
    required this.teacherNames,
    required this.exams,
  });
}

class Exam {
  final String title;
  final String totalMark;
  final String passingMark;
  final String totalPercent;
  final String totalGrade;
  final String mark;
  final String bonus;
  List<Component> components;
  bool isExpandExam;

  Exam({
    required this.title,
    required this.totalMark,
    required this.passingMark,
    required this.totalPercent,
    required this.totalGrade,
    required this.mark,
    required this.bonus,
    required this.components,
    required this.isExpandExam,
  });
}

class Component {
  final String title;
  final String totalMark;
  final String passingMark;
  final String percent;
  final String mark;
  final String bonus;
  List<Elements> elements;

  Component({
    required this.title,
    required this.totalMark,
    required this.passingMark,
    required this.percent,
    required this.mark,
    required this.bonus,
    required this.elements,
  });
}

class Elements {
  final String title;
  final String totalMark;
  final String passingMark;
  final String percent;
  final String mark;
  final String bonus;

  Elements({
    required this.title,
    required this.totalMark,
    required this.passingMark,
    required this.percent,
    required this.mark,
    required this.bonus,
  });
}
