import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';
import 'package:crypto/crypto.dart';

final String tableTodo = DatabaseNames.coursesName;
//For general Security unique of elementkey and other Key for DB to prevent incompatibility
final String primaryKey = 'pkey';
final String cid = 'cid';
final String cname = 'cname';
final String cdecriptionOne = 'cdesone';
final String cdecriptionTwo = 'cdestwo';
final String cisCustomTaskAllowed = 'cisctaskal';
final String cisRepeatWhenMistaken = 'cisrepmist';
final String cisRandomWordOrder = 'crndmwo';
final String clearnStrikes = 'clrnstrk';
final String creviewWeeks = 'crevwk';
final String cisOnline = 'cisonl';
final String cisOnlineCustomTaskAllowed = 'cconltskal';
final String cisCerified = 'ciscert';
final String cisPasswordRequired = 'cispswreeq';
final String cpasswordHash = 'cpswhash';
final String cdownloads = 'cdownld';

class Course {
  int _key = 0;
  String _name;
  String _decriptionOne;
  String _decriptionTwo;
  bool _isCustomTaskAllowed = false;
  bool _isRepeatWhenMistaken = false;
  bool _isRandomWordOrder = false;
  int _learnStrikes = 10;

  /*This here are the parametres for the future version */
  int _reviewWeeks = 0;

  bool _isOnline = false;
  bool _isOnlineCustomTaskAllowed = false;
  bool _isCerified = false;
  bool _isPasswordRequired = false;
  String _passwordHash = '';
  int _downloads = 0;

  Course({
    @required String newName,
    @required String newDescriptionOne,
    @required String newDescriptionTwo,
    @required int newKey,
    @required bool newIsCustomTaskAllowed,
    @required bool newIsRepeatWhenMistaken,
    @required bool newIsRandomWordOrder,
    @required int newLearnStrikes,
    @required int newReviewWeeks,
    bool newIsOnline = false,
    bool newIsOnlineCustomTaskAllowed = false,
    bool newIsCertified = false,
    bool newIsPasswordRequired = false,
    String newPasswordHash = 'x',
    int newDownloads = 0,
  }) {
    setName(newName);
    setDescriptionOne(newDescriptionOne);
    setDescriptionTwo(newDescriptionTwo);
    _setKey(newKey);
    setIsCustomTaskAllowed(newIsCustomTaskAllowed);
    setIsRepeatWhenMistaken(newIsRepeatWhenMistaken);
    setIsRandomWordOrder(newIsRandomWordOrder);
    setLearnStrikes(newLearnStrikes);
    setReviewWeeks(newReviewWeeks);
    setIsOnline(newIsOnline);
    setIsOnlineCustomIsTaskAllowed(newIsOnlineCustomTaskAllowed);
    setIsCertified(newIsCertified);
    setIsPasswordRequired(newIsPasswordRequired);
    setPasswordHash(newPasswordHash);
    setDownloads(newDownloads);
  }

  String get name => _name;

  setName(String newName) {
    if (newName != null) {
      if (newName != this._name) this._name = newName;
    }
  }

  String get descriptionOne => _decriptionOne;

  setDescriptionOne(String newDescriptionOne) {
    if (newDescriptionOne != null) {
      if (newDescriptionOne != this._decriptionOne)
        this._decriptionOne = newDescriptionOne;
    }
  }

  String get descriptionTwo => _decriptionTwo;

  setDescriptionTwo(String newDescriptionTwo) {
    if (newDescriptionTwo != null) {
      if (newDescriptionTwo != this._decriptionTwo)
        this._decriptionTwo = newDescriptionTwo;
    }
  }

  int get key => _key;

  _setKey(int newKey) {
    if (newKey != null) {
      if (newKey >= 0) _key = newKey;

      print('Offfffficillly::::. $_key');
    }
  }

  bool get isCustomTaskAllowed => _isCustomTaskAllowed;

  setIsCustomTaskAllowed(bool newIsCustomTaskAllowed) {
    if (newIsCustomTaskAllowed != null) {
      if (newIsCustomTaskAllowed != this._isCustomTaskAllowed)
        this._isCustomTaskAllowed = newIsCustomTaskAllowed;
    }
  }

