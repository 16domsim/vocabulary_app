import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class DataManager {
  static int _keySmartWord = 0;

  static loadKeySmartWord() async {
    final prefs = await SharedPreferences.getInstance();
    _keySmartWord = prefs.getInt(LoadSpecs.keysmartword);
    if (_keySmartWord == null) {
      _keySmartWord = 0;
      prefs.setInt(LoadSpecs.keysmartword, _keySmartWord);
    }
  }

  static _saveKeySmartWord() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(LoadSpecs.keysmartword, _keySmartWord);
  }

  static int get nextSmartwordKey {
    _keySmartWord++;
    _saveKeySmartWord();
    return _keySmartWord;
  }

  static int _keyTraining = 1;

  static loadKeyTraining() async {
    final prefs = await SharedPreferences.getInstance();
    _keyTraining = prefs.getInt(LoadSpecs.keyTraining);
    if (_keyTraining == null) {
      _keyTraining = 0;
      prefs.setInt(LoadSpecs.keyTraining, _keyTraining);
    }
  }

  static _saveKeyTraining() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(LoadSpecs.keyTraining, _keyTraining);
  }

  static int get nextTrainingKey {
    int ret = _keyTraining;
    //A key for every weekday/reviewMonth is needed! Otherwise it will not work!!!!!
    _keyTraining += CourseLimits.maxReviewWeeksAmount >
            CourseLimits.maxMinLearningRepetitions
        ? CourseLimits.maxReviewWeeksAmount
        : CourseLimits.maxMinLearningRepetitions;
    _saveKeyTraining();
    return ret;
  }

  static int _keyCourse = -1;

  static loadKeyCourse() async {
    final prefs = await SharedPreferences.getInstance();
    _keyCourse = prefs.getInt(LoadSpecs.keyCourse);
    if (_keyCourse == null) {
      _keyCourse = 0;
      prefs.setInt(LoadSpecs.keyCourse, _keyCourse);
    }
  }

  static _saveKeyCourse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(LoadSpecs.keyCourse, _keyCourse);
  }

  static int get nextCourseKey {
    _keyCourse++;
    _saveKeyCourse();
    return _keyCourse;
  }

