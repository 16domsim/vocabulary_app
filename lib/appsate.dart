import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/taskManager.dart';
import 'package:rem_bra/Objects/courseElement.dart';
import 'package:rem_bra/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'Managers/generalTaskManager.dart';
import 'Objects/taskElement.dart';
import 'Objects/wordElement.dart';

/* TODO: 
 * Divide all this Methods in diffrent Classes!!!
 * It may take some time, but then it is way easier to manage for the future 
 * 
 * For now made everything possible static, this was the first step!
 */

//Implement sqflite!!!!!! Made it!

class AppState extends ChangeNotifier {
  AppState() {
    onStart();
    notifyListeners();
  }

  onStart() {
    _loadData();
  }

  _loadData() async {
    //Display message if there is not enough memory space! Come on!!
    //Order needed for proper appwork!
    DateTime start = DateTime.now();
    await DataManager.loadBoolDarkMode();
    await DataManager.loadDarknessNumber();
    await DataManager.loadlanguageUnicodeID();
    //For nice color transition on the begin on darkmode
    notifyListeners();
    await DataManager.loadKeySmartWord();
    await DataManager.loadKeyTraining();
    await DataManager.loadKeyCourse();
    await DataManager.loadKeyActualCourse();
    await _loadCoursesPro();
    await _loadWordsPro();
    await _loadTasksPro();
    await DataManager.loadDisplayModeIndex();
    await DataManager.loadAccentColorIndex();
    await DataManager.loadHideLearnedWords();
    await DataManager.loadisHideNotLernedWords();
    await DataManager.loadnavigationExperienceStatistics();
    await DataManager.loadIsAutomaticSortingChange();
    DateTime end = DateTime.now();
    int dif = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    if (dif < LoadSpecs.displayLogoDuration) {
      await new Future.delayed(
          Duration(milliseconds: (LoadSpecs.displayLogoDuration - dif)));
    }
    loaded = true;
    notifyListeners();
  }

  //Keep pushing men! Just keep pushing! Economy always gives you some positive results unlike other things in life!

  static bool loaded = false;

  static bool reactiveSearchAtReturn = false;
  static bool _shouldDisplayWordsReload = true;

  static SmartWordProvider _smartWordProvider = SmartWordProvider();
  static SmartTaskProvider _smartTaskProvider = SmartTaskProvider();
  static CourseProvider _courseProvider = CourseProvider();

  /**
   * Manages the display of the words
   */

  static List<SmartWord> wordsForDisplay = [];

  static void reloadWordsForDisplay() {
    wordsForDisplay.clear();
    wordsForDisplay.addAll(_languageOne);
    if (DataManager.isHideLearnedWords) {
      wordsForDisplay.removeWhere((s) => s.learned);
    } else if (DataManager.isHideNotLernedWords) {
      wordsForDisplay.removeWhere((s) => !s.learned);
    }
    switch (DataManager.displayModeIndex) {
      case 0:
        {
          wordsForDisplay
              .sort((a, b) => a.unknownWord.compareTo(b.unknownWord));
          break;
        }
      case 1:
        {
          wordsForDisplay
              .sort((a, b) => -1 * a.unknownWord.compareTo(b.unknownWord));
          break;
        }
      case 2:
        {
          wordsForDisplay = wordsForDisplay.reversed.toList();
          break;
        }
      case 3:
        {
          break;
        }
      case 4:
        {
          wordsForDisplay
              .sort((a, b) => -1 * a.sucsessrate.compareTo(b.sucsessrate));
          break;
        }
      case 5:
        {
          wordsForDisplay
              .sort((a, b) => a.sucsessrate.compareTo(b.sucsessrate));
          break;
        }
    }
    _shouldDisplayWordsReload = false;
  }

  static int get wordsForDisplayLenght {
    if (_shouldDisplayWordsReload) reloadWordsForDisplay();
    return wordsForDisplay.length;
  }

