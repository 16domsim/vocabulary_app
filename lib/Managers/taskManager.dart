import 'dart:math';
import 'package:rem_bra/Objects/taskElement.dart';
import 'package:rem_bra/Objects/wordElement.dart';
import '../appsate.dart';

class TaskManager {
  static List<SmartWord> _taskWords = [];
  static List<bool> _askForegin = [];
  static int _actualWordIndex = -1;

  static bool _isCurrentTrainingInLearnMode = true;

  static SmartTask _currentTask;

  static Random _coin = Random();

  static bool _doNotAddForRepetition = false;

  static List<String> get unknownTrainingWordsForShow {
    List<String> ret = [];
    for (int i = 0; i < _taskWords.length; i++)
      ret.add(_taskWords[i].unknownWord);
    return ret;
  }

  static List<String> get knownTrainingWordsForShow {
    List<String> ret = [];
    for (int i = 0; i < _taskWords.length; i++)
      ret.add(_taskWords[i].knownWord);
    return ret;
  }

  static bool get isCurrentTrainingInLearnMode => _isCurrentTrainingInLearnMode;

  static SmartWord getActualTrainingWord() {
    print('r=$_actualWordIndex a=${_taskWords.length}');
    if (_actualWordIndex < _taskWords.length) {
      return _taskWords[_actualWordIndex];
    }
    return null;
  }

  static setNextTrainigWord() {
    if (_actualWordIndex < _taskWords.length) {
      if (!_doNotAddForRepetition)
        _actualWordIndex++;
      else
        _doNotAddForRepetition = false;
    }
  }

  static setActualTrainingWordForRepetition() {
    if (AppState.isRepeatWhenMistaken) {
      _doNotAddForRepetition = true;
      _askForegin[_actualWordIndex] = _coin.nextInt(2) == 0;
    }
  }

  static addTryToActualTrainingWord(bool striked) {
    if (_actualWordIndex < _taskWords.length)
      _taskWords[_actualWordIndex].addTry(striked);

    print('Taskwords:: $_taskWords');
    print('ActualReal:: ${AppState.allWordsSimoneDomenici}');
  }

  static bool getActualAskForegin() {
    if (_actualWordIndex < _taskWords.length)
      return _askForegin[_actualWordIndex];
    return null;
  }

  static setTraining(SmartTask currentTask, List<SmartWord> taskWords) {
    _currentTask = currentTask;
    _taskWords = taskWords;
    _askForegin.clear();
    _actualWordIndex = 0;
    _isCurrentTrainingInLearnMode = true;

    if (AppState.isRandomWordOrder) _taskWords.shuffle();
    Random coin = Random();
    for (int i = 0; i < _taskWords.length; i++)
      _askForegin.add(coin.nextInt(2) == 0);

    if (_currentTask.getIndexInOfTaskState(DateTime.now()) != 0)
      _isCurrentTrainingInLearnMode = false;
  }

  static int get totalWordsLearnedAfterFinished =>
      _taskWords.where((e) => e.learned).length;

  static bool get allWordsLearnedAfterFinished =>
      !_taskWords.any((e) => !e.learned);

  static int get totalWordsLearnedGoldAfterFinished =>
      _taskWords.where((e) => e.learnedGold).length;

  static bool get allWordsLearnedGoldAfterFinished =>
      !_taskWords.any((e) => !e.learnedGold);

  static SmartTask get smartTaskAfterFinished => _currentTask;

  static List<SmartWord> get smartWordsAfterFinished => _taskWords;

  static bool get isActualTaskInReview =>
      AppState.isReviewEnabled && _currentTask.isInReview;
}