  bool get isRepeatWhenMistaken => _isRepeatWhenMistaken;

  setIsRepeatWhenMistaken(bool newIsRepeatWhenMistaken) {
    if (newIsRepeatWhenMistaken != null) {
      if (newIsRepeatWhenMistaken != this._isRepeatWhenMistaken)
        this._isRepeatWhenMistaken = newIsRepeatWhenMistaken;
    }
  }

  bool get isRandomWordOrder => _isRandomWordOrder;

  setIsRandomWordOrder(bool newIsRandomWordOrder) {
    if (newIsRandomWordOrder != null) {
      if (newIsRandomWordOrder != this._isRandomWordOrder)
        this._isRandomWordOrder = newIsRandomWordOrder;
    }
  }

  int get learnStrikes => _learnStrikes;

  setLearnStrikes(int newLearnStrikes) {
    if (newLearnStrikes != null) {
      if (newLearnStrikes != this._learnStrikes &&
          newLearnStrikes >= CourseLimits.minMinLearningRepetitions &&
          newLearnStrikes <= CourseLimits.maxMinLearningRepetitions)
        this._learnStrikes = newLearnStrikes;
    }
  }

  int get reviewWeeks => _reviewWeeks;

  setReviewWeeks(int newReviewWeeks) {
    if (newReviewWeeks != null) {
      if (newReviewWeeks != this._reviewWeeks &&
          ((newReviewWeeks >= CourseLimits.minReviewWeeksAmount &&
                  newReviewWeeks <= CourseLimits.maxReviewWeeksAmount) ||
              newReviewWeeks == 0)) this._reviewWeeks = newReviewWeeks;
    }
  }

  List<int> get optionsReviewWeeksAmount {
    List<int> ret = [];
    for (int i = CourseLimits.minMinLearningRepetitions;
        i <= CourseLimits.maxReviewWeeksAmount;
        i++) ret.add(i);
    return ret;
  }

  bool get isReviewEnabled => _reviewWeeks > 0;

  setIsReviewEnabled(bool newIsReviewEnabled) {
    if (newIsReviewEnabled != null) {
      if (newIsReviewEnabled == false) _reviewWeeks = 0;
      if (newIsReviewEnabled == true)
        _reviewWeeks = CourseLimits.maxReviewWeeksAmount;
    }
  }

  bool get isOnline => _isOnline;

  setIsOnline(bool newIsOnline) {
    if (newIsOnline != null) {
      if (newIsOnline != this._isOnline) this._isOnline = newIsOnline;
    }
  }

  bool get isOnlineCustomTaskAllowed => _isOnlineCustomTaskAllowed;

  setIsOnlineCustomIsTaskAllowed(bool newIsTaskAllowed) {
    if (newIsTaskAllowed != null) {
      if (newIsTaskAllowed != this._isOnlineCustomTaskAllowed)
        this._isOnlineCustomTaskAllowed = newIsTaskAllowed;
    }
  }

  bool get isCertified => _isCerified;

  setIsCertified(bool newIsCertified) {
    if (newIsCertified != null) {
      if (newIsCertified != this._isCerified) this._isCerified = newIsCertified;
    }
  }

  bool get isPasswordRequired => _isPasswordRequired;

  setIsPasswordRequired(bool newIsPasswordRequired) {
    if (newIsPasswordRequired != null) {
      if (newIsPasswordRequired != this._isPasswordRequired)
        this._isPasswordRequired = newIsPasswordRequired;
    }
  }

  String get passwordHash => _passwordHash;

  setPasswordHash(String newPasswordHash) {
    if (newPasswordHash != null) _passwordHash = newPasswordHash;
  }

  setPasswordWithCovertToHash(String newPlainPasswordToHash) {
    if (newPlainPasswordToHash != null)
      _passwordHash =
          sha512.convert(utf8.encode(newPlainPasswordToHash)).toString();
  }

  int get downloadsInt => _downloads;

  String get downloads => _downloads > 0 ? '$_downloads' : '-';

  setDownloads(int newDownloads) {
    if (newDownloads != null) this._downloads = newDownloads;
  }

  addDownLoad() {
    _downloads++;
  }