  static SmartWord getWordAtIndexEfficentPro(int index) {
    if (_shouldDisplayWordsReload) reloadWordsForDisplay();
    if (index >= 0 && index < wordsForDisplay.length) {
      return wordsForDisplay[index];
    }
    return null;
  }

  static String get allWordsSimoneDomenici {
    String ret = '';
    for (var i = 0; i < _languageOne.length; i++)
      ret += SmartWord.serialize(_languageOne[i]);
    return ret;
  }

  static bool containsWord(String firstWord) {
    return _languageOne.indexWhere((w) => w.unknownWord == firstWord) != -1;
  }

  static SmartWord getWordThatAlredyHasValueOfGiven(String firstWord) {
    SmartWord ret = _languageOne.firstWhere((s) => s.unknownWord == firstWord);
    return ret;
  }

  _reloadWordsAndTraings() async {
    await _loadWordsPro();
    await _loadTasksPro();
    reloadWordsForDisplay();
    notifyListeners();
  }

  /**
   * Word operations
   */

  //Pay attention not to give back a List, because then it gives a Pointer that would be problemtaic! Always use ret!
  static List<SmartWord> _languageOne = [];

  static _loadWordsPro() async {
    await _smartWordProvider
        .open(await getDatabasesPath() + DatabaseNames.smartWordsPath);
    _languageOne.clear();
    _languageOne = await _smartWordProvider.getAll(DataManager.actualCourseKey);
    if (_languageOne == null) _languageOne = [];
    print('Words: $_languageOne');
  }

  bool isWordLearned(SmartWord word) {
    return word.strikesInt >= learnStrikes;
  }

  addWord(SmartWord newWord) {
    if (newWord != null) {
      _languageOne.add(newWord);
      _addWord(newWord);
    }
  }

  _addWord(SmartWord word) async {
    _smartWordProvider.insert(word).then((value) {
      _shouldDisplayWordsReload = true;
      notifyListeners();
    });
  }

  setWord(SmartWord oldWord, SmartWord newWord) {
    if (oldWord != null && newWord != null) {
      int index = _languageOne.indexWhere((s) => s.key == oldWord.key);
      if (index != -1) {
        _languageOne[index].copyFrom(newWord);
        _updateWord(_languageOne[index]);
      }
    }
  }

  _updateWord(SmartWord word) async {
    _smartWordProvider.update(word).then((value) {
      print('SmartWord was updated: $value');
      notifyListeners();
    });
  }

  delWord(SmartWord word) {
    if (word != null) {
      if (_languageOne.contains(word)) {
        _languageOne.remove(word);
        _deleteWord(word);
      }
    }
  }

  _deleteWord(SmartWord word) {
    _smartWordProvider.delete(word.key).then((value) {
      print(value);
      _shouldDisplayWordsReload = true;
      notifyListeners();
    });
  }

  delAllWords() async {
    if (_languageOne.isNotEmpty) {
      for (var word in _languageOne) {
        _deleteWord(word);
      }
      _languageOne.clear();
    }
  }

  /**
   * Operations for custom task, check wether it is possible to melt it with the normal wordsowerview
   */

  static List<SmartWord> _wordsForDisplayCustomTask = [];

  static List<SmartWord> _allWordsCustomTask = [];

  static bool _shouldDisplayWordsReloadCustomTask = true;

  static void initializeCustomTaskMode() {
    _wordsForDisplayCustomTask.clear();
    _allWordsCustomTask.clear();

//Maybe the second paramtere should be changed here
    _allWordsCustomTask.addAll(_languageOne.where((element) =>
        element.taskIndexReference == -1 && element.strikes == '-'));
    //Continue here! I am doing great! Come on men!!!

    reloadWordsForDisplayCustomTask();
  }

  static void reloadWordsForDisplayCustomTask() {
    _wordsForDisplayCustomTask.clear();
    _wordsForDisplayCustomTask.addAll(_allWordsCustomTask);

    _wordsForDisplayCustomTask
        .sort((a, b) => a.unknownWord.compareTo(b.unknownWord));

    print(_wordsForDisplayCustomTask);
    _shouldDisplayWordsReloadCustomTask = false;
  }

