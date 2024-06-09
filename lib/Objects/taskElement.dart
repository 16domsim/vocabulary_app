import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/appsate.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';

final String tableTodo = DatabaseNames.tasksName;
//For general Security unique of elementkey and other Key for DB to prevent incompatibility
final String primaryKey = 'pkey';
final String tid = 'tid';
final String tname = 'tname';
final String tactualColorIndex = 'tidcolor';
final String tisNotificationActive = 'tisnotifact';
final String tnotifcationTime = 'tnotiftime';
final String tnotificationDays = 'tnotifdays';
final String tlastTimeLearned = 'tlsttimelearn';
final String tcourseIndexReference = 'tcouid';
final String tisInReview = 'tisInReview';

/**
 * TODO
 * 
 * Change the review, just save a bool!!!!!
 * 
 * 
 */

class SmartTask {
  int _key;
  String _name;
  int _actualColorIndex = 0;
  bool _isNotificationActive = false;
  DateTime _notificationTime = null;
  int _notificationDays;
  DateTime _lastTimeLearned = null;
  int _courseIndexReference = -1;
  bool _isInReview = false;

  SmartTask(
      {@required String newName,
      @required int newActualColorIndex,
      @required int newKey,
      @required bool newIsNotificationActive,
      @required DateTime newNotificationTime,
      @required List<bool> newNotificationDays,
      @required DateTime newLastTimeLearned,
      @required int newCourseIndexReference,
      bool newisInReview = false}) {
    //Continue here, does not store and safe data properly!
    setName(newName);
    setActualColorIndex(newActualColorIndex);
    _setKey(newKey);
    setIsNotificationActive(newIsNotificationActive);
    setNotificationTime(newNotificationTime);
    setNotificationDays(newNotificationDays);
    setLastTimeLearned(newLastTimeLearned);
    _setCourseIndexReference(newCourseIndexReference);
    setIsInReview(isInReview);
  }

  String get name => _name;

  setName(String newName) {
    if (newName != null) _name = newName;
  }

  int get actualColorIndex => _actualColorIndex;

  Color get actualColor =>
      DataManager.getactualTrainingColorToIndex(_actualColorIndex);

  setActualColorIndex(int newIndex) {
    if (DataManager.isColorIndexValid(newIndex)) _actualColorIndex = newIndex;
  }

  int get key => _key;

  _setKey(int newKey) {
    if (newKey != null) {
      if (newKey >= 0) _key = newKey;
    }
  }

  bool get isNotificationActive => _isNotificationActive;

  setIsNotificationActive(bool newOne) {
    if (newOne != null) _isNotificationActive = newOne;
  }

  DateTime get notificationTime => _notificationTime;

  setNotificationTime(DateTime time) {
    if (time != null) {
      _notificationTime = time;
    }
  }

  List<bool> get notificationDays {
    List<bool> ret = [];
    String h = '$_notificationDays';
    for (int i = 0; i < 7; i++) ret.add(h[i] == '1');

    return ret;
  }

  setNotificationDays(List<bool> newDays) {
    if (newDays != null) {
      if (newDays.length == 7) {
        String h = '';
        for (int i = 0; i < 7; i++) h += newDays[i] ? '1' : '0';
        _notificationDays = int.parse(h);
      }
    }
  }

  DateTime get lastTimeLearned => _lastTimeLearned;

  setLastTimeLearned(DateTime time) {
    if (time != null) {
      _lastTimeLearned = time;
    }
  }

  int get courseIndexReference => _courseIndexReference;

  _setCourseIndexReference(int newCourseIndexReference) {
    if (newCourseIndexReference != null) {
      if (newCourseIndexReference >= 0)
        _courseIndexReference = newCourseIndexReference;
    }
  }

 

  bool get isInReview => _isInReview;

  setIsInReview(bool isInReview) {
    if (isInReview!=null) {
      _isInReview = isInReview;
    }
  }

 

  // //Both following funtions to delete
  // setIDsOfWords(List<int> idsOfWord) {}

  // List<int> get idsOfWords {
  //   List<int> ret = [];

  //   return ret;
  // }

  bool isReadyForLearn(DateTime dateTime) {
    if (DateTime(_lastTimeLearned.year, _lastTimeLearned.month,
                _lastTimeLearned.day)
            .compareTo(DateTime(dateTime.year, dateTime.month, dateTime.day)) <
        0) return true;
    return false;
  }

