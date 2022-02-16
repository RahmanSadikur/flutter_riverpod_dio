import 'package:dio_riverpod/provider/resultStateChangeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/object/Course.dart';
import '../model/object/results.dart';
import '../model/object/semester.dart';

class ResultScreen2 extends ConsumerWidget {
  static const routeName = '/result';
  Widget noSemesterDataFound() {
    return const Text('No Data Found');
  }

  Widget semesterExpanded(
      context,
      data,
      courseProvider,
      courseIdProvider,
      semesterIdProvider,
      semesterNameProvider,
      WidgetRef ref,
      expandCourseProvider,
      expandSemesterProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 4),
      child: Container(
        padding: EdgeInsets.all(1),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).shadowColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ExpansionPanelList(
          dividerColor: Colors.red,
          expandedHeaderPadding: EdgeInsets.zero,
          animationDuration: kThemeAnimationDuration,
          elevation: 0,
          expansionCallback: (int index, bool isEx) {
            // resultProvider.toogleSemesterExpanded();
            expandSemesterProvider.toggoleSemester();
          },
          children: <ExpansionPanel>[
            ExpansionPanel(
              backgroundColor: Theme.of(context).canvasColor,
              isExpanded: expandSemesterProvider,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    "$semesterNameProvider",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                );
              },
              body: data.length < 1
                  ? noSemesterDataFound()
                  : ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                        maxWidth: double.infinity,
                        maxHeight: 160,
                      ),
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: Text(
                                  data[i].title,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onTap: () {
                                  // resultProvider.setchosenValue(
                                  //     resultProvider.semesterList[i].id);
                                  //api call
                                  // resultProvider
                                  //     .getCourseList(resultProvider.chosenValue)
                                  //     .then((value) async => {
                                  //           resultProvider.getInitialCourseId(),
                                  //           await resultProvider.getResult(),
                                  //         });
                                  //resultProvider.setCourseId(0);
                                  // resultProvider.expendedCoursefalse;

                                  // resultProvider.toogleSemesterExpanded();
                                  semesterIdProvider = data[i].id;
                                  ref.refresh(
                                      courseProvider(semesterIdProvider));
                                  var courseList = ref.refresh(
                                      courseProvider(semesterIdProvider));
                                  ref.refresh(courseIdStateNotifierProvider(
                                      CourseModel(
                                          courseList: courseList,
                                          courseId: 0)));
                                  ref.refresh(resultStateNotifierProvider(
                                      ResultModel(
                                          courseId: courseIdProvider,
                                          semesterId: semesterIdProvider)));
                                  expandCourseProvider.setFalse();
                                  expandSemesterProvider.setFalse();
                                },
                              );
                            }),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget courseExpanded(
    BuildContext context,
    courseList,
    WidgetRef ref,
    semesterIdProvider,
    courseIdProvider,
    courseNameProvider,
    expandCourseProvider,
    expandSemesterProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
      child: Container(
        padding: const EdgeInsets.all(1),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).shadowColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ExpansionPanelList(
          dividerColor: Colors.red,
          expandedHeaderPadding: EdgeInsets.zero,
          animationDuration: kThemeAnimationDuration,
          elevation: 0,
          expansionCallback: (int index, bool isEx) {
            // resultProvider.toogleCourseExpanded();
            expandCourseProvider.toggoleCourse();
          },
          children: <ExpansionPanel>[
            ExpansionPanel(
              backgroundColor: Theme.of(context).canvasColor,
              isExpanded: expandCourseProvider,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    "$courseNameProvider",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                );
              },
              body: courseList.length < 1
                  ? const Text('No data found')
                  : ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                        maxWidth: double.infinity,
                        maxHeight: 160,
                      ),
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: courseList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: Text(
                                  courseList[i].description,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onTap: () {
                                  // resultProvider.setCourseId(
                                  //     resultProvider.courseList[i].id);
                                  courseIdProvider = courseList[i].id;
                                  // resultProvider
                                  //     .getResult()
                                  //     .then((value) => {});
                                  //resultProvider.expendedSemesterfalse;
                                  ref.refresh(resultStateNotifierProvider(
                                      ResultModel(
                                          courseId: courseIdProvider,
                                          semesterId: semesterIdProvider)));
                                  expandCourseProvider.setFalse();
                                  expandSemesterProvider.setFalse();

                                  //resultProvider.toogleCourseExpanded();
                                },
                              );
                            }),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget totalGradeSummary(BuildContext context, var item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Total Marks',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "100",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Passing Marks',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${item.passingMark}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Contributes',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${item.totalPercent}%',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 8,
            top: 8,
            right: 8,
            bottom: 0,
          ),
          child: Center(
            child: Text(
              '${item.totalGrade} [${item.totalMark}+${item.totalBonus}]',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ],
    );
  }

  Widget examGradeSummary(BuildContext context, Exam item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Total Marks',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  item.totalMark.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Passing Marks',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  item.passingMark.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Contributes',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${item.totalPercent}%',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 8,
            top: 8,
            right: 8,
            bottom: 0,
          ),
          child: Center(
            child: Text(
              '${item.totalGrade} [${item.mark}+${item.bonus}]',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ],
    );
  }

  Widget examexpensionResult(BuildContext context, Exam item) {
    return Container(
      padding: const EdgeInsets.all(1),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).shadowColor,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 0,
        expansionCallback: (int index, bool isexpd) {
          // resultProvider.toggleExpandExam(index);
          // setState(() {
          //   item.isExpandExam = !item.isExpandExam;
          // });
          item.isExpandExam = !item.isExpandExam;
        },
        children: <ExpansionPanel>[
          ExpansionPanel(
            isExpanded: item.isExpandExam,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.title),
              );
            },
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: examGradeSummary(context, item),
                ),
                item.components.length != 0
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).shadowColor,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                for (int i = 0; i < item.components.length; i++)
                  components(item.components[i], item.components.length, i),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget components(Component item, int length, index) {
    bool lastindex = length - index == 1 ? true : false;

    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    item.title == null ? "" : item.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  child: Text(
                    item.mark.toString() == null ? "" : item.mark.toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          // Divider(),
          for (int i = 0; i < item.elements.length; i++)
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      item.elements[i].title == null
                          ? ""
                          : item.elements[i].title,
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    child: Text(
                      item.elements[i].mark.toString() == null
                          ? ""
                          : item.elements[i].mark.toString(),
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          // Divider(),
          lastindex
              ? Container()
              : Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                  //padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    width: 0.5,
                  ))),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final semesterProvider = ref.watch(semesterFutureProvider);
    final expandSemesterProvider =
        ref.watch(expandSemesterStateNotifierProvider);
    final expandCourseProvider = ref.watch(expandCourseStateNotifierProvider);
    return Scaffold(
      body: semesterProvider.when(
        data: (data) {
          final semesterIdProvider = ref.watch(semesterIdStateNotifierProvider(
              SemesterModel(semesterList: data, semesterId: 0)));
          final semesterNameProvider = ref.watch(
              semesterNameStateNotifierProvider(
                  SemesterModel(semesterList: data, semesterId: 0)));
          final courseProvider =
              ref.watch(courseFutureProvider(semesterIdProvider));
          return courseProvider.when(
              error: (e, s) => const Center(child: Text("")),
              loading: () => const Center(child: Text("...loading!")),
              data: (courseList) {
                final courseIdProvider = ref.watch(
                    courseIdStateNotifierProvider(
                        CourseModel(courseList: courseList, courseId: 0)));
                final courseNameProvider = ref.watch(
                    courseNameStateNotifierProvider(
                        CourseModel(courseList: courseList, courseId: 0)));
                // final singleCourseProvider = ref.watch(
                //     courseStateNotifierProvider(
                //         CourseModel(courseList: courseList, courseId: 0)));
                final resultProvider = ref.watch(resultStateNotifierProvider(
                    ResultModel(
                        courseId: courseIdProvider,
                        semesterId: semesterIdProvider)));

                return SafeArea(
                  child: RefreshIndicator(
                      color: Theme.of(context).canvasColor,
                      backgroundColor: Theme.of(context).accentColor,
                      onRefresh: () async {
                        // _init();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.maybeOf(context)!.size.height -
                              MediaQuery.maybeOf(context)!.padding.top -
                              56,
                          child: Column(
                            children: [
                              semesterExpanded(
                                  context,
                                  data,
                                  courseProvider,
                                  courseIdProvider,
                                  semesterIdProvider,
                                  semesterNameProvider,
                                  ref,
                                  expandCourseProvider,
                                  expandSemesterProvider),
                              courseExpanded(
                                  context,
                                  courseList,
                                  ref,
                                  semesterIdProvider,
                                  courseIdProvider,
                                  courseNameProvider,
                                  expandCourseProvider,
                                  expandSemesterProvider),
                              Container(
                                padding: const EdgeInsets.all(1),
                                margin: const EdgeInsets.only(
                                    top: 4, left: 8, right: 8, bottom: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  border: Border.all(
                                    color: Theme.of(context).shadowColor,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 0,
                                          ),
                                          child: resultProvider.hasValue
                                              ? totalGradeSummary(
                                                  context, resultProvider.value)
                                              : Container(),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        resultProvider.hasValue
                                            ? Column(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          resultProvider.value!
                                                              .exams.length;
                                                      i++)
                                                    examexpensionResult(
                                                      context,
                                                      resultProvider
                                                          .value!.exams[i],
                                                    ),
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                );
              });
        },
        error: (e, s) => Center(
          child: Text("Error: $e  \n trace: $s"),
        ),
        loading: () => const LinearProgressIndicator(),
      ),
    );
  }
}
