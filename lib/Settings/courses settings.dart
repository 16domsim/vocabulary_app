import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Settings/addCourse.dart';
import 'package:rem_bra/Settings/setCourse.dart';
import 'package:rem_bra/Objects/courseElement.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';

import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

class CoursesSettings extends StatefulWidget {
  _CoursesSettingsS createState() => _CoursesSettingsS();
}

class _CoursesSettingsS extends State<CoursesSettings> {
  AppState _model = null;

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (contextExtern, model, child) {
        if (_model == null) _model = model;

        List<Course> courses = AppState.coursesList;
       
        List<Widget> coursesDisplay = [];

        for (int i = 0; i < courses.length; i++) {
          print(
              'CourseKey: ${DataManager.actualCourseKey} ItemKey: ${courses[i].key}');
          coursesDisplay.add(_createSettingUnit(courses[i], () {
            model.setActualCourseKey(courses[i].key);
          }, i == 0, i == (courses.length - 1),
              courses[i].key == DataManager.actualCourseKey));
        }

        if (courses.length == 0)
          coursesDisplay.add(
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No courses available',
                  style: TextStyle(color: CupertinoColors.inactiveGray),
                ),
              ),
            ),
          );
 String previousPageTitle =
            DemoLocalizations.of(context).settingsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';
          

        return CupertinoPageScaffold(
          backgroundColor: DataManager.actualBackgroundColor,
          key: Key('COURSES SETTING 73342432'),
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              'Courses',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
            previousPageTitle:              '$previousPageTitle',
            trailing: CupertinoButton(
                child: Icon(CupertinoIcons.add),
                padding: EdgeInsets.only(top: 0),
                onPressed: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (context) => AddCourse()));
                }),
          ),
          child: Container(
            color: DataManager.isDarkModeActive
                ? DataManager.actualBackgroundColor
                : CupertinoColors.extraLightBackgroundGray,
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: ListView(children: coursesDisplay),
            ),
          ),
        );
      },
    );
  }

  Widget _createSettingUnit(
      Course course, onPressed(), bool first, bool last, bool selected) {
    Widget up = Padding(padding: EdgeInsets.only(top: 0));
    if (first) {
      up = SettingUnits.separtionLineWidget;
    }
    Widget down = SettingUnits.separtionLineWidgetSmall(context);
    if (last) {
      down = SettingUnits.separtionLineWidget;
    }

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      key: Key('${course.key}'),
      actions: <Widget>[
        IconSlideAction(
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => SetCourse(course, false),
              ),
            );
          },
          iconWidget: Container(
            color: DataManager.actualBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Container(
                color: DataManager.actualAccentColor,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Set',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                      Icon(
                        CupertinoIcons.settings_solid,
                        color: CupertinoColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          onTap: () {
            showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text('Delete'),
                    content: Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: 5, right: 5, bottom: 10),
                      child: Text('Do you really want to delete this course?'),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text(
                          'Yes',
                          style:
                              TextStyle(color: CupertinoColors.destructiveRed),
                        ),
                        onPressed: () {
                          _model.delCourse(course.key);
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: DataManager.actualAccentColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          },
          iconWidget: Container(
            color: DataManager.actualBackgroundColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Container(
                color: CupertinoColors.destructiveRed,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Delete',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                      Icon(
                        CupertinoIcons.delete,
                        color: CupertinoColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          color: DataManager.actualBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              up,
              Padding(
                padding:
                    EdgeInsets.only(right: 10, left: 5, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    selected
                        ? SizedBox(
                            width: 25,
                            height: 25,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                    color: DataManager.actualAccentColor,
                                    child:
                                        Padding(padding: EdgeInsets.all(25))),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 25,
                            height: 25,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Center(),
                              ),
                            ),
                          ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Container(
                      width: 80,
                      child: Text(
                        '${course.name}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: DataManager.actualTextColor),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 30)),
                    Container(
                      child: Expanded(
                        child: Text(
                          '${course.descriptionOne} - ${course.descriptionTwo}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: CupertinoColors.inactiveGray),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              down,
            ],
          ),
        ),
      ),
    );
  }
}