  static int get wordsForDisplayLenghtCustomTask {
    if (_shouldDisplayWordsReloadCustomTask) reloadWordsForDisplayCustomTask();
    return _wordsForDisplayCustomTask.length;
  }

  static SmartWord getWordAtIndexEfficentProCustomTask(int index) {
    if (_shouldDisplayWordsReloadCustomTask) reloadWordsForDisplayCustomTask();
    if (index >= 0 && index < _wordsForDisplayCustomTask.length) {
      return _wordsForDisplayCustomTask[index];
    }
    return null;
  }

  /**
   * Operations for task
   */

  static List<SmartTask> _taskElements = [];

  static List<SmartTask> get trainingElements {
    List<SmartTask> ret = _taskElements;
    return ret;
  }

  static String taskWhereWordIsUsed(int taskIndexReference) {
    String ret = '';
    if (taskIndexReference != null) {
      if (taskIndexReference != -1) {
        int validIndex =
            _taskElements.lastIndexWhere((t) => t.key == taskIndexReference);
        if (validIndex != -1) ret = _taskElements[validIndex].name;
      }
    }
    return ret;
  }

  static _loadTasksPro() async {
    await _smartTaskProvider
        .open(await getDatabasesPath() + DatabaseNames.tasksPath);
    _taskElements.clear();
    _taskElements =
        await _smartTaskProvider.getAll(DataManager.actualCourseKey);
    if (_taskElements == null) _taskElements = [];
    print(_taskElements);
  }

  addTask(SmartTask newTask, List<int> _keysOfSmartWords) {
    if (newTask != null) {
      _taskElements.add(newTask);
      if (newTask.isNotificationActive) {
        List<Day> allDays = Day.values;
        List<bool> weekDays = newTask.notificationDays;
        DateTime dateTime = newTask.notificationTime;
        Time time = Time(dateTime.hour, dateTime.minute, 0);
        for (int i = 0; i < weekDays.length; i++) {
          if (weekDays[i])
            GeneralTaskManager.showTaskWeeklyAtDayAndTime(
                'It is time for ${newTask.name} task.',
                time,
                allDays[i],
                newTask.key + i,
                newTask.key,
                _actualCourse.key);
        }
      }
      _addTask(newTask);
      for (var swkey in _keysOfSmartWords) {
        int index =
            _languageOne.lastIndexWhere((element) => element.key == swkey);
        _languageOne[index].setTaskIndexReference(newTask.key);
        _updateWord(_languageOne[index]);
      }
    }
  }

  _addTask(SmartTask task) async {
    _smartTaskProvider.insert(task).then((value) {
      print('AAA $value');
      print(task.toString());
      _shouldDisplayWordsReload = true;
      notifyListeners();
    });
  }

  setTask(SmartTask oldOne, SmartTask newOne) async {
    int indexOfWord = _taskElements.indexWhere((a) => a.key == oldOne.key);
    if (indexOfWord > 0) {
      _taskElements[indexOfWord].copyFrom(newOne);
      bool previousNotificationActive =
          _taskElements[indexOfWord].isNotificationActive;

      if (previousNotificationActive && !newOne.isNotificationActive) {
        int key = _taskElements[indexOfWord].key;
        int weekDayMaxKey = key + 7;
        for (var i = key; i < weekDayMaxKey; i++)
          await GeneralTaskManager.cancelNotificationByKey(i);
      }
      if (_taskElements[indexOfWord].isNotificationActive) {
        List<Day> allDays = Day.values;
        List<bool> weekDays = _taskElements[indexOfWord].notificationDays;
        DateTime dateTime = _taskElements[indexOfWord].notificationTime;
        Time time = Time(dateTime.hour, dateTime.minute, 0);
        if (_actualCourse.isReviewEnabled &&
            _taskElements[indexOfWord].isInReview) {
          await GeneralTaskManager.showReviewNextWeeks(
              'It is time for ${_taskElements[indexOfWord].name} review!',
              time,
              _taskElements[indexOfWord].key,
              _taskElements[indexOfWord].key,
              _actualCourse.reviewWeeks,
              _actualCourse.key);
        } else {
          for (int i = 0; i < weekDays.length; i++) {
            if (weekDays[i])
              await GeneralTaskManager.showTaskWeeklyAtDayAndTime(
                  'It is time for ${_taskElements[indexOfWord].name} task.',
                  time,
                  allDays[i],
                  _taskElements[indexOfWord].key + i,
                  _taskElements[indexOfWord].key,
                  _actualCourse.key);
          }
        }
      }
      //_saveTrainingTasks();
      _updateTask(_taskElements[indexOfWord]);
    }
  }

