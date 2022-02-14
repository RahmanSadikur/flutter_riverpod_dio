import 'package:dio/dio.dart';
import 'package:dio_riverpod/model/object/doodle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import '../core/service/api.dart';

class HomeScreen extends ConsumerWidget {
  static const routeName = '/home';
  final academicFutureProvider = FutureProvider<AcademicCalender>((ref) {
    return getData();
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final academicCalendarProvider = ref.watch(academicFutureProvider);
    //
    print("build 1");
    // doodles = academicCalendarProvider;
    final _appBar = AppBar(
      title: const Text('Academic Calender'),
      toolbarHeight: kMinInteractiveDimension,
    );
    double _height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
        appBar: _appBar,
        body: RefreshIndicator(
          color: Theme.of(context).canvasColor,
          //backgroundColor: Theme.of(context).accentColor,
          onRefresh: () async {
            ref.refresh(academicFutureProvider);
          },
          child: academicCalendarProvider.when(
            error: (e, s) => Center(child: Text("$e  : $s")),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (data) {
              return SafeArea(
                child: Scrollbar(
                  child: Container(
                    height: _height,
                    width: double.infinity,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.only(bottom: 4),
                          color: Theme.of(context).canvasColor,
                          child: Container(
                            color: Theme.of(context).canvasColor,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(data.semesterTitle,
                                  style: Theme.of(context).textTheme.headline4),
                            ),
                          ),
                        ),
                        data.doodles.isEmpty
                            ? Container(
                                color: Theme.of(context).canvasColor,
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text('No Data Found',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.zero,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: timelineModel(
                                    context,
                                    data.doodles,
                                    TimelinePosition.Left,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  timelineModel(BuildContext context, List<Doodle> doodles,
          TimelinePosition position) =>
      Timeline.builder(
          //lineColor: Theme.of(context).accentColor,
          itemBuilder: (context, i) {
            final doodle = doodles[i];

            return TimelineModel(
              Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8),
                    bottom: Radius.circular(8),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: doodle.isImportant
                                ? [
                                    Colors.red,
                                    Colors.redAccent,
                                  ]
                                : [
                                    Colors.blue,
                                    Colors.blueAccent,
                                  ],
                            tileMode: TileMode.mirror),
                      ),
                      child: Text(
                        doodle.title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).canvasColor,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        doodle.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              position: i % 2 == 0
                  ? TimelineItemPosition.right
                  : TimelineItemPosition.left,
              isFirst: i == 0,
              isLast: i == doodles.length,
              //iconBackground: Theme.of(context).accentColor,
              icon: const Icon(
                Icons.event_outlined,
                color: Colors.white,
                size: 4,
              ),
            );
          },
          itemCount: doodles.length,
          lineWidth: 1,
          shrinkWrap: true,
          reverse: false,
          physics: position == TimelinePosition.Left
              ? const ClampingScrollPhysics()
              : const BouncingScrollPhysics(),
          position: position);
}

Future<AcademicCalender> getData() async {
  AcademicCalender academicCalender =
      AcademicCalender(semesterTitle: "", doodles: []);
  const url = Api.baseUrl + 'Common/GetAcademicCalendar';
  var dio = Dio();
  dio.options.contentType = Headers.formUrlEncodedContentType;
  dio.options.responseType = ResponseType.json;
  Response response;

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var _authToken = sharedPreferences.getString('accessToken');

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
        return academicCalender;
      } else {
        academicCalender.semesterTitle =
            response.data['Data']['AcademicCalendarSemester'];
        var events = response.data['Data']['Events'];
        List<Doodle> _doodles = [];
        events.forEach((event) {
          _doodles.add(
            Doodle(
              title: event['Title'],
              content: event['Description'],
              isImportant: false,
              icon: event['Icon'],
              color: event['Color'],
            ),
          );
        });
        academicCalender.doodles = _doodles;
        return academicCalender;
      }
    } else {
      return academicCalender;
    }
    //return ;
  } on DioError catch (e) {
    if (e.response != null) {
      return academicCalender;
    } else {
      return academicCalender;
    }
  } catch (error) {
    return academicCalender;
  }
}
