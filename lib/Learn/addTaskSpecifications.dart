import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Objects/taskElement.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

class AddTaskSpecifications extends StatefulWidget {
  List<int> _keys;
  int _colorIndex;
  bool _previousPageWasCustomTraining = false;

  AddTaskSpecifications(
      this._keys, this._colorIndex, this._previousPageWasCustomTraining)
      : assert(_keys != null && _colorIndex != null);

  _AddTaskSpecificationsS createState() => _AddTaskSpecificationsS(
      _keys, _colorIndex, _previousPageWasCustomTraining);
}

class _AddTaskSpecificationsS extends State<AddTaskSpecifications> {
  TextEditingController _languageOne = TextEditingController();

  bool _isTextOneRed = false;

  String _defaultTitle = null;

  List<int> _keys;

  int _colorIndex = -1;

  bool _previousPageWasCustomTraining = false;

  int _dynamicIndex = -1;

  bool _isSetRemiderTime = false;

  DateTime _intervalOfTrainingNotification = DateTime.now();

  _AddTaskSpecificationsS(
      this._keys, this._colorIndex, this._previousPageWasCustomTraining);

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        if (_defaultTitle == null) {
          _defaultTitle = AppState.possibleTaskName;
          _languageOne.text = _defaultTitle;
        }
        if (_dynamicIndex == -1) _dynamicIndex = _colorIndex;

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
          remiderTimeOptions.add(SettingUnits.createSettingUnitWrapper(
              DayWeekPickUp(DataManager.actualAccentColor),
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

        return CupertinoPageScaffold(
          key: Key('Add TRAINING SPECS KEY 23122'),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle:
                _previousPageWasCustomTraining ? 'custom task' : 'choose task',
            transitionBetweenRoutes: true,
            middle: Text(
              'Add task',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
          ),
          child: Container(
            color: DataManager.isDarkModeActive
                ? DataManager.actualBackgroundColor
                : CupertinoColors.extraLightBackgroundGray,
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
                    '${DataManager.getactualTrainingColornameToIndex(_dynamicIndex)}',
                    (newIndex) => {
                          setState(() {
                            _dynamicIndex = newIndex;
                          })
                        },
                    DataManager.allAccentColorNames,
                    _dynamicIndex,
                    true,
                    true,
                    DataManager.getactualTrainingColorToIndex(_dynamicIndex),
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
                      if (_languageOne.text.trim().isEmpty) {
                        _isTextOneRed = true;
                      } else  if (AppState.isTaskTitleSetted(
                          _languageOne.text.trim())) {
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
                                        'You have already saved a task called',
                                    style:
                                        TextStyle(color: CupertinoColors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' ${_languageOne.text.trim()}',
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
                        model.addTask(
                            SmartTask(
                              newName: '${_languageOne.text.trim()}',
                              newActualColorIndex: _dynamicIndex,
                              newKey: DataManager.nextTrainingKey,
                              newIsNotificationActive: _isSetRemiderTime,
                              newNotificationTime:
                                  _intervalOfTrainingNotification,
                              newNotificationDays:
                                  DayWeekPickUpS._daysWhereNotificationIsActive,
                              newLastTimeLearned: DateTime.now().subtract(
                                Duration(days: 1),
                              ),
                              newCourseIndexReference: DataManager.actualCourseKey,
                            ),
                            _keys);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        if (_previousPageWasCustomTraining)
                          Navigator.pop(context);
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

class DayWeekPickUp extends StatefulWidget {
  Color _selectedColor;
  List<bool> _daysWhereNotificationIsActive = null;
  DayWeekPickUp(this._selectedColor,
      {List<bool> dayswhereNotificationIsActive}) {
    if (dayswhereNotificationIsActive != null)
      _daysWhereNotificationIsActive = dayswhereNotificationIsActive;
  }
  DayWeekPickUpS createState() => DayWeekPickUpS(
        _selectedColor,
        _daysWhereNotificationIsActive,
      );
}

class DayWeekPickUpS extends State<DayWeekPickUp> {
  static List<bool> _daysWhereNotificationIsActive = [
    true,
    true,
    true,
    true,
    true,
    false,
    false
  ];

  List<String> _daysNotificationDescription = [
    'M',
    'Tu',
    'W',
    'Th',
    'F',
    'Sa',
    'Su',
  ];

  static final double dayPickerCircleSize = 60;

  Color _selectedColor;

  ScrollController _scrollControllerCircleChoose = ScrollController();

  DayWeekPickUpS(
      this._selectedColor, List<bool> dayswhereNotificationIsActive) {
    if (dayswhereNotificationIsActive != null)
      _daysWhereNotificationIsActive = dayswhereNotificationIsActive;
    else
      _daysWhereNotificationIsActive = [
        true,
        true,
        true,
        true,
        true,
        false,
        false
      ];
  }

  //Continue here, scrollconotroller does not work!

  static List<bool> get daysWhereNotificationIsActive =>
      _daysWhereNotificationIsActive;

  double _padding = -1;

  Widget build(BuildContext context) {
    if (_padding == -1) {
      double width = MediaQuery.of(context).size.width - 20;
      int amount = (width / (dayPickerCircleSize + 10)).toInt();
      double padTot = width % (dayPickerCircleSize + 10);
      _padding = padTot / amount + 10;
    }
    return SizedBox(
      height: dayPickerCircleSize,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollControllerCircleChoose,
        children: <Widget>[
          for (var i = 0; i < 7; i++)
            _DayWeekPickUpDayUnit(_daysNotificationDescription[i],
                _daysWhereNotificationIsActive[i], i, () {
              setState(() {
                _daysWhereNotificationIsActive[i] =
                    !_daysWhereNotificationIsActive[i];
              });
            }, _scrollControllerCircleChoose, _selectedColor, _padding)
        ],
      ),
    );
  }
}

class _DayWeekPickUpDayUnit extends StatefulWidget {
  String _text = '';
  bool _active = false;
  int _index = -1;
  dynamic _onChanged;
  ScrollController _scrollControllerCircleChoose;
  double _padding = 10;

  Color _selectedColor;

  _DayWeekPickUpDayUnit(this._text, this._active, this._index, this._onChanged,
      this._scrollControllerCircleChoose, this._selectedColor, this._padding);
  _DayWeekPickUpDayUnitS createState() => _DayWeekPickUpDayUnitS(
      _text,
      _active,
      _index,
      _onChanged,
      _scrollControllerCircleChoose,
      _selectedColor,
      _padding);
}

class _DayWeekPickUpDayUnitS extends State<_DayWeekPickUpDayUnit> {
  static double _dayPickerCircleSize = DayWeekPickUpS.dayPickerCircleSize;

  String _text = '';
  bool _active = false;
  int _index = -1;
  dynamic _onChanged;
  ScrollController _scrollControllerCircleChoose;
  bool _initiated = false;
  double _padding = 10;

  bool _alignRight = true;

  Color _selectedColor;

  _DayWeekPickUpDayUnitS(this._text, this._active, this._index, this._onChanged,
      this._scrollControllerCircleChoose, this._selectedColor, this._padding) {
    _scrollControllerCircleChoose.addListener(() {
      if (_index == 0) {
        print('${_scrollControllerCircleChoose.position.extentBefore}');
        print('${_scrollControllerCircleChoose.position.extentAfter}');
      }
      if (this.mounted) setState(() {});
    });
  }

  Widget build(BuildContext context) {
    double radius = _dayPickerCircleSize;
    if (_initiated) {
      if (_scrollControllerCircleChoose.hasListeners) {
        if (_scrollControllerCircleChoose.position.extentBefore >
            _index * (_dayPickerCircleSize + _padding)) {
          radius = _dayPickerCircleSize -
              2 *
                  (_scrollControllerCircleChoose.position.extentBefore -
                      (_index * (_dayPickerCircleSize + _padding)));
          //print('before $_index, radius: $radius');
          _alignRight = true;
          if (radius < 0) radius = 0;
        }
        if (_scrollControllerCircleChoose.position.extentAfter >
            (6 - _index) * (_dayPickerCircleSize + _padding)) {
          radius = _dayPickerCircleSize -
              2 *
                  (_scrollControllerCircleChoose.position.extentAfter -
                      ((6 - _index) * (_dayPickerCircleSize + _padding)));
          //print('before $_index, radius: $radius');
          _alignRight = false;
          if (radius < 0) radius = 0;
        }
      }
    } else {
      _initiated = true;
    }

    return Padding(
      padding: EdgeInsets.only(right: _padding),
      child: GestureDetector(
        onTap: () {
          _onChanged();
          setState(() {
            _active = !_active;
          });
        },
        child: SizedBox(
          height: _dayPickerCircleSize,
          width: _dayPickerCircleSize,
          child: Align(
            alignment:
                _alignRight ? Alignment.centerRight : Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                color: _active
                    ? _selectedColor
                    : CupertinoColors.lightBackgroundGray,
                child: SizedBox(
                  height: radius,
                  width: radius,
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        color: CupertinoColors.lightBackgroundGray,
                        child: Center(
                          child: radius >= 25
                              ? Text(
                                  '$_text',
                                  overflow: TextOverflow.fade,
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 0),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
