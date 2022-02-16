class Course {
  final int id;
  final String classId;
  final String description;
  final String sectionStatus;
  final bool isValid;
  final bool isInvalid;
  final bool isDropped;
  final bool isNonCredit;
  final bool isRetake;

  Course({
    required this.id,
    required this.classId,
    required this.description,
    required this.sectionStatus,
    required this.isValid,
    required this.isInvalid,
    required this.isDropped,
    required this.isNonCredit,
    required this.isRetake,
  });
}
