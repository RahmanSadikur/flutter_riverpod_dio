// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../core/service/api.dart';
// import '../model/object/Course.dart';
// import '../model/object/results.dart';
// import '../model/object/semester.dart';

// class ResultProvider with ChangeNotifier {
//   bool _isLoading = false;
//   bool _hasError = false;
//   String _errorMessage = '';
//   String _authToken = '';
//   int _selectedSemesterId = 0;
//   Result? _result = null;
//   bool _expendedSemester = false;
//   bool _expendedCourse = false;
//   int _courseId = 0;
//   int _semesterId = 0;
//   String _selectedSemesterTitle = '';
//   List<String> _facultyList = [];
//   bool get expendedSemesterfalse {
//     return _expendedSemester = false;
//   }

//   bool get expendedCoursefalse {
//     return _expendedCourse = false;
//   }

//   Result? get result {
//     return _result;
//   }

//   List<String> get facultyList {
//     return _facultyList;
//   }

//   String get selectedSemesterTitle {
//     return _selectedSemesterTitle;
//   }

//   int get selectedSemesterId {
//     return _selectedSemesterId;
//   }

//   bool get isLoading {
//     return _isLoading;
//   }

//   bool get hasError {
//     return _hasError;
//   }

//   String get errorMessage {
//     return _errorMessage;
//   }

//   List<Semester> _semesterList = [];
//   List<Semester> get semesterList {
//     return [..._semesterList];
//   }

//   List<Course> get courseList {
//     return [..._courseList];
//   }

//   List<Course> _courseList = [];

//   Future<List<Course>> getcourselistofCurrentSemester() async {
//     return getCourseData(selectedSemesterId);
//   }

//   Course? courseById(int id) {
//     return _courseList.firstWhere((element) => element.id == id);
//   }

//   void setCourseId(int value) {
//     _courseId = value;
//     notifyListeners();
//   }

//   getInitialCourseId() {
//     return _courseList != null
//         ? _courseId = _courseList.first.id
//         : _courseId = 0;
//   }

//   String get courseName {
//     return _courseList.where((element) => element.id == _courseId) == null
//         ? "No course Found"
//         : _courseList
//             .where((element) => element.id == _courseId)
//             .first
//             .description;
//   }

//   int get courseId {
//     return _courseId;
//   }

//   toogleSemesterExpanded() {
//     _expendedSemester = !_expendedSemester;
//     notifyListeners();
//   }

//   bool get expandedSemester {
//     return _expendedSemester;
//   }

//   toogleCourseExpanded() {
//     _expendedCourse = !_expendedCourse;
//     notifyListeners();
//   }

//   bool get expandedCourse {
//     return _expendedCourse;
//   }

//   int _chosenValue = 0;
//   setchosenValue(int value) {
//     _chosenValue = value;
//     _selectedSemesterTitle =
//         _semesterList.where((element) => element.id == value).first.title;
//     notifyListeners();
//   }

//   int get chosenValue {
//     return _chosenValue <= 0 ? 0 : _chosenValue;
//   }

//   setSelectedSemesterId(int semesterId) {
//     _selectedSemesterId = semesterId;
//     notifyListeners();
//   }

//   Future<Result?> getData({int chosenValue = 0, int courseId = 0}) async {
//     if (chosenValue == 0 || courseId == 0) {
//       return null;
//     }
//     //Result? _result = null;
//     const url = Api.baseUrl + 'Student/GetCourseResultDetail';
//     var dio = Dio();
//     dio.options.contentType = Headers.formUrlEncodedContentType;
//     dio.options.responseType = ResponseType.json;
//     Response response;

//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var _authToken = sharedPreferences.getString('accessToken');

//     try {
//       response = await dio.get(url,
//           options: Options(
//             contentType: Headers.formUrlEncodedContentType,
//             responseType: ResponseType.json,
//             headers: {
//               'Accept': 'application/json',
//               'Content-Type': 'application/x-www-form-urlencoded',
//               'AppKey': 'AiubPortalMobileAppBy\$DD2019',
//               'Authorization': 'Bearer $_authToken',
//               'Access-Control-Allow-Origin': '*',
//             },
//           ),
//           queryParameters: {'semesterId': chosenValue, 'sectionId': courseId});