/*
 * Necessary to navigate to a specific task after a notification was clicked
 */
  static int _navigateToTaskKey = -1;

  static bool _navigateToTask = false;

  static int get navigateToTaskKey => _navigateToTaskKey;

  static bool get navigateToTask => _navigateToTask;

  static setnavigateToTaskKey(int newKey) {
    if (newKey != null) {
      _navigateToTaskKey = newKey;
    }
  }

  static setnavigateToTask(bool newOne) {
    if (newOne != null) _navigateToTask = newOne;
  }

  static eraseBothNavigatePropeties() {
    _navigateToTaskKey = -1;
    _navigateToTask = false;
  }

  static int _accentColorIndex = 0;

  static int get accentColorIndex => _accentColorIndex;

  static set accentColorIndex(int newAccentColorIndex) {
    if (newAccentColorIndex != null) _accentColorIndex = newAccentColorIndex;
  }

  static loadAccentColorIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _accentColorIndex = prefs.getInt(LoadSpecs.accentColorIndex);
    if (_accentColorIndex == null) {
      _accentColorIndex = 0;
      prefs.setInt(LoadSpecs.accentColorIndex, _accentColorIndex);
    }
  }

  static Color get actualAccentColor =>
      ColorsOfTask.backGroundColors[_accentColorIndex];

  static String get actualAccentColorName =>
      ColorsOfTask.accentColorNames[_accentColorIndex];

  static List<String> get allAccentColorNames => ColorsOfTask.accentColorNames;

  static Color getactualTrainingColorToIndex(int index) {
    if (index < ColorsOfTask.backGroundColors.length)
      return ColorsOfTask.backGroundColors[index];
    return ColorsOfTask.backGroundColors[0];
  }

  static String getactualTrainingColornameToIndex(int index) {
    if (index < ColorsOfTask.backGroundColors.length)
      return ColorsOfTask.accentColorNames[index];
    return ColorsOfTask.accentColorNames[0];
  }

  static bool isColorIndexValid(int index) =>
      index >= 0 && index < ColorsOfTask.backGroundColors.length;

  static int _actualRandomColorIndex = 0;

  static initializeRandomColorIndexes() {
    Random coin = Random();
    _actualRandomColorIndex =
        coin.nextInt(ColorsOfTask.backGroundColors.length);
  }

  static int get nextRandomColorIndex {
    _actualRandomColorIndex++;
    _actualRandomColorIndex %= ColorsOfTask.backGroundColors.length;
    return _actualRandomColorIndex;
  }

  static Color get randomColor =>
      ColorsOfTask.backGroundColors[nextRandomColorIndex];

  static int _actualCourseKey = -1;

  static int get actualCourseKey => _actualCourseKey;

  static set actualCourseKey(int newActualCourseKey) {
    if (newActualCourseKey != null) _actualCourseKey = newActualCourseKey;
  }

  static loadKeyActualCourse() async {
    final prefs = await SharedPreferences.getInstance();
    _actualCourseKey = prefs.getInt(LoadSpecs.actualCourseKey);
    if (_actualCourseKey == null) {
      _actualCourseKey = 0;
      prefs.setInt(LoadSpecs.actualCourseKey, _actualCourseKey);
    }
  }

  static bool _isAutomaticSortingChange = false;

  static bool get isAutomaticSortingChange => _isAutomaticSortingChange;

  static set isAutomaticSortingChange(bool newIsAutomaticSortingChange) {
    if (newIsAutomaticSortingChange != null)
      _isAutomaticSortingChange = newIsAutomaticSortingChange;
  }

  static loadIsAutomaticSortingChange() async {
    final prefs = await SharedPreferences.getInstance();
    _isAutomaticSortingChange =
        prefs.getBool(LoadSpecs.isAutomaticSortingChange);
    if (_isAutomaticSortingChange == null) {
      _isAutomaticSortingChange = false;
      prefs.setBool(
          LoadSpecs.isAutomaticSortingChange, _isAutomaticSortingChange);
    }
  }

  static bool _navigationExperienceStatistics = false;

  static bool get navigationExperienceStatistics =>
      _navigationExperienceStatistics;

  static set navigationExperienceStatistics(
      bool newNavigationExperienceStatistics) {
    if (newNavigationExperienceStatistics != null)
      _navigationExperienceStatistics = newNavigationExperienceStatistics;
  }

  static loadnavigationExperienceStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    _navigationExperienceStatistics =
        prefs.getBool(LoadSpecs.navigationExperienceStatistics);
    if (_navigationExperienceStatistics == null) {
      _navigationExperienceStatistics = false;
      prefs.setBool(LoadSpecs.navigationExperienceStatistics,
          _navigationExperienceStatistics);
    }
  }

  static bool _isHideNotLernedWords = false;

  static bool get isHideNotLernedWords => _isHideNotLernedWords;

  static set isHideNotLernedWords(bool newIsHideNotLernedWords) {
    if (newIsHideNotLernedWords != null)
      _isHideNotLernedWords = newIsHideNotLernedWords;
  }

  static loadisHideNotLernedWords() async {
    final prefs = await SharedPreferences.getInstance();
    _isHideNotLernedWords = prefs.getBool(LoadSpecs.isHideNotLernedWords);
    if (_isHideNotLernedWords == null) {
      _isHideNotLernedWords = false;
      prefs.setBool(LoadSpecs.isHideNotLernedWords, _isHideNotLernedWords);
    }
  }

  static bool _isHideLearnedWords = false;

  static bool get isHideLearnedWords => _isHideLearnedWords;

  static set isHideLearnedWords(bool newIsHideLearnedWords) {
    if (newIsHideLearnedWords != null)
      _isHideLearnedWords = newIsHideLearnedWords;
  }

  static loadHideLearnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    _isHideLearnedWords = prefs.getBool(LoadSpecs.hideLearned);
    if (_isHideLearnedWords == null) {
      _isHideLearnedWords = false;
      prefs.setBool(LoadSpecs.hideLearned, _isHideLearnedWords);
    }
  }

  static int _displayModeIndex = 0;
  static int get displayModeIndex => _displayModeIndex;

  static set displayModeIndex(int newDisplayModeIndex) {
    if (newDisplayModeIndex != null) _displayModeIndex = newDisplayModeIndex;
  }

  static loadDisplayModeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    _displayModeIndex = prefs.getInt(LoadSpecs.displayModeIndex);
    if (_displayModeIndex == null) {
      _displayModeIndex = 0;
      prefs.setInt(LoadSpecs.displayModeIndex, _displayModeIndex);
    }
  }

  static bool _isDarkModeActive = false;

  static Color get actualBackgroundColor => _isDarkModeActive
      ? Color.fromRGBO(_darknessNumber, _darknessNumber, _darknessNumber, 1)
      : CupertinoColors.white;

  static Color get actualTextColor =>
      _isDarkModeActive ? CupertinoColors.white : CupertinoColors.black;

  static bool get isDarkModeActive => _isDarkModeActive;

  static set isDarkModeActive(bool newIsDarkModeActive) {
    if (newIsDarkModeActive != null) _isDarkModeActive = newIsDarkModeActive;
  }

  static loadBoolDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkModeActive = prefs.getBool(LoadSpecs.darkMode);
    if (_isDarkModeActive == null) {
      _isDarkModeActive = false;
      prefs.setBool(LoadSpecs.darkMode, _isDarkModeActive);
    }
  }

  //  Min is darkest, max is brightest
  static int _darknessNumber = DarknessNumbers.minDarknessNumber;

  static int get darknessNumber => _darknessNumber;

  static set darknessNumber(int newDarknessNumber) {
    if (newDarknessNumber != null) _darknessNumber = newDarknessNumber;
  }

  static loadDarknessNumber() async {
    final prefs = await SharedPreferences.getInstance();
    _darknessNumber = prefs.getInt(LoadSpecs.darknessNumber);
    if (_darknessNumber == null) {
      _darknessNumber = DarknessNumbers.minDarknessNumber;
      prefs.setInt(LoadSpecs.darknessNumber, _darknessNumber);
    }
  }

  //Let, otherwis it wont work
  static String _languageUnicodeID = 'x';

  static String get languageUnicodeID => _languageUnicodeID;

  static set languageUnicodeID(String newLanguageUnicodeID) {
    if (newLanguageUnicodeID != null) _languageUnicodeID = newLanguageUnicodeID;
  }

  static loadlanguageUnicodeID() async {
    final prefs = await SharedPreferences.getInstance();
    _languageUnicodeID = prefs.getString(LoadSpecs.languageUnicodeID);
    if (_languageUnicodeID == null) {
      _languageUnicodeID = '';
      prefs.setString(LoadSpecs.languageUnicodeID, _languageUnicodeID);
    }
  }
}
