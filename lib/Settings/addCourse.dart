import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Objects/courseElement.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';

import '../constants.dart';

class AddCourse extends StatefulWidget {
  _AddCourseS createState() => _AddCourseS();
}

class _AddCourseS extends State<AddCourse> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _descriptionOne = new TextEditingController();
  TextEditingController _descriptionTwo = new TextEditingController();
  bool _isTextOneRed = false;
  bool _isTextTwoRed = false;
  bool _isTextThreeRed = false;

  bool _randomWordOrder = true;
  bool _repeatWhenMistaken = true;
  bool _customTaskAllowed = false;

  int _learnStrikes = CourseLimits.minMinLearningRepetitions;

  bool _reviewEnabled = true;

  int _reviewWeeks = CourseLimits.minReviewWeeksAmount;

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        return CupertinoPageScaffold(
          backgroundColor: DataManager.isDarkModeActive
              ? DataManager.actualBackgroundColor
              : CupertinoColors.extraLightBackgroundGray,
          key: Key('ADD COURSE KEY 723629'),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: 'Courses',
            middle: Text(
              'Add course',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
          ),
          child: Container(
            child: ListView(
              children: <Widget>[
                SettingUnits.createSettingUnitSmallSpacer(),
                SettingUnits.createSettingTextfieldUnit(
                    'Title',
                    _name,
                    _isTextOneRed,
                    true,
                    true,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                SettingUnits.createSettingUnitBigSpacer(),
                SettingUnits.createSettingTextfieldUnit(
                    'Unit 1',
                    _descriptionOne,
                    _isTextTwoRed,
                    true,
                    false,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                SettingUnits.createSettingTextfieldUnit(
                    'Unit 2',
                    _descriptionTwo,
                    _isTextThreeRed,
                    false,
                    true,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                SettingUnits.createSettingUnitBigSpacer(),
                SettingUnits.createSettingUnitSwitch(
                    'Random wordorder', _randomWordOrder, (bool newValue) {
                  setState(() {
                    _randomWordOrder = newValue;
                  });
                }, true, false, DataManager.actualAccentColor, DataManager.actualTextColor,
                    DataManager.actualBackgroundColor, context),
                SettingUnits.createSettingUnitSwitch(
                    'Repeat mistaken', _repeatWhenMistaken, (bool newValue) {
                  setState(() {
                    _repeatWhenMistaken = newValue;
                  });
                }, false, false, DataManager.actualAccentColor, DataManager.actualTextColor,
                    DataManager.actualBackgroundColor, context),
                SettingUnits.createSettingUnitSwitch(
                    'Customtask', _customTaskAllowed, (bool newValue) {
                  setState(() {
                    _customTaskAllowed = newValue;
                  });
                }, false, true, DataManager.actualAccentColor, DataManager.actualTextColor,
                    DataManager.actualBackgroundColor, context),
                SettingUnits.createSettingUnitBigSpacer(),
                SettingUnits.createSettingUnitPopUpChoice(
                    'Learning repetitions', '$_learnStrikes', (int newValue) {
                  setState(() {
                    _learnStrikes =
                        newValue + CourseLimits.minMinLearningRepetitions;
                  });
                },
                    CourseLimits.learningRepetitionOptions
                        .map((e) => '$e')
                        .toList(),
                    0,
                    true,
                    true,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                SettingUnits.createSettingInformationalUnit(
                    'Consecutive days of strikes to learn the word'),
                SettingUnits.createSettingUnitSwitch('Review', _reviewEnabled,
                    (bool newValue) {
                  setState(() {
                    _reviewEnabled = newValue;
                  });
                },
                    true,
                    !_reviewEnabled,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                if (_reviewEnabled)
                  SettingUnits.createSettingUnitPopUpChoice(
                      'Review weeks', '$_reviewWeeks', (int newValue) {
                    setState(() {
                      _reviewWeeks =
                          newValue + CourseLimits.minReviewWeeksAmount;
                    });
                  },
                      CourseLimits.reviewWeekOptions.map((e) => '$e').toList(),
                      0,
                      false,
                      true,
                      DataManager.actualAccentColor,
                      DataManager.actualTextColor,
                      DataManager.actualBackgroundColor,
                      context),
                if (_reviewEnabled)
                  SettingUnits.createSettingInformationalUnit(
                      'Consecutive weeks of review to fully learn the word'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CupertinoButton.filled(
                    child: Text('Save'),
                    onPressed: () {
                      if (_name.text.isEmpty) {
                        setState(
                          () {
                            _isTextOneRed = true;
                          },
                        );
                      } else
                        _isTextOneRed = false;

                      if (_descriptionOne.text.isEmpty) {
                        setState(
                          () {
                            _isTextTwoRed = true;
                          },
                        );
                      } else
                        _isTextTwoRed = false;

                      if (_descriptionTwo.text.isEmpty) {
                        setState(
                          () {
                            _isTextThreeRed = true;
                          },
                        );
                      } else
                        _isTextThreeRed = false;

                      if (!_isTextOneRed &&
                          !_isTextTwoRed &&
                          !_isTextThreeRed) {
                      if (_name.text.trim() == 'Default') {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Invalid input'),
                                content: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 5, right: 5, bottom: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                          'It is not possible to use the name',
                                      style: TextStyle(
                                          color: CupertinoColors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' Default',
                                            style: TextStyle(
                                                color: CupertinoColors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '.',
                                            style: TextStyle(
                                                color: CupertinoColors.black))
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(
                                          color: DataManager.actualAccentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        } else if (AppState.isNameOfCourseIsAlreadyOccupied(
                            _name.text.trim())) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Course exists already'),
                                content: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 5, right: 5, bottom: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                          'You have already saved a course called ',
                                      style: TextStyle(
                                          color: CupertinoColors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: _name.text.trim(),
                                            style: TextStyle(
                                                color: CupertinoColors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '.',
                                            style: TextStyle(
                                                color: CupertinoColors.black))
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(
                                          color: DataManager.actualAccentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        } else if (_descriptionOne.text.trim() ==
                            _descriptionTwo.text.trim()) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Course descriptions are the same'),
                                content: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 5, right: 5, bottom: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: TextStyle(
                                          color: CupertinoColors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: _descriptionOne.text.trim(),
                                            style: TextStyle(
                                                color: CupertinoColors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                ' is used in both descriptions.',
                                            style: TextStyle(
                                                color: CupertinoColors.black))
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(
                                          color: DataManager.actualAccentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          model.addCourse(Course(
                            newName: _name.text.trim(),
                            newDescriptionOne: _descriptionOne.text.trim(),
                            newDescriptionTwo: _descriptionTwo.text.trim(),
                            newKey: DataManager.nextCourseKey,
                            newIsRandomWordOrder: _randomWordOrder,
                            newIsRepeatWhenMistaken: _repeatWhenMistaken,
                            newIsCustomTaskAllowed: _customTaskAllowed,
                            newLearnStrikes: _learnStrikes,
                            newReviewWeeks: _reviewEnabled? _reviewWeeks:0,
                          ));
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
