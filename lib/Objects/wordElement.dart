import 'package:flutter/material.dart';
import 'package:rem_bra/constants.dart';
import 'package:sqflite/sqflite.dart';

import '../appsate.dart';

final String tableTodo = DatabaseNames.smartWordsName;
//For general Security unique of elementkey and other Key for DB to prevent incompatibility
final String primaryKey = 'pkey';
final String sid = 'sid';
final String sunknownword = 'sunknow';
final String sknownword = 'sknow';
final String scourseIndexReference = 'scouid';
final String staskIndexReference = 'stasid';
final String sstrikes = 'sstrikes';
final String stries = 'stries';
final String slearned = 'slearned';
final String slearnedGold = 'slearnedGold';

class SmartWord {
  int _key;
  String _unknownWord;
  String _knownWord;

  int _courseIndexReference = -1;
  int _taskIndexReference = -1;

  int _strikes = -1;
  int _tries = -1;

  bool _learned = false;
  bool _learnedGold = false;

  SmartWord(
      {@required String newUnknownWord,
      @required String newknownWord,
      @required int newKey,
      @required int newCourseIndexReference,
      int newTaskIndexReference = -1,
      int newStrikes = -1,
      int newTries = -1,
      bool learned = false,
      bool learnedGold = false}) {
    setUnkownWord(newUnknownWord);
    setKownWord(newknownWord);
    _setKey(newKey);
    _setCourseIndexReference(newCourseIndexReference);
    setTaskIndexReference(newTaskIndexReference);
    _setStrikes(newStrikes);
    _setTries(newTries);
    setLearned(learned);
    setLearnedGold(learnedGold);
  }

  String get unknownWord => _unknownWord;

  setUnkownWord(String newUnknownWord) {
    if (newUnknownWord != null) this._unknownWord = newUnknownWord;
  }

  String get knownWord => _knownWord;

  setKownWord(String newKnownWord) {
    if (newKnownWord != null) this._knownWord = newKnownWord;
  }

  int get courseIndexReference => _courseIndexReference;

  _setCourseIndexReference(int newCourseIndexReference) {
    if (newCourseIndexReference != null) {
      if (newCourseIndexReference >= 0)
        _courseIndexReference = newCourseIndexReference;
    }
  }

  int get taskIndexReference => _taskIndexReference;

  setTaskIndexReference(int newTaskIndexReference) {
    if (newTaskIndexReference != null) {
      if (newTaskIndexReference >= -1)
        _taskIndexReference = newTaskIndexReference;
    }
  }

  resetTaskIndexReference() {
    setTaskIndexReference(-1);
  }

  resetStatistics() {
    _strikes = -1;
    _tries = -1;
    _learned = false;
    _learnedGold = false;
  }

  int get key => _key;

  _setKey(int newKey) {
    if (newKey != null) {
      if (newKey >= 0) _key = newKey;
    }
  }

  String get strikes => _strikes == -1 ? '-' : '$_strikes';

  int get strikesInt => _strikes;

  _setStrikes(int newStrikes) {
    if (newStrikes != null) {
      if (newStrikes >= 0 && newStrikes <= _tries) _strikes = newStrikes;
    }
  }

  String get tries => _tries == -1 ? '-' : '$_tries';

  int get triesInt => _tries;

  _setTries(int newTries) {
    if (newTries != null) {
      if (newTries >= 0 && newTries >= _strikes) _tries = newTries;
    }
  }

  void addTry(bool striked) {
    if (striked) {
      if (_strikes == -1)
        _strikes += 2;
      else
        _strikes++;
    }
    if (_tries == -1)
      _tries += 2;
    else
      _tries++;
    if (_strikes >= AppState.learnStrikes) setLearned(true);
    if (AppState.isReviewEnabled && _strikes >= AppState.reviewWeeks)
      setLearnedGold(true);
  }

  double get sucsessrate {
    if (_tries != -1 && _strikes != -1)
      return ((10000 * _strikes / _tries).round() / 100);
    return 0;
  }

  bool get learned => _learned;

  setLearned(bool learned) {
    if (learned != null) {
      if (_strikes >= CourseLimits.minMinLearningRepetitions)
        _learned = learned;
    }
  }

  bool get learnedGold => _learnedGold;

  setLearnedGold(bool learnedGold) {
    if (learnedGold != null) {
      if (_learned) _learnedGold = learnedGold;
    }
  }

  copyFrom(SmartWord smartWord) {
    if (smartWord != null) {
      if (_unknownWord != smartWord.unknownWord ||
          _knownWord != smartWord.knownWord ||
          _taskIndexReference != smartWord.taskIndexReference) {
        resetStatistics();
        setUnkownWord(smartWord.unknownWord);
        setKownWord(smartWord.knownWord);
        setTaskIndexReference(smartWord.taskIndexReference);
      }
    }
  }