//       if (response.statusCode == 200) {
//         if (response.data['HasError'] == true) {
//           return null;
//         } else {
//           var resultdata = response.data['Data'];
//           List<Elements> elements = [];
//           List<Component> components = [];
//           List<Exam> exams = [];
//           resultdata['Exams'].forEach((em) {
//             em['Components'].forEach((cp) {
//               cp['Elements'].forEach((el) {
//                 var b = "-";
//                 var m = "-";
//                 var pm = "-";
//                 var per = "-";
//                 var tm = "-";
//                 var t = "-";
//                 if (el['Result'] != null) {
//                   b = el['Result']['Bonus'].toStringAsFixed(2);
//                   m = el['Result']['Mark'].toStringAsFixed(2);
//                   tm = el['Result']['TotalMark'].toStringAsFixed(2);
//                 }
//                 if (el['Element'] != null) {
//                   pm = el['Element']['PassMark'].toStringAsFixed(2);
//                   per = el['Element']['Percentage'].toStringAsFixed(2);
//                   t = el['Element']['Title'];
//                 }

//                 elements.add(Elements(
//                   bonus: b,
//                   mark: m,
//                   passingMark: pm,
//                   percent: per,
//                   title: t,
//                   totalMark: tm,
//                 ));
//               });
//               var b = "-";
//               var m = "-";
//               var pm = "-";
//               var per = "-";
//               var tm = "-";
//               var t = "-";
//               if (cp['Result'] != null) {
//                 b = cp['Result']['Bonus'].toStringAsFixed(2);
//                 m = cp['Result']['Mark'].toStringAsFixed(2);
//                 tm = cp['Result']['TotalMark'].toStringAsFixed(2);
//               }
//               if (cp['CourseComponent'] != null) {
//                 pm = cp['CourseComponent']['PassMark'].toStringAsFixed(2);
//                 per = cp['CourseComponent']['Percentage'].toStringAsFixed(2);
//                 t = cp['CourseComponent']['Title'];
//               }
//               components.add(Component(
//                 elements: elements,
//                 title: t,
//                 bonus: b,
//                 mark: m,
//                 passingMark: pm,
//                 percent: per,
//                 totalMark: tm,
//               ));
//               elements = [];
//             });
//             var b = "-";
//             var m = "-";
//             var pm = "-";
//             var per = "-";
//             var tm = "-";
//             var t = "-";
//             var tg = "-";
//             if (em['ExamCourseResult'] != null) {
//               if (em['ExamCourseResult']['Bonus'] % 1 == 0) {
//                 b = em['ExamCourseResult']['Bonus'].toStringAsFixed(0);
//               } else {
//                 b = em['ExamCourseResult']['Bonus'].toStringAsFixed(2);
//               }
//               if (em['ExamCourseResult']['Mark'] % 1 == 0) {
//                 m = em['ExamCourseResult']['Mark'].toStringAsFixed(0);
//               } else {
//                 m = em['ExamCourseResult']['Mark'].toStringAsFixed(2);
//               }
//             }
//             if (em['ExamCourse'] != null) {
//               if (em['ExamCourse']['PassMark'] % 1 == 0) {
//                 pm = em['ExamCourse']['PassMark'].toStringAsFixed(0);
//               } else {
//                 pm = em['ExamCourse']['PassMark'].toStringAsFixed(2);
//               }
//               if (em['ExamCourse']['Percent'] % 1 == 0) {
//                 per = em['ExamCourse']['Percent'].toStringAsFixed(0);
//               } else {
//                 per = em['ExamCourse']['Percent'].toStringAsFixed(2);
//               }
//               if (em['ExamCourse']['TotalMark'] % 1 == 0) {
//                 tm = em['ExamCourse']['TotalMark'].toStringAsFixed(0);
//               } else {
//                 tm = em['ExamCourse']['TotalMark'].toStringAsFixed(2);
//               }
//             }
//             if (em['ExamCourseResult'] != null &&
//                 em['ExamCourseResult']['ResultantGrade'] != null) {
//               tg = em['ExamCourseResult']['ResultantGrade']['Grade'];
//             }
//             if (em['Title'] != null) {
//               t = em['Title'];
//             }
//             exams.add(Exam(
//               components: components,
//               bonus: b,
//               totalGrade: tg,
//               mark: m,
//               passingMark: pm,
//               totalPercent: per,
//               title: t,
//               totalMark: tm,
//               isExpandExam: false,
//             ));
//             components = [];
//           });
//           _facultyList = [];
//           resultdata['Section']['Teachers'].forEach((teacher) {
//             String name =
//                 teacher['TeacherName'] + ' [' + teacher['TeacherID'] + ']';
//             _facultyList.add(name);
//           });
//           var tb = "-";
//           var id = -99;
//           var tg = "-";
//           var tm = "-";

