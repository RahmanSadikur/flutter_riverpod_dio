class Semester {
  final int id;
  final String title;
  final bool isCurrent;

  Semester({
    required this.id,
    required this.title,
    required this.isCurrent,
  });
}

class SemesterResult {
  final String semester;
  final double gpa;

  SemesterResult(
    this.semester,
    this.gpa,
  );
}
