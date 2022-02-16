import 'package:dio/dio.dart';
import 'package:dio_riverpod/model/object/course.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/service/api.dart';
import '../model/object/results.dart';
import '../model/object/semester.dart';

class ResultModel {
  int courseId;
  int semesterId;
  ResultModel({
    required this.courseId,
    required this.semesterId,
  });
}

class SemesterModel {
  final List<Semester> semesterList;
  int semesterId;
  SemesterModel({
    required this.semesterList,
    required this.semesterId,
  });
}

class CourseModel {
  final List<Course> courseList;
  int courseId;
  CourseModel({
    required this.courseList,
    required this.courseId,
  });
}

final resultStateNotifierProvider = StateNotifierProvider.family<
        ResultStateNotifier, AsyncValue<Result>, ResultModel>(
    (ref, ResultModel resultModel) => ResultStateNotifier(resultModel));
final courseFutureProvider =
    FutureProvider.family<List<Course>, int>((ref, semesterId) async {
  const url = Api.baseUrl + 'Student/GetCourseList2';
  var dio = Dio();
  dio.options.contentType = Headers.formUrlEncodedContentType;
  dio.options.responseType = ResponseType.json;
  Response response;
  List<Course> _courseList = [];
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var _authToken = sharedPreferences.getString('accessToken')!;

  try {
    response = await dio.get(url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
            'AppKey': 'AiubPortalMobileAppBy\$DD2019',
            'Api-Version': 'V2',
            'Authorization': 'Bearer $_authToken',
            'Access-Control-Allow-Origin': '*',
          },
        ),
        queryParameters: {'semesterId': semesterId});

    if (response.statusCode == 200) {
      if (response.data['HasError'] == true) {
      } else {
        _courseList = [];
        var courses = response.data['Data'];

        courses.forEach((course) {
          _courseList.add(
            Course(
              id: course['Id'],
              classId: course['ClassId'],
              description: course['Description'],
              sectionStatus: course['SectionStatus'],
              isValid: course['IsValid'],
              isInvalid: course['IsInValid'],
              isDropped: course['IsDropped'],
              isNonCredit: course['IsNonCredit'],
              isRetake: course['IsRetake'],
            ),
          );
        });
        return _courseList;
      }
      return _courseList;
    } else {
      return _courseList;
    }
  } on DioError catch (e) {
    if (e.response != null) {
      return _courseList;
    } else {
      return _courseList;
    }
  } catch (error) {
    return _courseList;
  }
});
final semesterFutureProvider = FutureProvider<List<Semester>>((ref) async {
  const url = Api.baseUrl + 'Student/GetSemesterList';
  var dio = Dio();
  dio.options.contentType = Headers.formUrlEncodedContentType;
  dio.options.responseType = ResponseType.json;
  Response response;
  List<Semester> _semesterList = [];

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var _authToken = sharedPreferences.getString('accessToken')!;

  try {
    response = await dio.get(
      url,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'AppKey': 'AiubPortalMobileAppBy\$DD2019',
          'Authorization': 'Bearer $_authToken',
          'Access-Control-Allow-Origin': '*',
        },
      ),
    );

    if (response.statusCode == 200) {
      if (response.data['HasError'] == true) {
      } else {
        _semesterList = [];
        var semesters = response.data['Data'];

        semesters.forEach((semester) {
          _semesterList.add(
            Semester(
              id: semester['ID'],
              title: semester['Title'],
              isCurrent: semester['IsCurrent'],
            ),
          );
          if (semester['IsCurrent'] == true) {
            ref.watch(semesterIdStateNotifierProvider(SemesterModel(
                semesterList: semester, semesterId: semester['ID'])));
            ref.watch(semesterNameStateNotifierProvider(SemesterModel(
                semesterList: semester, semesterId: semester['ID'])));
            // _selectedSemesterId = semester['ID'];
            // _selectedSemesterTitle = semester['Title'];
          }
        });
        return _semesterList;
      }
    } else {
      return _semesterList;
    }
    return [];
  } on DioError catch (e) {
    if (e.response != null) {
      return _semesterList;
    } else {
      return _semesterList;
    }
  } catch (error) {
    return _semesterList;
  }
});

final semesterIdStateNotifierProvider =
    StateNotifierProvider.family<SemesterIdStateNotifier, int, SemesterModel>(
        (ref, semesterId) => SemesterIdStateNotifier(semesterId));
final semesterNameStateNotifierProvider = StateNotifierProvider.family<
        SemesterNameStateNotifier, String, SemesterModel>(
    (ref, semesterName) => SemesterNameStateNotifier(semesterName));

final courseIdStateNotifierProvider =
    StateNotifierProvider.family<CourseIdStateNotifier, int, CourseModel>(
        (ref, course) => CourseIdStateNotifier(course));
final courseNameStateNotifierProvider =
    StateNotifierProvider.family<CourseNameStateNotifier, String, CourseModel>(
        (ref, course) => CourseNameStateNotifier(course));
final courseStateNotifierProvider = StateNotifierProvider.family<
    CourseStateNotifier,
    AsyncValue<Course>,
    CourseModel>((ref, course) => CourseStateNotifier(course));