//           if (resultdata['SectionResult'] != null) {
//             if (resultdata['SectionResult']['Bouns'] % 1 == 0) {
//               tb = resultdata['SectionResult']['Bouns'].toStringAsFixed(0);
//             } else {
//               tb = resultdata['SectionResult']['Bouns'].toStringAsFixed(2);
//             }

//             id = resultdata['SectionResult']['ID'];
//             if (resultdata['SectionResult']['Mark'] % 1 == 0) {
//               tm = resultdata['SectionResult']['Mark'].toStringAsFixed(0);
//             } else {
//               tm = resultdata['SectionResult']['Mark'].toStringAsFixed(2);
//             }

//             if (resultdata['SectionResult'] != null &&
//                 resultdata['SectionResult']['ResultantGrade'] != null) {
//               tg = resultdata['SectionResult']['ResultantGrade']['Grade'];
//             }
//           }
//           _result = Result(
//             exams: exams,
//             teacherNames: _facultyList,
//             id: id,
//             passingMark: "50",
//             totalBonus: tb,
//             totalGrade: tg,
//             totalMark: tm,
//             totalPercent: "100",
//           );
//           exams = [];
//           notifyListeners();
//           return _result;
//         }
//       } else {
//         return null;
//       }
//     } on DioError catch (e) {
//       if (e.response != null) {
//         return null;
//       } else {
//         return null;
//       }
//     } catch (error) {
//       return null;
//     }
//   }

//   Future<List<Course>> getCourseData({int semesterId = 0}) async {
//     if (semesterId == 0) {
//       semesterId = _selectedSemesterId;
//     }
//     const url = Api.baseUrl + 'Student/GetCourseList2';
//     var dio = Dio();
//     dio.options.contentType = Headers.formUrlEncodedContentType;
//     dio.options.responseType = ResponseType.json;
//     Response response;
//     // List<Course> _courseList = [];
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var _authToken = sharedPreferences.getString('accessToken');

//     try {
//       response = await dio.get(url,
//           options: Options(
//             contentType: Headers.formUrlEncodedContentType,
//             responseType: ResponseType.json,
//             headers: {
//               'Accept': 'application/json',
//               'Content-Type': 'application/x-www-form-urlencoded',
//               'AppKey': 'AiubPortalMobileAppBy\$DD2019',
//               'Api-Version': 'V2',
//               'Authorization': 'Bearer $_authToken',
//               'Access-Control-Allow-Origin': '*',
//             },
//           ),
//           queryParameters: {'semesterId': semesterId});

//       if (response.statusCode == 200) {
//         if (response.data['HasError'] == true) {
//         } else {
//           _courseList = [];
//           var courses = response.data['Data'];