  _updateTask(SmartTask task) async {
    _smartTaskProvider.update(task).then((value) {
      print(value);
      notifyListeners();
    });
  }

  delTask(SmartTask task) {
    if (task != null) {
      if (_taskElements.contains(task)) {
        int keyForWordsToResetTask = task.key;
        _taskElements.remove(task);

        if (task.isNotificationActive) {
          int keyStart = task.key;
          int weekDayMaxKey = keyStart + task.notificationDays.length;
          for (var i = keyStart; i < weekDayMaxKey; i++)
            GeneralTaskManager.cancelNotificationByKey(i);
        }
        if (_actualCourse.isReviewEnabled && task.isInReview) {
          int keyStart = task.key;
          int weekDayMaxKey = keyStart + task.notificationDays.length;
          for (var i = keyStart; i < weekDayMaxKey; i++)
            GeneralTaskManager.cancelNotificationByKey(i);
        }
        _deleteTask(task);
        _languageOne
            .where((element) =>
                element.taskIndexReference == keyForWordsToResetTask)
            .forEach((element) {
          element.resetStatistics();
          element.resetTaskIndexReference();
          _updateWord(element);

          ///help.resetStatistics(); Made automatically in copyFrom
          // setWord(element, help);
        });
      }
    }
  }

  _deleteTask(SmartTask task) {
    _smartTaskProvider.delete(task.key).then((value) {
      print('This task was deleted: $value');
      _shouldDisplayWordsReload = true;
      notifyListeners();
    });
  }

  delAllTasks() async {
    if (_taskElements.isNotEmpty) {
      do {
        int key = _taskElements[0].key;
        _deleteTask(_taskElements[0]);
        _taskElements.removeAt(0);
        int weekDayMaxKey = key + 7;
        for (var i = key; i < weekDayMaxKey; i++)
          GeneralTaskManager.cancelNotificationByKey(i);
      } while (_taskElements.isNotEmpty);
    }
  }

  static bool isTaskTitleSetted(String possibleName) =>
      _taskElements.any((a) => a.name == possibleName);

  static bool isTaskKeySetted(int possibleKey) =>
      _taskElements.any((a) => a.key == possibleKey);

  static String get possibleTaskName {
    int i = 1;
    String name = 'My new task';
    while (isTaskTitleSetted(name)) {
      name = 'My new task $i';
      i++;
    }
    return name;
  }

  static int get totalWordsAvailableForTask {
    return _languageOne
        .where(
            (element) => element.taskIndexReference == -1 && !element.learned)
        .length;
  }

  static List<int> get allWordsKeysAvailableForTask {
    List<int> ret = [];
    _languageOne.forEach((element) => {
          if (element.taskIndexReference == -1 && !element.learned)
            ret.add(element.key)
        });

    return ret;
  }

  static List<int> randomKeysForTask(int amount) {
    List<int> ret = [];
    int totalWordsLenght = totalWords;
    if (amount <= totalWordsLenght) {
      List<int> possibleKeysForNewTask = allWordsKeysAvailableForTask;
      if (amount <= possibleKeysForNewTask.length) {
        possibleKeysForNewTask.shuffle();
        ret.addAll(possibleKeysForNewTask.sublist(0, amount));
      }
    }
    return ret;
  }