  bool isReadyForInRespectToNotificationTime(DateTime dateTime) {
    if (!_isInReview) {
      List<int> h = [];
      List<bool> h2 = this.notificationDays;
      for (var i = 0; i < 7; i++) {
        if (h2[i]) h.add(i + 1);
      }
      if (DateTime(
                      _notificationTime.year,
                      _notificationTime.month,
                      _notificationTime.day,
                      _notificationTime.hour,
                      _notificationTime.minute)
                  .compareTo(DateTime(
                      _notificationTime.year,
                      _notificationTime.month,
                      _notificationTime.day,
                      dateTime.hour,
                      dateTime.minute)) <=
              0 ||
          !h.contains(dateTime.weekday) ||
          !_isNotificationActive) return true;
      return false;
    } else {
      DateTime h = DateTime(_lastTimeLearned.year, _lastTimeLearned.month,
          _lastTimeLearned.day, _lastTimeLearned.hour, _lastTimeLearned.minute);
      h = h.add(Duration(days: 7));
      if (h.compareTo(DateTime(dateTime.year, dateTime.month, dateTime.day,
              dateTime.hour, dateTime.minute)) <=
          0) return true;
      return false;
    }
  }

  bool isReadyIfItIsInReviewMode(DateTime dateTime) {
    if (!_isInReview ) {
      DateTime h = DateTime(
          _lastTimeLearned.year,
          _lastTimeLearned.month,
          _lastTimeLearned.day,
          _isNotificationActive ? _lastTimeLearned.hour : 0,
          _isNotificationActive ? _lastTimeLearned.minute : 0);

      h = h.add(Duration(days: 7));
      if (h.compareTo(DateTime(
              dateTime.year,
              dateTime.month,
              dateTime.day,
              _isNotificationActive ? dateTime.hour : 0,
              _isNotificationActive ? dateTime.minute : 0)) <=
          0) return true;
    }
    return false;
  }

  DateTime get futureReviewDate {
    DateTime h = DateTime(_lastTimeLearned.year, _lastTimeLearned.month,
        _lastTimeLearned.day, _lastTimeLearned.hour, _lastTimeLearned.minute);
    h = h.add(Duration(days: 7));
    return h;
  }

  //The Symbol still does not fit! isReadyIfItIsInReviewMode may not work properly! It was so simple!!
  int getIndexInOfTaskState(DateTime time) {
    print(isReadyIfItIsInReviewMode(time));
    if (_isInReview && !isReadyIfItIsInReviewMode(time)&&AppState.isReviewEnabled) return 3;
    if (!isReadyForLearn(time)) return 2;
    if (!isReadyForInRespectToNotificationTime(time)) return 1;
    return 0;
  }

  copyFrom(SmartTask smartTask) {
    if (smartTask != null) {
      setName(smartTask.name);
      setActualColorIndex(smartTask.actualColorIndex);
      setIsNotificationActive(smartTask.isNotificationActive);
      if (isNotificationActive) {
        setNotificationTime(smartTask.notificationTime);
        setNotificationDays(smartTask.notificationDays);
      }
    }
  }

  String toString() =>
      '{name: $_name; actualColorIndex: $_actualColorIndex; isNotificationActive: $_isNotificationActive; notificationTime: $_notificationTime; ' +
      ' notificationDays: $_notificationDays; lastTimeTrained: $_lastTimeLearned; courseIndexReference: $_courseIndexReference; isInReview: $_isInReview; key: $_key wordindexes: ???';

  static SmartTask deserialize(String serializedString) {
    List<String> smartTrainingElement =
        _getListToSerializedString(serializedString);

    List<bool> notificationDays = [];
    String help = smartTrainingElement[5];
    for (var i = 0; i < help.length; i++) {
      if (help[i] == 't') notificationDays.add(true);
      if (help[i] == 'f') notificationDays.add(false);
    }

    return SmartTask(
      newName: smartTrainingElement[0],
      newActualColorIndex: int.parse(smartTrainingElement[1]),
      newKey: int.parse(smartTrainingElement[2]),
      newIsNotificationActive: smartTrainingElement[3] == 'true',
      newNotificationTime: DateTime.parse(smartTrainingElement[4]),
      newNotificationDays: notificationDays,
      newLastTimeLearned: DateTime.parse(smartTrainingElement[6]),
      newCourseIndexReference: int.parse(smartTrainingElement[7]),
      newisInReview: bool.fromEnvironment( smartTrainingElement[8]),
    );
  }