//           courses.forEach((course) {
//             _courseList.add(
//               Course(
//                 id: course['Id'],
//                 classId: course['ClassId'],
//                 description: course['Description'],
//                 sectionStatus: course['SectionStatus'],
//                 isValid: course['IsValid'],
//                 isInvalid: course['IsInValid'],
//                 isDropped: course['IsDropped'],
//                 isNonCredit: course['IsNonCredit'],
//                 isRetake: course['IsRetake'],
//               ),
//             );
//           });
//           notifyListeners();
//           return _courseList;
//         }
//       } else {
//         return _courseList;
//       }
//       return _courseList;
//     } on DioError catch (e) {
//       if (e.response != null) {
//         return _courseList;
//       } else {
//         return _courseList;
//       }
//     } catch (error) {
//       return _courseList;
//     }
//   }

//   Future<List<Semester>> getSemesterData() async {
//     const url = Api.baseUrl + 'Student/GetSemesterList';
//     var dio = Dio();
//     dio.options.contentType = Headers.formUrlEncodedContentType;
//     dio.options.responseType = ResponseType.json;
//     Response response;
//     _semesterList = [];
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var _authToken = sharedPreferences.getString('accessToken');

//     try {
//       response = await dio.get(
//         url,
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//           responseType: ResponseType.json,
//           headers: {
//             'Accept': 'application/json',
//             'Content-Type': 'application/x-www-form-urlencoded',
//             'AppKey': 'AiubPortalMobileAppBy\$DD2019',
//             'Authorization': 'Bearer $_authToken',
//             'Access-Control-Allow-Origin': '*',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         if (response.data['HasError'] == true) {
//           return _semesterList;
//         } else {
//           _semesterList = [];
//           var semesters = response.data['Data'];

//           semesters.forEach((semester) {
//             _semesterList.add(
//               Semester(
//                 id: semester['ID'],
//                 title: semester['Title'],
//                 isCurrent: semester['IsCurrent'],
//               ),
//             );
//             if (semester['IsCurrent'] == true) {
//               // _selectedSemesterId = semester['ID'];
//               // _selectedSemesterTitle = semester['Title'];
//             }
//           });
//           notifyListeners();
//           return _semesterList;
//         }
//       } else {
//         return _semesterList;
//       }
//     } on DioError catch (e) {
//       if (e.response != null) {
//         return _semesterList;
//       } else {
//         return _semesterList;
//       }
//     } catch (error) {
//       return _semesterList;
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/service/api.dart';
import '../model/object/Course.dart';
import '../model/object/results.dart';
import '../model/object/semester.dart';

class ResultProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _authToken = '';
  int _selectedSemesterId = 0;
  Result? _result;
  bool _expendedSemester = false;
  bool _expendedCourse = false;
  int _courseId = 0;
  String _selectedSemesterTitle = '';
  List<String> _facultyList = [];
  bool get expendedSemesterfalse {
    return _expendedSemester = false;
  }

  bool get expendedCoursefalse {
    return _expendedCourse = false;
  }

  Result? get result {
    return _result;
  }

  List<String> get facultyList {
    return _facultyList;
  }

  String get selectedSemesterTitle {
    return _selectedSemesterTitle;
  }

  int get selectedSemesterId {
    return _selectedSemesterId;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get hasError {
    return _hasError;
  }

  String get errorMessage {
    return _errorMessage;
  }

  List<Semester> _semesterList = [];
  List<Semester> get semesterList {
    return [..._semesterList];
  }

  List<Course> get courseList {
    return [..._courseList];
  }

  List<Course> _courseList = [];

  Future<void> getcourselistofCurrentSemester() async {
    _isLoading = true;
    notifyListeners();
    return _getCourseList(selectedSemesterId);
  }

  Course? courseById(int id) {
    return _courseList.firstWhere((element) => element.id == id, orElse: null);
  }

  void setCourseId(int value) {
    _courseId = value;
    notifyListeners();
  }

  getInitialCourseId() {
    return _courseList != null
        ? _courseId = _courseList.first.id
        : _courseId = 0;
  }

  String get courseName {
    return _courseList.where((element) => element.id == _courseId) == null
        ? "No course Found"
        : this
            ._courseList
            .where((element) => element.id == _courseId)
            .first
            .description;
  }

  int get courseId {
    return _courseId;
  }

  toogleSemesterExpanded() {
    _expendedSemester = !_expendedSemester;
    notifyListeners();
  }

  bool get expandedSemester {
    return _expendedSemester;
  }

  toogleCourseExpanded() {
    _expendedCourse = !_expendedCourse;
    notifyListeners();
  }

  bool get expandedCourse {
    return _expendedCourse;
  }

  int _chosenValue = 0;
  setchosenValue(int value) {
    _chosenValue = value;
    _selectedSemesterTitle =
        _semesterList.where((element) => element.id == value).first.title;
    notifyListeners();
  }

  int get chosenValue {
    return _chosenValue <= 0 ? 0 : _chosenValue;
  }

  setSelectedSemesterId(int semesterId) {
    _selectedSemesterId = semesterId;
    notifyListeners();
  }

  Future<void> _getSemesterList() async {
    const url = Api.baseUrl + 'Student/GetSemesterList';
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _authToken = sharedPreferences.getString('accessToken')!;

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
          _hasError = true;
          _errorMessage = 'Error from Server';
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
              _selectedSemesterId = semester['ID'];
              _selectedSemesterTitle = semester['Title'];
            }
          });
          _hasError = false;
          _errorMessage = '';
        }
      } else {
        _hasError = true;
        _errorMessage = 'Oops! Something went wrong!';
      }
      _isLoading = false;
    } on DioError catch (e) {
      if (e.response != null) {
        _errorMessage = '';
        _isLoading = false;
      } else {
        _hasError = true;
        _errorMessage = 'Server Error!';
        _isLoading = false;
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = 'Could not connect to server. Please try again later.';
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> getSemesterList() async {
    // _semesterList = [];
    _isLoading = true;
    notifyListeners();
    return _getSemesterList();
  }

  Future<void> _getCourseList(int semesterId) async {
    const url = Api.baseUrl + 'Student/GetCourseList2';
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _authToken = sharedPreferences.getString('accessToken')!;

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
          _hasError = true;
          _errorMessage = 'Error from Server';
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
          _hasError = false;
          _errorMessage = '';
        }
      } else {
        _hasError = true;
        _errorMessage = 'Oops! Something went wrong!';
      }
      _isLoading = false;
    } on DioError catch (e) {
      if (e.response != null) {
        _errorMessage = '';
        _isLoading = false;
      } else {
        _hasError = true;
        _errorMessage = 'Server Error!';
        _isLoading = false;
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = 'Could not connect to server. Please try again later.';
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> getCourseList(int semesterId) async {
    // _courseList = [];
    _isLoading = true;
    notifyListeners();
    return _getCourseList(semesterId);
  }

  Future<void> _getResult() async {
    if (chosenValue == 0 || _courseId == 0) {
      return;
    }
    const url = Api.baseUrl + 'Student/GetCourseResultDetail';
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _authToken = sharedPreferences.getString('accessToken')!;

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
          _hasError = true;
          _errorMessage = 'Error from Server';
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
          _facultyList = [];
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
          _result = Result(
            exams: exams,
            teacherNames: _facultyList,
            id: id,
            passingMark: "50",
            totalBonus: tb,
            totalGrade: tg,
            totalMark: tm,
            totalPercent: "100",
          );
          exams = [];
          _hasError = false;
          _errorMessage = '';
        }
      } else {
        _hasError = true;
        _errorMessage = 'Oops! Something went wrong!';
      }
      _isLoading = false;
    } on DioError catch (e) {
      if (e.response != null) {
        _errorMessage = '';
        _isLoading = false;
      } else {
        _hasError = true;
        _errorMessage = 'Server Error!';
        _isLoading = false;
      }
    } catch (error) {
      _hasError = true;
      _errorMessage = 'Could not connect to server. Please try again later.';
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> getResult() async {
    _result = null;
    _facultyList = [];
    _isLoading = true;
    notifyListeners();
    return _getResult();
  }
}
