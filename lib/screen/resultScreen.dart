import 'package:dio_riverpod/screen/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';

import '../model/object/results.dart';
import '../provider/resultProvider.dart';

final resultChangeNotifierProvider =
    ChangeNotifierProvider<ResultProvider>((ref) => ResultProvider());

class ResultScreen extends ConsumerStatefulWidget {
  static const routeName = '/result';

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  var resultProvider;

  _init() async {
    resultProvider.setCourseId(0);
    await resultProvider.getSemesterList().then((_) async {
      this.resultProvider.setchosenValue(resultProvider.selectedSemesterId);
      await this
          .resultProvider
          .getcourselistofCurrentSemester()
          .then((_) async {
        resultProvider.getInitialCourseId();
        await resultProvider.getResult();
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _init();
    });

    super.initState();
  }

  Widget noSemesterDataFound(var resultProvider) {
    return Text('No Data Found');
  }

  Widget semesterExpanded(BuildContext context, var resultProvider) {
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
            resultProvider.toogleSemesterExpanded();
          },
          children: <ExpansionPanel>[
            ExpansionPanel(
              backgroundColor: Theme.of(context).canvasColor,
              isExpanded: resultProvider.expandedSemester,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    resultProvider.selectedSemesterTitle == ""
                        ? 'No data found!'
                        : resultProvider.selectedSemesterTitle,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                );
              },
              body: resultProvider.semesterList.length < 1
                  ? noSemesterDataFound(resultProvider)
                  : ConstrainedBox(
                      constraints: new BoxConstraints(
                        minWidth: double.infinity,
                        maxWidth: double.infinity,
                        maxHeight: 160,
                      ),
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: resultProvider.semesterList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: Text(
                                  resultProvider.semesterList[i].title,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onTap: () {
                                  resultProvider.setchosenValue(
                                      resultProvider.semesterList[i].id);
                                  //api call
                                  resultProvider
                                      .getCourseList(resultProvider.chosenValue)
                                      .then((value) async => {
                                            resultProvider.getInitialCourseId(),
                                            await resultProvider.getResult(),
                                          });
                                  //resultProvider.setCourseId(0);
                                  resultProvider.expendedCoursefalse;

                                  resultProvider.toogleSemesterExpanded();
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

  Widget courseExpanded(BuildContext context, var resultProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
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
            resultProvider.toogleCourseExpanded();
          },
          children: <ExpansionPanel>[
            ExpansionPanel(
              backgroundColor: Theme.of(context).canvasColor,
              isExpanded: resultProvider.expandedCourse,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    resultProvider.courseId == 0
                        ? 'Select a Course'
                        : resultProvider.courseName,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                );
              },
              body: resultProvider.courseList.length < 1
                  ? Text('No data found')
                  : ConstrainedBox(
                      constraints: new BoxConstraints(
                        minWidth: double.infinity,
                        maxWidth: double.infinity,
                        maxHeight: 160,
                      ),
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: resultProvider.courseList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: Text(
                                  resultProvider.courseList[i].description,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onTap: () {
                                  resultProvider.setCourseId(
                                      resultProvider.courseList[i].id);
                                  resultProvider
                                      .getResult()
                                      .then((value) => {});
                                  resultProvider.expendedSemesterfalse;

                                  resultProvider.toogleCourseExpanded();
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
                SizedBox(
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
                SizedBox(
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
      padding: EdgeInsets.all(1),
      margin: EdgeInsets.only(bottom: 8),
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
          setState(() {
            item.isExpandExam = !item.isExpandExam;
          });
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
  Widget build(BuildContext context) {
    resultProvider = ref.watch(resultChangeNotifierProvider);
    print("build 2");
    return WillPopScope(
      onWillPop: () async {
        while (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        }
        if (!Navigator.of(context).canPop()) {
          Navigator.pushNamed(context, HomeScreen.routeName);
        }
        return true;
      },
      child: Scaffold(
        body: resultProvider == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: RefreshIndicator(
                    color: Theme.of(context).canvasColor,
                    backgroundColor: Theme.of(context).accentColor,
                    onRefresh: () async {
                      _init();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.maybeOf(context)!.size.height -
                            MediaQuery.maybeOf(context)!.padding.top -
                            56,
                        child: Column(
                          children: [
                            resultProvider.isLoading
                                ? Container(
                                    child: LinearProgressIndicator(),
                                  )
                                : Container(),
                            resultProvider.semesterList == null
                                ? Container()
                                : semesterExpanded(context, resultProvider),
                            resultProvider.courseList == null
                                ? Container()
                                : courseExpanded(context, resultProvider),
                            resultProvider
                                        .courseById(resultProvider.courseId) ==
                                    null
                                ? Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
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
                                    child: Center(
                                      child: Text(
                                          'Select Semester And Course first'),
                                    ),
                                  )
                                : resultProvider.isLoading
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 60,
                                          ),
                                          Center(
                                            child: Text("...Loading!"),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        padding: EdgeInsets.all(1),
                                        margin: const EdgeInsets.only(
                                            top: 4,
                                            left: 8,
                                            right: 8,
                                            bottom: 8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          border: Border.all(
                                            color:
                                                Theme.of(context).shadowColor,
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Card(
                                          margin: EdgeInsets.zero,
                                          elevation: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                // Container(
                                                //   height: 18,
                                                //   margin: EdgeInsets.zero,
                                                //   child: Swiper(
                                                //     itemBuilder:
                                                //         (BuildContext context,
                                                //             int index) {
                                                //       return Text(
                                                //         resultProvider
                                                //             .facultyList[index],
                                                //         textAlign: TextAlign.center,
                                                //         style: Theme.of(context)
                                                //             .textTheme
                                                //             .headline5,
                                                //       );
                                                //     },
                                                //     autoplay: true,
                                                //     autoplayDelay: 100000,
                                                //     duration: 500,
                                                //     itemCount: resultProvider
                                                //         .facultyList.length,
                                                //     viewportFraction: 1,
                                                //     scale: 1,
                                                //   ),
                                                // ),
                                                resultProvider.result == null
                                                    ? Container()
                                                    : Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 8,
                                                          horizontal: 0,
                                                        ),
                                                        child:
                                                            totalGradeSummary(
                                                                context,
                                                                resultProvider
                                                                    .result),
                                                      ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                resultProvider.result == null
                                                    ? Container()
                                                    : Column(
                                                        children: [
                                                          for (int i = 0;
                                                              i <
                                                                  resultProvider
                                                                      .result
                                                                      .exams
                                                                      .length;
                                                              i++)
                                                            examexpensionResult(
                                                              context,
                                                              resultProvider
                                                                  .result
                                                                  .exams[i],
                                                            ),
                                                        ],
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                      ),
                    )),
              ),
      ),
    );
  }
}