final expandCourseStateNotifierProvider =
    StateNotifierProvider.autoDispose((ref) => ExpandCourseStateNotifier());
final expandSemesterStateNotifierProvider =
    StateNotifierProvider.autoDispose((ref) => ExpandSemesterStateNotifier());

class ResultStateNotifier extends StateNotifier<AsyncValue<Result>> {
  ResultStateNotifier(ResultModel resultModel)
      : super(const AsyncValue<Result>.loading()) {
    chosenValue = resultModel.semesterId;
    _courseId = resultModel.courseId;
    fetched();
  }
  int chosenValue = 0;
  int _courseId = 0;
  Future<void> fetched() async {
    state = const AsyncValue<Result>.loading();
    if (chosenValue == 0 || _courseId == 0) {
      return;
    }
    const url = Api.baseUrl + 'Student/GetCourseResultDetail';
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _authToken = sharedPreferences.getString('accessToken')!;

    try {
      response = await dio.get(url,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            responseType: ResponseType.json,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/x-www-form-urlencoded',
              'AppKey': 'AiubPortalMobileAppBy\$DD2019',
              'Authorization': 'Bearer $_authToken',
              'Access-Control-Allow-Origin': '*',
            },
          ),
          queryParameters: {'semesterId': chosenValue, 'sectionId': _courseId});

      if (response.statusCode == 200) {
        if (response.data['HasError'] == true) {
        } else {
          var resultdata = response.data['Data'];
          List<Elements> elements = [];
          List<Component> components = [];
          List<Exam> exams = [];
          resultdata['Exams'].forEach((em) {
            em['Components'].forEach((cp) {
              cp['Elements'].forEach((el) {
                var b = "-";
                var m = "-";
                var pm = "-";
                var per = "-";
                var tm = "-";
                var t = "-";
                if (el['Result'] != null) {
                  b = el['Result']['Bonus'].toStringAsFixed(2);
                  m = el['Result']['Mark'].toStringAsFixed(2);
                  tm = el['Result']['TotalMark'].toStringAsFixed(2);
                }
                if (el['Element'] != null) {
                  pm = el['Element']['PassMark'].toStringAsFixed(2);
                  per = el['Element']['Percentage'].toStringAsFixed(2);
                  t = el['Element']['Title'];
                }

                elements.add(Elements(
                  bonus: b,
                  mark: m,
                  passingMark: pm,
                  percent: per,
                  title: t,
                  totalMark: tm,
                ));
              });
              var b = "-";
              var m = "-";
              var pm = "-";
              var per = "-";
              var tm = "-";
              var t = "-";
              if (cp['Result'] != null) {
                b = cp['Result']['Bonus'].toStringAsFixed(2);
                m = cp['Result']['Mark'].toStringAsFixed(2);
                tm = cp['Result']['TotalMark'].toStringAsFixed(2);
              }
              if (cp['CourseComponent'] != null) {
                pm = cp['CourseComponent']['PassMark'].toStringAsFixed(2);
                per = cp['CourseComponent']['Percentage'].toStringAsFixed(2);
                t = cp['CourseComponent']['Title'];
              }
              components.add(Component(
                elements: elements,
                title: t,
                bonus: b,
                mark: m,
                passingMark: pm,
                percent: per,
                totalMark: tm,
              ));
              elements = [];
            });
            var b = "-";
            var m = "-";
            var pm = "-";
            var per = "-";
            var tm = "-";
            var t = "-";
            var tg = "-";
            if (em['ExamCourseResult'] != null) {
              if (em['ExamCourseResult']['Bonus'] % 1 == 0) {
                b = em['ExamCourseResult']['Bonus'].toStringAsFixed(0);
              } else {
                b = em['ExamCourseResult']['Bonus'].toStringAsFixed(2);
              }
              if (em['ExamCourseResult']['Mark'] % 1 == 0) {
                m = em['ExamCourseResult']['Mark'].toStringAsFixed(0);
              } else {
                m = em['ExamCourseResult']['Mark'].toStringAsFixed(2);
              }
            }
            if (em['ExamCourse'] != null) {
              if (em['ExamCourse']['PassMark'] % 1 == 0) {
                pm = em['ExamCourse']['PassMark'].toStringAsFixed(0);
              } else {
                pm = em['ExamCourse']['PassMark'].toStringAsFixed(2);
              }
              if (em['ExamCourse']['Percent'] % 1 == 0) {
                per = em['ExamCourse']['Percent'].toStringAsFixed(0);
              } else {
                per = em['ExamCourse']['Percent'].toStringAsFixed(2);
              }
              if (em['ExamCourse']['TotalMark'] % 1 == 0) {
                tm = em['ExamCourse']['TotalMark'].toStringAsFixed(0);
              } else {
                tm = em['ExamCourse']['TotalMark'].toStringAsFixed(2);
              }
            }
            if (em['ExamCourseResult'] != null &&
                em['ExamCourseResult']['ResultantGrade'] != null) {
              tg = em['ExamCourseResult']['ResultantGrade']['Grade'];
            }
            if (em['Title'] != null) {
              t = em['Title'];
            }
            exams.add(Exam(
              components: components,
              bonus: b,
              totalGrade: tg,
              mark: m,
              passingMark: pm,
              totalPercent: per,
              title: t,
              totalMark: tm,
              isExpandExam: false,
            ));
            components = [];
          });
          List<String> _facultyList = [];
          resultdata['Section']['Teachers'].forEach((teacher) {
            String name =
                teacher['TeacherName'] + ' [' + teacher['TeacherID'] + ']';
            _facultyList.add(name);
          });
          var tb = "-";
          var id = -99;
          var tg = "-";
          var tm = "-";

          if (resultdata['SectionResult'] != null) {
            if (resultdata['SectionResult']['Bouns'] % 1 == 0) {
              tb = resultdata['SectionResult']['Bouns'].toStringAsFixed(0);
            } else {
              tb = resultdata['SectionResult']['Bouns'].toStringAsFixed(2);
            }

            id = resultdata['SectionResult']['ID'];
            if (resultdata['SectionResult']['Mark'] % 1 == 0) {
              tm = resultdata['SectionResult']['Mark'].toStringAsFixed(0);
            } else {
              tm = resultdata['SectionResult']['Mark'].toStringAsFixed(2);
            }

            if (resultdata['SectionResult'] != null &&
                resultdata['SectionResult']['ResultantGrade'] != null) {
              tg = resultdata['SectionResult']['ResultantGrade']['Grade'];
            }
          }
          Result _result = Result(
            exams: exams,
            teacherNames: _facultyList,
            id: id,
            passingMark: "50",
            totalBonus: tb,
            totalGrade: tg,
            totalMark: tm,
            totalPercent: "100",
          );
          state = AsyncValue<Result>.data(_result);
          exams = [];
        }
      } else {}
    } on DioError catch (e) {
      if (e.response != null) {
      } else {}
    } catch (error) {}

    // state = result.fold((ModelFailure l) => AsyncValue<KtList<User>>.error(l),
    //     (KtList<User> r) => AsyncValue<KtList<User>>.data(r));
  }
}

