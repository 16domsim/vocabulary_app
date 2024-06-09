import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Objects/taskElement.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';
import 'addTaskSpecifications.dart';

class SetTaskSpecifications extends StatefulWidget {
  SmartTask _oldElement;
  bool _closeSecondContext;

  SetTaskSpecifications(this._oldElement, this._closeSecondContext)
      : assert(_oldElement != null && _closeSecondContext != null);

  _SetTaskSpecificationsS createState() =>
      _SetTaskSpecificationsS(_oldElement, _closeSecondContext);
}

class _SetTaskSpecificationsS extends State<SetTaskSpecifications> {
  TextEditingController _languageOne = new TextEditingController();

  bool _isTextOneRed = false;

  SmartTask _oldElement;

  bool _closeSecondContext = false;

  int _oldindex = -1;

  int _colorIndex = 0;

  bool _isSetRemiderTime = false;

  bool _firstLoaded = false;

  DateTime _intervalOfTrainingNotification = DateTime.now();

  _SetTaskSpecificationsS(this._oldElement, this._closeSecondContext);

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        if (_oldindex == -1) {
          _oldindex = _oldElement.actualColorIndex;
          _languageOne.text = _oldElement.name;
          _isSetRemiderTime = _oldElement.isNotificationActive;
          _colorIndex = _oldindex;
          if (_isSetRemiderTime)
            _intervalOfTrainingNotification = _oldElement.notificationTime;
        } else
          _firstLoaded = true;
        List<Widget> remiderTimeOptions = [];
        if (_isSetRemiderTime) {
          remiderTimeOptions.add(SettingUnits.createSettingUnitBigSpacer());
          remiderTimeOptions.add(SettingUnits.createSettingUnitTimePopUpChoice(
              'Time',
              '${_intervalOfTrainingNotification.hour}:${_intervalOfTrainingNotification.minute < 10 ? '0${_intervalOfTrainingNotification.minute}' : _intervalOfTrainingNotification.minute}',
              (DateTime newDateTime) {
            setState(() {
              _intervalOfTrainingNotification = newDateTime;
            });
          },
              _intervalOfTrainingNotification,
              true,
              false,
              DataManager.actualAccentColor,
              DataManager.actualTextColor,
              DataManager.actualBackgroundColor,
              context));

          if (!_oldElement.isInReview)
            remiderTimeOptions.add(SettingUnits.createSettingUnitWrapper(
                _firstLoaded
                    ? DayWeekPickUp(DataManager.actualAccentColor)
                    : DayWeekPickUp(
                        DataManager.actualAccentColor,
                        dayswhereNotificationIsActive:
                            _oldElement.notificationDays,
                      ),
                false,
                true,
                DataManager.actualAccentColor,
                DataManager.actualTextColor,
                DataManager.actualBackgroundColor,
                context,
                title: 'Days'));
        } else {
          remiderTimeOptions = [Padding(padding: EdgeInsets.only(top: 0))];
        }

        String previousPageTitle = DemoLocalizations.of(context).learnBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';

        return CupertinoPageScaffold(
          key: Key('SET TRAINING SPECS KEY 34233'),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: '$previousPageTitle',
            middle: Text(
              'Set training task',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
          ),
          child: Container(
            color: DataManager.isDarkModeActive
                ? DataManager.actualBackgroundColor
                : CupertinoColors.extraLightBackgroundGray,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: <Widget>[
                  SettingUnits.createSettingUnitSmallSpacer(),
                  SettingUnits.createSettingTextfieldUnit(
                      'Title',
                      _languageOne,
                      _isTextOneRed,
                      true,
                      true,
                      DataManager.actualAccentColor,
                      DataManager.actualTextColor,
                      DataManager.actualBackgroundColor,
                      context),
                  SettingUnits.createSettingUnitBigSpacer(),
                  SettingUnits.createSettingUnitPopUpChoice(
                      'Color',
                      '${DataManager.getactualTrainingColornameToIndex(_colorIndex)}',
                      (newIndex) => {
                            setState(() {
                              _colorIndex = newIndex;
                            })
                          },
                      DataManager.allAccentColorNames,
                      _colorIndex,
                      true,
                      true,
                      DataManager.getactualTrainingColorToIndex(_colorIndex),
                      DataManager.actualTextColor,
                      DataManager.actualBackgroundColor,
                      context),
                  SettingUnits.createSettingUnitBigSpacer(),
                  SettingUnits.createSettingUnitSwitch(
                      'Alert me',
                      _isSetRemiderTime,
                      (newValue) => {
                            setState(() {
                              _isSetRemiderTime = newValue;
                            })
                          },
                      true,
                      true,
                      DataManager.actualAccentColor,
                      DataManager.actualTextColor,
                      DataManager.actualBackgroundColor,
                      context),
                  for (var i = 0; i < remiderTimeOptions.length; i++)
                    remiderTimeOptions[i],
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: CupertinoButton.filled(
                      child: Text('Save'),
                      onPressed: () {
                        if (_oldElement.name == _languageOne.text.trim() &&
                            _oldindex == _colorIndex &&
                            _isSetRemiderTime ==
                                _oldElement.isNotificationActive &&
                            _intervalOfTrainingNotification
                                    .compareTo(_oldElement.notificationTime) ==
                                0 &&
                            listEquals<bool>(
                                DayWeekPickUpS.daysWhereNotificationIsActive,
                                _oldElement.notificationDays)) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Training task has not changed'),
                                content: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 5, right: 5, bottom: 10),
                                  child: Text(
                                      'Change something before saving your training task.'),
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
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (AppState.isTaskTitleSetted(
                                _languageOne.text.trim()) &&
                            _languageOne.text.trim() != _oldElement.name) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Title exists alredy'),
                                content: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 5, right: 5, bottom: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                          'You have already saved a training task called',
                                      style: TextStyle(
                                          color: CupertinoColors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                ' ${_languageOne.text.trim()}',
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
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          model.setTask(
                            _oldElement,
                            SmartTask(
                              newName: '${_languageOne.text.trim()}',
                              newActualColorIndex: _colorIndex,
                              newKey:
                                  0, //No actual key is neede, as the params of this task are copied in the original
                              newIsNotificationActive: _isSetRemiderTime,
                              newNotificationTime:
                                  _intervalOfTrainingNotification,
                              newNotificationDays:
                                  DayWeekPickUpS.daysWhereNotificationIsActive,
                              newLastTimeLearned: DateTime.now().subtract(
                                Duration(days: 1),
                              ),
                              newCourseIndexReference:
                                  DataManager.actualCourseKey,
                            ),
                          );
                          Navigator.pop(context);
                          if (_closeSecondContext) Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