  static String serialize(SmartTask smartTrainingElement) {
    List<String> ret = [];

    //This here should be reverse!
    ret.insert(0, '${smartTrainingElement.isInReview}');
    ret.insert(0, '${smartTrainingElement.courseIndexReference}');
    ret.insert(0, '${smartTrainingElement.lastTimeLearned.toString()}');
    ret.insert(0, '${smartTrainingElement.notificationDays}');
    ret.insert(0, '${smartTrainingElement.notificationTime.toString()}');
    ret.insert(0, '${smartTrainingElement.isNotificationActive}');
    ret.insert(0, '${smartTrainingElement.key}');
    ret.insert(0, '${smartTrainingElement.actualColorIndex}');
    ret.insert(0, smartTrainingElement.name);

    return _getStringToSerializedList(ret);
  }

//Continue here, the saving/loading does not properly work!
  static List<String> _getListToSerializedString(String oldString) {
    List<String> ret = [];
    do {
      ret.add(oldString.substring(0, oldString.indexOf('%')));
      oldString = oldString.substring(oldString.indexOf('%') + 1);
    } while (oldString.contains('%'));
    ret.add(oldString);
    //print(ret);
    return ret;
  }

  static String _getStringToSerializedList(List<String> oldList) {
    String ret = '';
    for (var i = 0; i < oldList.length; i++) ret += '${oldList[i]}%';
    ret = ret.substring(0, ret.length - 1);
    //print(ret);
    return ret;
  }

  //Important: bool is allowed, but need to save either 0 or 1, not true/false!
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      tid: _key,
      tname: _name,
      tactualColorIndex: _actualColorIndex,
      tisNotificationActive: _isNotificationActive ? 1 : 0,
      tnotifcationTime: _notificationTime.microsecondsSinceEpoch,
      tnotificationDays: _notificationDays,
      tlastTimeLearned: _lastTimeLearned.microsecondsSinceEpoch,
      tcourseIndexReference: _courseIndexReference,
      tisInReview: _isInReview ? 1 : 0
    };

    return map;
  }

  Map<String, dynamic> toMapWithouId() {
    var map = <String, dynamic>{
      tname: _name,
      tactualColorIndex: _actualColorIndex,
      tisNotificationActive: _isNotificationActive ? 1 : 0,
      tnotifcationTime: _notificationTime.microsecondsSinceEpoch,
      tnotificationDays: _notificationDays,
      tlastTimeLearned: _lastTimeLearned.microsecondsSinceEpoch,
      tcourseIndexReference: _courseIndexReference,
        tisInReview: _isInReview ? 1 : 0
    };

    return map;
  }

  SmartTask.fromMap(Map<String, dynamic> map) {
    _key = map[tid];
    _name = map[tname];
    _actualColorIndex = map[tactualColorIndex];
    _isNotificationActive = map[tisNotificationActive] == 1;
    _notificationTime =
        DateTime.fromMicrosecondsSinceEpoch(map[tnotifcationTime]);
    _notificationDays = map[tnotificationDays];
    _lastTimeLearned =
        DateTime.fromMicrosecondsSinceEpoch(map[tlastTimeLearned]);
    _courseIndexReference = map[tcourseIndexReference];
    _isInReview = map[tisInReview]==1;
  }
}

class SmartTaskProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
  create table $tableTodo ( 
  $primaryKey integer primary key autoincrement not null, 
  $tid integer unique not null, 
  $tname text not null,
  $tactualColorIndex integer not null,
  $tisNotificationActive bool not null,
  $tnotifcationTime integer not null,
  $tnotificationDays integer not null,
  $tlastTimeLearned integer not null,
  $tcourseIndexReference integer not null,
  $tisInReview integer not null
  )
''');
    });

    // foreign key($tcourseIndexReference) references ${course.tableTodo}(${course.cid}),
  }

  Future<int> insert(SmartTask todo) async {
    return await db.insert(tableTodo, todo.toMap());
  }

  Future<SmartTask> getTodo(int id, int cid) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [
          tid,
          tname,
          tactualColorIndex,
          tisNotificationActive,
          tnotifcationTime,
          tnotificationDays,
          tlastTimeLearned,
          tcourseIndexReference,
          tisInReview
        ],
        where: '$tid = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      var a = SmartTask.fromMap(maps.first);
      if (a.courseIndexReference == cid) return a;
    }
    return null;
  }

  Future<List<SmartTask>> getAll(int cid) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [
          tid,
          tname,
          tactualColorIndex,
          tisNotificationActive,
          tnotifcationTime,
          tnotificationDays,
          tlastTimeLearned,
          tcourseIndexReference,
          tisInReview
        ],
        where: '$tcourseIndexReference = ?',
        whereArgs: [cid]);
    if (maps.length > 0) {
      return maps.map((e) => SmartTask.fromMap(e)).toList();
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$tid = ?', whereArgs: [id]);
  }

  Future<int> update(SmartTask todo) async {
    return await db.update(tableTodo, todo.toMapWithouId(),
        where: '$tid = ?', whereArgs: [todo.key]);
  }

  Future close() async => db.close();
}
