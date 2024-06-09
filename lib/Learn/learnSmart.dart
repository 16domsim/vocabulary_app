import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/taskManager.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class SmartTrainer extends StatefulWidget {
  int _taskKey;
  bool _closeSecondContext = false;

  SmartTrainer(this._taskKey, this._closeSecondContext)
      : assert(_taskKey != null && _closeSecondContext != null);

  _SmartTrainerS createState() =>
      _SmartTrainerS(this._taskKey, this._closeSecondContext);
}

class _SmartTrainerS extends State<SmartTrainer> {

  int _taskKey;



  TextEditingController _textEditingController = TextEditingController();

  bool _displayRed = false;
  bool _finished = false;
  bool _forward = false;

  Widget _display;

  AppState _model = null;

  int _strikes = 0;
  int _tries = 0;

  bool _isWordShow = true;
  List<String> _wordsUnknownShow = [];
  List<String> _wordsKnownShow = [];

  int _totalWordsOfTraining = 0;
  int _currenWord = 0;

  int _wordsShowIndex = 0;

  bool _secondTap = false;
  bool _dontAddCounterBecauseWordWasMistaken = false;
  bool _wasLastWordWrongForWordWasMistaken = false;
  bool _saveResults = true;

  bool _closeSecondContext = false;

  _SmartTrainerS(this._taskKey, this._closeSecondContext);

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (contextExtern, model, child) {
        if (_model == null) {
          _model = model;
          AppState.setTraining(_taskKey);
        
          _saveResults = TaskManager.isCurrentTrainingInLearnMode;
          if (_isWordShow) {
            _wordsUnknownShow = TaskManager.unknownTrainingWordsForShow;
            _wordsKnownShow = TaskManager.knownTrainingWordsForShow;
            _totalWordsOfTraining = _wordsKnownShow.length;
          }
        }
        if (_totalWordsOfTraining == 0) {
          _currenWord = -1;
          _display = Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'There are no words available in this task',
                  style: TextStyle(color: CupertinoColors.inactiveGray),
                ),
              ),
            ),
          );
        } else {
          if (_isWordShow) {
            String wordTwoForSteadiness = _wordsKnownShow[_wordsShowIndex];
            if (!_secondTap && _wordsShowIndex > 0)
              wordTwoForSteadiness = _wordsKnownShow[_wordsShowIndex - 1];
            _display = Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: FlipCard(
                front: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 5,
                    color: DataManager.actualAccentColor.withOpacity(0.1),
                    child: Center(
                      child: Text(
                        '${_wordsUnknownShow[_wordsShowIndex]}',
                        style: TextStyle(color: DataManager.actualTextColor),
                      ),
                    ),
                  ),
                ),
                back: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height / 5,
                    color: DataManager.actualAccentColor.withOpacity(0.1),
                    child: Center(
                      child: Text(
                        '$wordTwoForSteadiness',
                        style: TextStyle(color: DataManager.actualTextColor),
                      ),
                    ),
                  ),
                ),
                direction: FlipDirection.HORIZONTAL,
                speed: 500,
                onFlip: () {
                  setState(() {
                    if (_secondTap) {
                      _secondTap = false;
                      if (_wordsShowIndex + 1 < _wordsUnknownShow.length) {
                        //Continue here, hide the previous word!
                        _wordsShowIndex++;
                        _currenWord++;
                      } else {
                        _isWordShow = false;
                        _currenWord = 0;
                      }
                    } else
                      _secondTap = true;
                  });
                },
              ),
            );
          } else {
            if (_finished)
              _display = _doneDisplay();
            else if (TaskManager.getActualAskForegin())
              _display = _askUnknownLanguage();
            else
              _display = _askKnownLanguage();
          }
        }

        return CupertinoPageScaffold(
          key: Key('TASK KEY 323283'),
          navigationBar: CupertinoNavigationBar(
            middle: _finished
                ? Text(
                    'Finished ${!_saveResults ? 'training' : (TaskManager.isActualTaskInReview ? 'review' : '')}',
                    style: TextStyle(color: DataManager.actualTextColor),
                  )
                : Text(
                     AppState.isRepeatWhenMistaken && !_isWordShow
                   
                        ? 'Word ($_currenWord/$_totalWordsOfTraining)'
                        : 'Word (${_currenWord + 1}/$_totalWordsOfTraining)',
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
            automaticallyImplyLeading: false,
            trailing: _finished
                ? Container(
                    width: 1,
                    height: 1,
                  )
                : CupertinoButton(
                    child: Text(
                      'Quit',
                      style: TextStyle(color: DataManager.actualAccentColor),
                    ),
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text('Quit'),
                            content: Padding(
                              padding: EdgeInsets.only(
                                  top: 20, left: 5, right: 5, bottom: 10),
                              child: Text(
                                  'Do you really want to quit the task?' +
                                      (_saveResults
                                          ? ' Your progress will not be saved.'
                                          : '')),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: CupertinoColors.destructiveRed),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(contextExtern);
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: DataManager.actualAccentColor),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
          ),
          child: Container(
            color: DataManager.actualBackgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: <Widget>[_display],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _generalOkButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CupertinoButton.filled(
              child: Text(
                  _currenWord < _totalWordsOfTraining - 1 ? 'Next' : 'Finish'),
              onPressed: () {
                print(_currenWord);
                if (_textEditingController.text.trim() == '') {
                  setState(() {
                    _displayRed = true;
                  });
                } else if ((TaskManager.getActualAskForegin() &&
                        _textEditingController.text.trim() ==
                            TaskManager.getActualTrainingWord().unknownWord) ||
                    (!TaskManager.getActualAskForegin() &&
                        _textEditingController.text.trim() ==
                            TaskManager.getActualTrainingWord().knownWord) ||
                    _forward) {
                  setState(
                    () {
                      _tries++;
                      if (!_forward) {
                        if (_saveResults)
                          TaskManager.addTryToActualTrainingWord(true);
                        _strikes++;
                        _wasLastWordWrongForWordWasMistaken = false;
                      } else {
                        if (_saveResults)
                          TaskManager.addTryToActualTrainingWord(false);
                        if (AppState.isRepeatWhenMistaken) {
                          _wasLastWordWrongForWordWasMistaken = true;
                          TaskManager.setActualTrainingWordForRepetition();
                          _dontAddCounterBecauseWordWasMistaken = true;
                        }
                      }
                      if (_currenWord < _totalWordsOfTraining - 1 ||
                          _wasLastWordWrongForWordWasMistaken) {
                        if (_dontAddCounterBecauseWordWasMistaken)
                          _dontAddCounterBecauseWordWasMistaken = false;
                        else
                          _currenWord++;
                        TaskManager.setNextTrainigWord();
                        _textEditingController.text = '';
                        _displayRed = false;
                        _forward = false;
                        if (TaskManager.getActualAskForegin())
                          _display = _askUnknownLanguage();
                        else
                          _display = _askKnownLanguage();
                      } else {
                        _finished = true;
                        _model.saveResults();
                        _display = _doneDisplay();
                      }
                    },
                  );
                } else {
                  setState(
                    () {
                      _forward = true;
                      _displayRed = true;
                      _textEditingController.text =
                          TaskManager.getActualAskForegin()
                              ? TaskManager.getActualTrainingWord().unknownWord
                              : TaskManager.getActualTrainingWord().knownWord;
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _askUnknownLanguage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      color: DataManager.actualBackgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  child: Text(
                    AppState.descriptionTwo,
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
                ),
                Expanded(
                  child: Text(TaskManager.getActualTrainingWord().knownWord,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: DataManager.actualTextColor)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  child: Text(
                    AppState.descriptionOne,
                    style: TextStyle(
                        color: _displayRed
                            ? CupertinoColors.destructiveRed
                            : DataManager.actualTextColor),
                  ),
                ),
                Expanded(
                  child: CupertinoTextField(
                    maxLines: 1,
                    maxLength: 20,
                    maxLengthEnforced: true,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    style: TextStyle(
                        color: _displayRed
                            ? CupertinoColors.destructiveRed
                            : DataManager.actualTextColor),
                    controller: _textEditingController,
                    placeholderStyle: TextStyle(
                        color: DataManager.actualTextColor.withOpacity(0.5)),
                    decoration: BoxDecoration(
                      color: DataManager.actualBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.5, color: DataManager.actualAccentColor),
                    ),
                    cursorColor: DataManager.actualAccentColor,
                  ),
                ),
              ],
            ),
          ),
          _generalOkButton(),
        ],
      ),
    );
  }

  Widget _askKnownLanguage() {
    return Container(
      color: DataManager.actualBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  child: Text(
                    AppState.descriptionOne,
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
                ),
                Expanded(
                  child: Text(TaskManager.getActualTrainingWord().unknownWord,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: DataManager.actualTextColor)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  child: Text(
                    AppState.descriptionTwo,
                    style: TextStyle(
                        color: _displayRed
                            ? CupertinoColors.destructiveRed
                            : DataManager.actualTextColor),
                  ),
                ),
                Expanded(
                  child: CupertinoTextField(
                    maxLines: 1,
                    maxLength: 20,
                    maxLengthEnforced: true,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    style: TextStyle(
                        color: _displayRed
                            ? CupertinoColors.destructiveRed
                            : DataManager.actualTextColor),
                    controller: _textEditingController,
                    placeholderStyle: TextStyle(
                        color: DataManager.actualTextColor.withOpacity(0.5)),
                    decoration: BoxDecoration(
                      color: DataManager.actualBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.5, color: DataManager.actualAccentColor),
                    ),
                    cursorColor: DataManager.actualAccentColor,
                  ),
                ),
              ],
            ),
          ),
          _generalOkButton(),
        ],
      ),
    );
  }

  bool _firstEnterForProgressAnimation = true;
  double _sucsessRateNumber = 0;
  String _sucsessRateString = '';
  bool _setRateToZeroForAnimation = true;

  Widget _doneDisplay() {
    if (AppState.isRepeatWhenMistaken) {
      _sucsessRateNumber = (10000 * _strikes / _tries).round() / 100;
      _sucsessRateString = '$_sucsessRateNumber';
      if (_sucsessRateString.endsWith('.0'))
        _sucsessRateString =
            _sucsessRateString.substring(0, _sucsessRateString.length - 2);
      if (_sucsessRateString.endsWith('0') && _sucsessRateString.contains('.'))
        _sucsessRateString =
            _sucsessRateString.substring(0, _sucsessRateString.length - 1);
      _sucsessRateNumber /= 100;

      if (_firstEnterForProgressAnimation) {
        _sucsessRateNumber = 0;
        _firstEnterForProgressAnimation = false;
        _waitToAnimatePercent();
      }
      if (_setRateToZeroForAnimation) _sucsessRateNumber = 0;
    }

    int totalWordsLearned =       TaskManager.totalWordsLearnedAfterFinished ;

    return SizedBox(
      height: MediaQuery.of(context).size.height - 150,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        color: DataManager.actualBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                AppState.isRepeatWhenMistaken
                    ? RichText(
                        text: TextSpan(
                          text: 'Sucsessrate: ',
                          style: TextStyle(
                            color: DataManager.actualTextColor,
                            fontSize: 26,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '$_sucsessRateString%',
                              style: TextStyle(
                                  color: DataManager.actualTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        'Your Score:',
                        style: TextStyle(
                          fontSize: 26,
                          color: DataManager.actualTextColor,
                        ),
                      ),
                AppState.isRepeatWhenMistaken
                    ? Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Stack(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      height: 12,
                                      color: ProgressIndicatorParams
                                          .backgroundColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: AnimatedContainer(
                                height: 12,
                                width:
                                    (MediaQuery.of(context).size.width - 40) *
                                        _sucsessRateNumber,
                                color: DataManager.actualAccentColor,
                                duration:
                                    ProgressIndicatorParams.animationDuration,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          '$_strikes/$_totalWordsOfTraining',
                          style: TextStyle(
                              fontSize: 60, color: DataManager.actualTextColor),
                        ),
                      ),
              ],
            ),
            totalWordsLearned>0 && _saveResults
                ? RichText(
                    text: TextSpan(
                      text: 'You learned ',
                      style: TextStyle(
                        color: DataManager.actualTextColor,
                        fontSize: 26,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              '$totalWordsLearned',
                          style: TextStyle(
                              color: DataManager.actualTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:         totalWordsLearned ==
                                  1
                              ? ' new word.'
                              : ' new words.',
                          style: TextStyle(
                            color: DataManager.actualTextColor,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 0),
                  ),
            Text(
                    TaskManager.allWordsLearnedAfterFinished
                     ? (  TaskManager.allWordsLearnedGoldAfterFinished
                      ? 'You finished this task!'
                      : 'You entered the review!')
                  : 'Good job!',
              style:
                  TextStyle(fontSize: 30, color: DataManager.actualTextColor),
            ),
            CupertinoButton.filled(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                if (_closeSecondContext) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  _waitToAnimatePercent() async {
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      _setRateToZeroForAnimation = false;
    });
  }
}