  bool isTaskStillValidByKey(int taskKey) {
    if (!_languageOne
        .any((element) => (element.taskIndexReference == taskKey))) {
      delTask(_taskElements.firstWhere((t) => t.key == taskKey));
      return false;
    }
    return true;
  }

  static setTraining(int taskKey) {
    SmartTask taskForTraining =
        _taskElements.firstWhere((t) => t.key == taskKey, orElse: () => null);

    if (taskForTraining != null) {
      int trainingKey = taskForTraining.key;
      List<SmartWord> wordsForTraining = _languageOne.where((w) {
        if (w.taskIndexReference == trainingKey) {
          if (w.learned) return false;

          return true;
        }
        return false;
      }).toList();
      print('Words:::\n\n\n $wordsForTraining');
      List<SmartWord> wordsForTrainingH = wordsForTraining;

      TaskManager.setTraining(taskForTraining, wordsForTrainingH);
    }
  }

  saveResults() async {
    SmartTask _actualTaskToSave = TaskManager.smartTaskAfterFinished;
    List<SmartWord> _actualWordsToSave = TaskManager.smartWordsAfterFinished;
    if (TaskManager.isCurrentTrainingInLearnMode)
      _actualTaskToSave.setLastTimeLearned(DateTime.now());

    int totalWords = 0;
    int learnedWords = 0;
    int learnedWordsGold = 0;

    int taskKey = _actualTaskToSave.key;

    _languageOne.forEach((element) {
      if (element.courseIndexReference == taskKey) {
        totalWords++;
        if (element.learned) {
          learnedWords++;
          if (element.learnedGold) learnedWordsGold++;
        }
      }
    });

    bool delTaskWhenFinished = false;

    //Continue here! Reeeview seesm to do not properly work!
    if (totalWords == learnedWords) {
      if (_actualCourse.isReviewEnabled) {
        if (totalWords == learnedWordsGold)
          delTaskWhenFinished = true;
        else if (_actualTaskToSave.isNotificationActive &&
            !_actualTaskToSave.isInReview) {
          int weekDayMaxKey = _actualTaskToSave.key + 7;
          for (int i = _actualTaskToSave.key; i < weekDayMaxKey; i++)
            await GeneralTaskManager.cancelNotificationByKey(i);
          await GeneralTaskManager.showReviewNextWeeks(
              'It is time for ${_actualTaskToSave.name} review!',
              Time(_actualTaskToSave.notificationTime.hour,
                  _actualTaskToSave.notificationTime.minute),
              _actualTaskToSave.key,
              _actualTaskToSave.key,
              _actualCourse.reviewWeeks,
              _actualCourse.key);
        }
      } else {
        delTaskWhenFinished = true;
      }
    }

    delTaskWhenFinished
        ? _deleteTask(_actualTaskToSave)
        : _updateTask(_actualTaskToSave);
    for (SmartWord sw in _actualWordsToSave) _updateWord(sw);
  }

/**
 * Statistical data.
 */
  static int get totalWords => _languageOne.length;

  static int get totalWordsLearned {
    int ret = 0;
    for (SmartWord i in _languageOne) {
      if (i.learned) ret++;
    }
    return ret;
  }

  static int get totalStrikes {
    int ret = 0;
    for (SmartWord i in _languageOne)
      if (i.strikes != '-') ret += int.parse(i.strikes);

    return ret;
  }

  static int get totalTries {
    int ret = 0;
    for (SmartWord i in _languageOne)
      if (i.tries != '-') ret += int.parse(i.tries);
    return ret;
  }

  setAllNavigationPropertiesOfTask(
      bool navigateToTask, int courseKey, int taskKey) async {
    DataManager.setnavigateToTask(navigateToTask);
    if (navigateToTask) {
      await setActualCourseKey(courseKey);
      DataManager.setnavigateToTaskKey(taskKey);
    }
  }

/**
 * The operations for the course and the actual course.
 */
  static List<Course> _courses = [];