class SemesterIdStateNotifier extends StateNotifier<int> {
  SemesterIdStateNotifier(SemesterModel semesterModel) : super(0) {
    if (semesterModel.semesterId == 0 &&
        semesterModel.semesterList.isNotEmpty) {
      state = semesterModel.semesterList.first.id;
    } else {
      state = semesterModel.semesterId;
    }

    semesterList = semesterModel.semesterList;
  }
  List<Semester> semesterList = [];
}

class SemesterNameStateNotifier extends StateNotifier<String> {
  SemesterNameStateNotifier(SemesterModel semesterModel) : super("") {
    if (semesterModel.semesterList.isNotEmpty) {
      if (semesterModel.semesterId == 0) {
        semesterModel.semesterId = semesterModel.semesterList.first.id;
      }
      semesterList = semesterModel.semesterList;
      state = semesterList
          .where((element) => element.id == semesterModel.semesterId)
          .first
          .title;
    } else {
      state = "No Semester Found";
    }
  }
  List<Semester> semesterList = [];
}

class CourseIdStateNotifier extends StateNotifier<int> {
  CourseIdStateNotifier(CourseModel courseModel) : super(0) {
    if (courseModel.courseId == 0 && courseModel.courseList.isNotEmpty) {
      courseModel.courseId = courseModel.courseList.first.id;
    }
    state = courseModel.courseId;
    courseList = courseModel.courseList;
  }
  List<Course> courseList = [];
}

class CourseNameStateNotifier extends StateNotifier<String> {
  CourseNameStateNotifier(CourseModel courseModel) : super("") {
    if (courseModel.courseList.isNotEmpty) {
      if (courseModel.courseId == 0) {
        courseModel.courseId = courseModel.courseList.first.id;
      }
      courseList = courseModel.courseList;
      state = courseList
          .where((element) => element.id == courseModel.courseId)
          .first
          .description;
    } else {
      state = "No course found";
    }
  }
  List<Course> courseList = [];
}

class ExpandCourseStateNotifier extends StateNotifier<bool> {
  ExpandCourseStateNotifier() : super(false) {
    //state=!state;
  }
  toggoleCourse() {
    state = !state;
  }

  setFalse() {
    state = false;
  }
}

class ExpandSemesterStateNotifier extends StateNotifier<bool> {
  ExpandSemesterStateNotifier() : super(false) {
    //state=!state;
  }
  toggoleSemester() {
    state = !state;
  }

  setFalse() {
    state = false;
  }
}

class CourseStateNotifier extends StateNotifier<AsyncValue<Course>> {
  CourseStateNotifier(CourseModel courseModel)
      : super(const AsyncValue<Course>.loading()) {
    if (courseModel.courseId == 0) {
      courseModel.courseId = courseModel.courseList.first.id;
    }

    state = AsyncValue<Course>.data(courseModel.courseList
        .where((element) => element.id == courseModel.courseId)
        .first);
    courseList = courseModel.courseList;
  }
  List<Course> courseList = [];
}