  copyFrom(Course course) {
    if (course != null) {
      print('Copyfrom start:');
      print('To copy from : ${course.toString()}');
      setName(course.name);
      setDescriptionOne(course.descriptionOne);
      setDescriptionTwo(course.descriptionTwo);
      setIsCustomTaskAllowed(course.isCustomTaskAllowed);
      setIsRandomWordOrder(course.isRandomWordOrder);
      setIsRepeatWhenMistaken(course.isRepeatWhenMistaken);
      setLearnStrikes(course.learnStrikes);
      setReviewWeeks(course.reviewWeeks);
      setIsOnline(course.isOnline);
      setIsOnlineCustomIsTaskAllowed(course.isOnlineCustomTaskAllowed);
      setIsCertified(course.isCertified);
      setIsPasswordRequired(course.isPasswordRequired);
      setPasswordHash(course.passwordHash);
      setDownloads(course.downloadsInt);
    }
  }

  String toString() =>
      '{name: $_name; descriptionOne: $_decriptionOne; descriptionTwo: $_decriptionTwo; ' +
      'isCustomTaskAllowed_ $_isCustomTaskAllowed; isRandomWordOrder: $_isRandomWordOrder; ' +
      'isRepeatWhenMistaken: $_isRepeatWhenMistaken; learnstrikes: $_learnStrikes; reviewWeeks: $_reviewWeeks; ' +
      'isOnline: $_isOnline; isOnlineCustomTaskAllowed: $_isOnlineCustomTaskAllowed; isCertified: $_isCerified; ' +
      'isPasswordRequired: $_isPasswordRequired; passwordHash: $_passwordHash; downloads: $_downloads; key: $_key}';

  static Course deserialize(String course) {
    List<String> courseElement = _getListToSerializedString(course);

    return Course(
      newName: courseElement[0],
      newDescriptionOne: courseElement[1],
      newDescriptionTwo: courseElement[2],
      newKey: int.parse(courseElement[3]),
      newIsCustomTaskAllowed: bool.fromEnvironment(courseElement[4]),
      newIsRepeatWhenMistaken: bool.fromEnvironment(courseElement[5]),
      newIsRandomWordOrder: bool.fromEnvironment(courseElement[6]),
      newLearnStrikes: int.parse(courseElement[7]),
      newReviewWeeks: int.parse(courseElement[8]),
      newIsOnline: bool.fromEnvironment(courseElement[9]),
      newIsOnlineCustomTaskAllowed: bool.fromEnvironment(courseElement[10]),
      newIsCertified: bool.fromEnvironment(courseElement[11]),
      newIsPasswordRequired: bool.fromEnvironment(courseElement[12]),
      newPasswordHash: courseElement[13],
      newDownloads: int.parse(courseElement[14]),
    );
  }

  static String serialize(Course course) {
    List<String> ret = [];

    //This here should be reverse!

    ret.insert(0, '${course.downloads}');
    ret.insert(0, '${course.passwordHash}');
    ret.insert(0, '${course.isPasswordRequired}');
    ret.insert(0, '${course.isCertified}');
    ret.insert(0, '${course.isOnlineCustomTaskAllowed}');
    ret.insert(0, '${course.isOnline}');
    ret.insert(0, '${course.reviewWeeks}');
    ret.insert(0, '${course.learnStrikes}');
    ret.insert(0, '${course.isRepeatWhenMistaken}');
    ret.insert(0, '${course.isRandomWordOrder}');
    ret.insert(0, '${course.isCustomTaskAllowed}');
    ret.insert(0, '${course.key}');
    ret.insert(0, '${course.descriptionTwo}');
    ret.insert(0, '${course.descriptionOne}');
    ret.insert(0, '${course.name}');

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

  //Important: bool is allowed, but need to save either 0 or 1, not true/false!
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      cid: _key,
      cname: _name,
      cdecriptionOne: _decriptionOne,
      cdecriptionTwo: _decriptionTwo,
      cisCustomTaskAllowed: _isCustomTaskAllowed ? 1 : 0,
      cisRepeatWhenMistaken: _isRepeatWhenMistaken ? 1 : 0,
      cisRandomWordOrder: _isRandomWordOrder ? 1 : 0,
      clearnStrikes: _learnStrikes,
      creviewWeeks: _reviewWeeks,
      cisOnline: _isOnline ? 1 : 0,
      cisOnlineCustomTaskAllowed: _isOnlineCustomTaskAllowed ? 1 : 0,
      cisCerified: _isCerified ? 1 : 0,
      cisPasswordRequired: _isPasswordRequired ? 1 : 0,
      cpasswordHash: _passwordHash,
      cdownloads: _downloads
    };