  static Course _actualCourse;

  static List<Course> get coursesList {
    List<Course> ret = _courses;
    return ret;
  }

  static bool get isCustomLearningActive => _actualCourse.isCustomTaskAllowed;
  static bool get isRepeatWhenMistaken => _actualCourse.isRepeatWhenMistaken;
  static bool get isRandomWordOrder => _actualCourse.isRandomWordOrder;
  static String get descriptionOne => _actualCourse.descriptionOne;
  static String get descriptionTwo => _actualCourse.descriptionTwo;
  static int get learnStrikes => _actualCourse.learnStrikes;
  static bool get isReviewEnabled => _actualCourse.isReviewEnabled;
  static int get reviewWeeks => _actualCourse.reviewWeeks;

  static bool isNameOfCourseIsAlreadyOccupied(String possiblyOccupiedname) =>
      _courses.indexWhere((c) => c.name == possiblyOccupiedname) != -1;

  _loadCoursesPro() async {
    await _courseProvider
        .open(await getDatabasesPath() + DatabaseNames.coursesPath);
    _courses.clear();
    _courses = await _courseProvider.getAll();

    if (_courses == null) _courses = [];
    print('Courses: $_courses');
    _addDefaultCourseIfThereAreNotAnyOther();
    _actualCourse =
        _courses.firstWhere((c) => c.key == DataManager.actualCourseKey);
  }

  addCourse(Course newCourse) {
    if (newCourse != null) {
      if (!isNameOfCourseIsAlreadyOccupied(newCourse.name)) {
        _courses.add(newCourse);
        print('Course added:  $_courses');
        _addCourse(newCourse);
      }
    }
  }

  _addCourse(Course course) async {
    _courseProvider.insert(course).then((value) {
      _shouldDisplayWordsReload = true;
      notifyListeners();
    });
  }

  _addDefaultCourseIfThereAreNotAnyOther() {
    if (_courses.length == 0) {
      var h = Course(
        newName: 'Default',
        newDescriptionOne: 'desOne',
        newDescriptionTwo: 'desTwo',
        newKey: DataManager.nextCourseKey,
        newIsCustomTaskAllowed: false,
        newIsRepeatWhenMistaken: true,
        newIsRandomWordOrder: true,
        newLearnStrikes: 6,
        newReviewWeeks: 0,
      );
      addCourse(h);
      setActualCourseKey(_courses[0].key);
    }
  }

  setCourse(int keyOfCourseToSet, Course newCourse) {
    if (newCourse != null) {
      var h = _courses.indexWhere((c) => c.key == keyOfCourseToSet);
      if (h != -1) {
        _courses[h].copyFrom(newCourse);
        _updateCourse(_courses[h]);
        print(_courses[h].toString());
      }
    }
  }

  _updateCourse(Course course) async {
    _courseProvider.update(course).then((value) {
      print(value);
      notifyListeners();
    });
  }

  delCourse(int keyOfCourseToDelete) async {
    var h = _courses.lastIndexWhere((c) => c.key == keyOfCourseToDelete);
    if (h != -1) {
      _deleteCourse(_courses[h]);
      _courses.removeAt(h);
      //Mantain this order for proper Appwork
      await delAllTasks();
      await delAllWords();
      print('Index:  $h');
      if (keyOfCourseToDelete == DataManager.actualCourseKey &&
          _courses.length > 0) setActualCourseKey(_courses[0].key);
      _addDefaultCourseIfThereAreNotAnyOther();
    }
  }

  _deleteCourse(Course course) async {
    _courseProvider.delete(course.key).then((value) {
      _shouldDisplayWordsReload = true;
      print('Response is: $value');
      notifyListeners();
    });
  }

  /**
   * Functions to set various App Paramaters and save that setting.
   */