  String toString() =>
      '{unknown: $_unknownWord; known: $_knownWord; strikes: $_strikes; tries: $_tries; courseKey: $_courseIndexReference; taskKey: $_taskIndexReference; learned: $_learned; learnedGold: $_learnedGold; key: $_key}';

  bool equals(SmartWord other) {}

  static SmartWord deserialize(String course) {
    List<String> smartWordElement = _getListToSerializedString(course);

    return SmartWord(
      newUnknownWord: smartWordElement[0],
      newknownWord: smartWordElement[1],
      newKey: int.parse(smartWordElement[2]),
      newCourseIndexReference: int.parse(smartWordElement[3]),
      newTaskIndexReference: int.parse(smartWordElement[4]),
      newStrikes: int.parse(smartWordElement[5]),
      newTries: int.parse(smartWordElement[6]),
      learned: bool.fromEnvironment(smartWordElement[7]),
      learnedGold: bool.fromEnvironment(smartWordElement[8]),
    );
  }

  static String serialize(SmartWord smartWord) {
    List<String> ret = [];

    //This here should be reverse!

    ret.insert(0, '${smartWord.learnedGold}');
    ret.insert(0, '${smartWord.learned}');
    ret.insert(0, '${smartWord.tries}');
    ret.insert(0, '${smartWord.strikes}');
    ret.insert(0, '${smartWord.taskIndexReference}');
    ret.insert(0, '${smartWord.courseIndexReference}');
    ret.insert(0, '${smartWord.key}');
    ret.insert(0, '${smartWord.knownWord}');
    ret.insert(0, '${smartWord.unknownWord}');

    return _getStringToSerializedList(ret);
  }

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

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      sid: _key,
      sunknownword: _unknownWord,
      sknownword: _knownWord,
      scourseIndexReference: _courseIndexReference,
      staskIndexReference: _taskIndexReference,
      sstrikes: _strikes,
      stries: _tries,
      slearned: _learned ? 1 : 0,
      slearnedGold: _learnedGold ? 1 : 0
    };

    return map;
  }

  Map<String, dynamic> toMapWithouId() {
    var map = <String, dynamic>{
      sunknownword: _unknownWord,
      sknownword: _knownWord,
      scourseIndexReference: _courseIndexReference,
      staskIndexReference: _taskIndexReference,
      sstrikes: _strikes,
      stries: _tries,
      slearned: _learned ? 1 : 0,
      slearnedGold: _learnedGold ? 1 : 0
    };

    return map;
  }

  SmartWord.fromMap(Map<String, dynamic> map) {
    _key = map[sid];
    _unknownWord = map[sunknownword];
    _knownWord = map[sknownword];
    _courseIndexReference = map[scourseIndexReference];
    _taskIndexReference = map[staskIndexReference];
    _strikes = map[sstrikes];
    _tries = map[stries];
    _learned = map[slearned] == 1;
    _learnedGold = map[slearnedGold] == 1;
  }
}

class SmartWordProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
  create table $tableTodo ( 
  $primaryKey integer primary key autoincrement not null, 
  $sid integer unique not null, 
  $sunknownword text not null,
  $sknownword text not null,
  $scourseIndexReference integer not null,
  $staskIndexReference integer not null,
  $sstrikes integer not null,
  $stries integer not null,
  $slearned integer not null,
  $slearnedGold integer not null
  )
''');
    });
  }
  // foreign key($scourseIndexReference) references ${course.tableTodo}(${course.cid}),
  // foreign key($staskIndexReference) references ${task.tableTodo}(${task.tid})

  Future<int> insert(SmartWord todo) async {
    return await db.insert(tableTodo, todo.toMap());
  }

  Future<SmartWord> getTodo(int id, int cid) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [
          sid,
          sunknownword,
          sknownword,
          scourseIndexReference,
          staskIndexReference,
          sstrikes,
          stries,
          slearned,
          slearnedGold
        ],
        where: '$sid = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      var a = SmartWord.fromMap(maps.first);
      if (a.courseIndexReference == cid) return a;
    }
    return null;
  }

  Future<List<SmartWord>> getAll(int cid) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [
          sid,
          sunknownword,
          sknownword,
          scourseIndexReference,
          staskIndexReference,
          sstrikes,
          stries,
          slearned,
          slearnedGold
        ],
        where: '$scourseIndexReference = ?',
        whereArgs: [cid]);
    if (maps.length > 0) {
      return maps.map((e) => SmartWord.fromMap(e)).toList();
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$sid = ?', whereArgs: [id]);
  }

  Future<int> update(SmartWord todo) async {
    return await db.update(tableTodo, todo.toMapWithouId(),
        where: '$sid = ?', whereArgs: [todo.key]);
  }

  Future close() async => db.close();
}