    return map;
  }

  Map<String, dynamic> toMapWithouId() {
    var map = <String, dynamic>{
      cname: _name,
      cdecriptionOne: _decriptionOne,
      cdecriptionTwo: _decriptionTwo,
      cisCustomTaskAllowed: _isCustomTaskAllowed ? 1 : 0,
      cisRepeatWhenMistaken: _isRepeatWhenMistaken ? 1 : 0,
      cisRandomWordOrder: _isRandomWordOrder ? 1 : 0,
      clearnStrikes: _learnStrikes,
      creviewWeeks: _reviewWeeks,
      cisOnline: _isOnline ? 1 : 0,
      cisOnlineCustomTaskAllowed: _isOnlineCustomTaskAllowed ? 1 : 0,
      cisCerified: _isCerified ? 1 : 0,
      cisPasswordRequired: _isPasswordRequired ? 1 : 0,
      cpasswordHash: _passwordHash,
      cdownloads: _downloads
    };

    return map;
  }

  Course.fromMap(Map<String, dynamic> map) {
    _key = map[cid];
    _name = map[cname];
    _decriptionOne = map[cdecriptionOne];
    _decriptionTwo = map[cdecriptionTwo];
    _isCustomTaskAllowed = map[cisCustomTaskAllowed] == 1;
    _isRepeatWhenMistaken = map[cisRepeatWhenMistaken] == 1;
    _isRandomWordOrder = map[cisRandomWordOrder] == 1;
    _learnStrikes = map[clearnStrikes];
    _reviewWeeks = map[creviewWeeks];
    _isOnline = map[cisOnline] == 1;
    _isOnlineCustomTaskAllowed = map[cisOnlineCustomTaskAllowed] == 1;
    _isCerified = map[cisCerified] == 1;
    _isPasswordRequired = map[cisPasswordRequired] == 1;
    _passwordHash = map[cpasswordHash];
    _downloads = map[cdownloads];
  }
}

class CourseProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
  create table $tableTodo ( 
  $primaryKey integer primary key autoincrement not null, 
  $cid integer unique not null, 
  $cname text not null,
  $cdecriptionOne text not null,
  $cdecriptionTwo text not null,
  $cisCustomTaskAllowed bool not null,
  $cisRepeatWhenMistaken bool not null,
  $cisRandomWordOrder bool not null,
  $clearnStrikes integer not null,
  $creviewWeeks integer not null,
  $cisOnline bool not null,
  $cisOnlineCustomTaskAllowed bool not null,
  $cisCerified bool not null,
  $cisPasswordRequired bool not null,
  $cpasswordHash text not null,
  $cdownloads integer not null
  )
''');
    });
  }

  Future<int> insert(Course todo) async {
    print('\n\n\n\n\n To insert::: ${todo.toMap()}');
    return await db.insert(tableTodo, todo.toMap());
  }

  Future<Course> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [
          cid,
          cname,
          cdecriptionOne,
          cdecriptionTwo,
          cisCustomTaskAllowed,
          cisRepeatWhenMistaken,
          cisRandomWordOrder,
          clearnStrikes,
          creviewWeeks,
          cisOnline,
          cisOnlineCustomTaskAllowed,
          cisCerified,
          cisPasswordRequired,
          cpasswordHash,
          cdownloads
        ],
        where: '$cid = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Course.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Course>> getAll() async {
    List<Map> maps = await db.query(tableTodo);
    if (maps.length > 0) {
      return maps.map((e) => Course.fromMap(e)).toList();
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$cid = ?', whereArgs: [id]);
  }

  Future<int> update(Course todo) async {
    return await db.update(tableTodo, todo.toMapWithouId(),
        where: '$cid = ?', whereArgs: [todo.key]);
  }

  Future close() async => db.close();
}
