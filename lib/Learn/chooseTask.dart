import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Learn/addTaskSpecifications.dart';
import 'package:rem_bra/Learn/customTaskChoose.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ChooseTask extends StatefulWidget {
  _ChooseTaskS createState() => _ChooseTaskS();
}

class _ChooseTaskS extends State<ChooseTask> {
  int _wordslenght = 0;

  static final int startMinWordsTask = TaskLimits.startMinWordsTask;
  static final int intervalWordTask = TaskLimits.intervalWordTask;
  static final int endMaxWordsTask = TaskLimits.endMaxWordsTask;

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        DataManager.initializeRandomColorIndexes();
        _wordslenght = AppState.totalWordsAvailableForTask;

        List<Widget> _possibleTrainingWidgets = [];
        for (int i = startMinWordsTask;
            i <= endMaxWordsTask;
            i += intervalWordTask) {
          _possibleTrainingWidgets.add(trainingStartingItemRandomly(
              'Randomly $i', i, DataManager.nextRandomColorIndex));
        }
        if (_wordslenght < startMinWordsTask) {
          _possibleTrainingWidgets.clear();
          _possibleTrainingWidgets.add(
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Add some words to add a task',
                  style: TextStyle(color: CupertinoColors.inactiveGray),
                ),
              ),
            ),
          );
        }

        String previousPageTitle = DemoLocalizations.of(context).learnBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';
          
        return CupertinoPageScaffold(
          backgroundColor: DataManager.actualBackgroundColor,
          key: Key('CHOOSE TASK KEY 3212312'),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: '$previousPageTitle',
            transitionBetweenRoutes: true,
            middle: Text(
              'choose task',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
            trailing: AppState.isCustomLearningActive
                ? CupertinoButton(
                    child: Icon(CupertinoIcons.collections),
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => CustomTask(),
                        ),
                      );
                    },
                  )
                : Padding(padding: EdgeInsets.only(top: 0)),
          ),
          child: ListView(
            children: _possibleTrainingWidgets,
          ),
        );
      },
    );
  }

  Widget trainingStartingItemRandomly(
      String title, int wordsamount, int backgroundColorIndex) {
    if (_wordslenght >= wordsamount) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => AddTaskSpecifications(
                    AppState.randomKeysForTask(wordsamount),
                    backgroundColorIndex,
                    false),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: DataManager.getactualTrainingColorToIndex(
                  backgroundColorIndex),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _wordslenght >= wordsamount
                            ? Text('$wordsamount words')
                            : Text('$_wordslenght words')
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else
      return Padding(
        padding: EdgeInsets.only(top: 0),
      );
  }
}