  setActualCourseKey(int keyOfCourseToBeSet) {
    if (keyOfCourseToBeSet != null) {
      if (_courses.indexWhere((c) => c.key == keyOfCourseToBeSet) != -1) {
        DataManager.actualCourseKey = keyOfCourseToBeSet;
        _actualCourse =
            _courses.firstWhere((c) => c.key == DataManager.actualCourseKey);
        _saveKeyActualCourse();
        _reloadWordsAndTraings();
      }
    }
  }

  _saveKeyActualCourse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(LoadSpecs.actualCourseKey, DataManager.actualCourseKey);
    notifyListeners();
  }

  setAccentColorIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < ColorsOfTask.backGroundColors.length) {
      DataManager.accentColorIndex = newIndex;
      _saveAccentColorIndex();
    }
  }

  _saveAccentColorIndex() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(LoadSpecs.accentColorIndex, DataManager.accentColorIndex);
    notifyListeners();
  }

  setHideLearnedWords(bool newValue) {
    DataManager.isHideLearnedWords = newValue;
    _saveHideLearnedWords();
  }

  _saveHideLearnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(LoadSpecs.hideLearned, DataManager.isHideLearnedWords);
    _shouldDisplayWordsReload = true;
    notifyListeners();
  }

  setisHideNotLernedWords(bool newValue) {
    DataManager.isHideNotLernedWords = newValue;
    _saveisHideNotLernedWords();
  }

  _saveisHideNotLernedWords() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(
        LoadSpecs.isHideNotLernedWords, DataManager.isHideNotLernedWords);
    notifyListeners();
  }

  setnavigationExperienceStatistics(bool newValue) {
    DataManager.navigationExperienceStatistics = newValue;
    _savenavigationExperienceStatistics();
  }

  _savenavigationExperienceStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(LoadSpecs.navigationExperienceStatistics,
        DataManager.navigationExperienceStatistics);
    notifyListeners();
  }

  setIsAutomaticSortingChange(bool newValue) {
    DataManager.isAutomaticSortingChange = newValue;
    _saveIsAutomaticSortingChange();
  }

  _saveIsAutomaticSortingChange() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(LoadSpecs.isAutomaticSortingChange,
        DataManager.isAutomaticSortingChange);
    notifyListeners();
  }

  setDisplayModeIndex(int newIndex) {
    if (newIndex >= 0 &&
        newIndex < DisplayModes.displayModeDescriptions.length) {
      DataManager.displayModeIndex = newIndex;
      _saveDisplayModeIndex();
    }
  }

  setNextDisplayModeIndex() {
    DataManager.displayModeIndex++;
    if (DataManager.displayModeIndex >=
        DisplayModes.displayModeDescriptions.length)
      DataManager.displayModeIndex = 0;
    _saveDisplayModeIndex();
  }

  _saveDisplayModeIndex() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(LoadSpecs.displayModeIndex, DataManager.displayModeIndex);
    _shouldDisplayWordsReload = true;
    notifyListeners();
  }

  setDarkMode(bool newValue) {
    DataManager.isDarkModeActive = newValue;
    _saveDarkMode();
  }

  _saveDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(LoadSpecs.darkMode, DataManager.isDarkModeActive);
    notifyListeners();
  }

  setDarknessNumber(int newValue) {
    if (newValue >= DarknessNumbers.minDarknessNumber &&
        newValue <= DarknessNumbers.maxDarknessNumber) {
      DataManager.darknessNumber = newValue;
      _saveDarknessNumber();
    }
  }

  _saveDarknessNumber() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(LoadSpecs.darknessNumber, DataManager.darknessNumber);
    notifyListeners();
  }

  setLanguageUnicodeID(String newValue) {
    if (newValue != null) {
      DataManager.languageUnicodeID = newValue;
      _saveLanguageUnicodeID();
    }
  }

  _saveLanguageUnicodeID() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(LoadSpecs.languageUnicodeID, DataManager.languageUnicodeID);
    notifyListeners();
  }
}
