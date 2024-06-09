import 'dart:core';

import 'dart:ui';

import 'package:flutter/cupertino.dart';

class LoadSpecs {
  static final int displayLogoDuration = 1000;
  static final int colorTransitionDuration = 800;

  static final String displayModeIndex = 'a1';
  static final String customLearning = 'a2';
  static final String darkMode = 'a3';
  static final String minlearningRepetitions = 'a4';
  static final String darknessNumber = 'a5';
  static final String accentColorIndex = 'a6';
  static final String trainingTask = 'a7';
  static final String keysmartword = 'a8';
  static final String keyTraining = 'a9';
  static final String hideLearned = 'a10';
  static final String repeatMistaken = 'a11';
  static final String randomOrderAtEveryTraining = 'a12';
  static final String isHideNotLernedWords = 'a13';
  static final String navigationExperienceStatistics = 'a14';
  static final String isReviewEnabled = 'a15';
  static final String reviewWeeksAmount = 'a16';
  static final String isAutomaticSortingChange = 'a17';
  static final String keyCourse = 'a18';
  static final String allCorses = 'a19';
  static final String actualCourseKey = 'a20';
  static final String wordsOne = 'a21';
  static final String languageUnicodeID = 'a22';
}

class CourseLimits {
  static final int minMinLearningRepetitions = 1;
  static final int maxMinLearningRepetitions = 15;

  static List<int> get learningRepetitionOptions {
    List<int> ret = [];
    for (var i = minMinLearningRepetitions; i <= maxMinLearningRepetitions; i++)
      ret.add(i);
    return ret;
  }

  static final int minReviewWeeksAmount = 4;
  static final int maxReviewWeeksAmount = 12;

  static List<int> get reviewWeekOptions {
    List<int> ret = [];
    for (var i = minReviewWeeksAmount; i <= maxReviewWeeksAmount; i++)
      ret.add(i);
    return ret;
  }
}

class TaskLimits {
  static final int startMinWordsTask = 1;
  static final int intervalWordTask = 1;
  static final int endMaxWordsTask = 30;
}

class DatabaseNames {
  static final String coursesName = 'one';
  static final String tasksName = 'zwei';
  static final String smartWordsName = 'tre';

  static final String coursesPath = 'one.db';
  static final String tasksPath = 'zwei.db';
  static final String smartWordsPath = 'tre.db';
}

class FreeSpace {
  static final double minSpaceToRunApp = 10.1;
  static final Duration memorySpaceControllerIntervall =
      Duration(milliseconds: 100);
}

class ColorsOfTask {
  static final List<String> accentColorNames = [
    'blue',
    'red',
    'orange',
    'green',
    'purple'
  ];

  static final List<Color> backGroundColors = [
    CupertinoColors.activeBlue,
    CupertinoColors.destructiveRed,
    CupertinoColors.activeOrange,
    CupertinoColors.activeGreen,
    CupertinoColors.systemPurple
  ];
}

class DarknessNumbers {
  static final int minDarknessNumber = 0;
  static final int maxDarknessNumber = 60;
}

class DisplayModes {
  static final List<String> displayModeDescriptions = [
    'A-Z',
    'Z-A',
    'newest',
    'oldest',
    'highest succsess',
    'lowest sucsess'
  ];
}

class ProgressIndicatorParams {
  static final Duration animationDuration = Duration(milliseconds: 560);
  static final Color backgroundColor = CupertinoColors.lightBackgroundGray;
}

class SupportedLanguages {
  static const String englishUnicodeID = 'en';
  static const String italianUnicodeID = 'it';
  static const String germanUnicodeID = 'de';

//This two lists have to be in the same order!
  static final List<String> languageUnicodeIDs = [
    englishUnicodeID,
    italianUnicodeID,
    germanUnicodeID
  ];
  static final List<String> languageDescriptions = [
    'English',
    'Italiano',
    'Deutsch'
  ];
}

class PrefixesForDisplayedTextes {
  static const String wordsBottomIcon = 'wordsBottomIcon';
  static const String wordsBigTitle = 'wordsBigTitle';

  static const String learnBottomIcon = 'learnBottomIcon';
  static const String learnBigTitle = 'learnBigTitle';

  static const String statisticsBottomIcon = 'statisticsBottomIcon';
  static const String statisticsBigTitle = 'statisticsBigTitle';

  static const String settingsBottomIcon = 'settingsBottomIcon';
  static const String settingsBigTitle = 'settingsBigTitle';
}
