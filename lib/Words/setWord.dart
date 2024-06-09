import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Objects/wordElement.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';
import 'package:rem_bra/Words/wordShow.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

//disk_space: ^0.0.3
class SetWord extends StatefulWidget {
  SmartWord _word;
  bool _previousWasWordShow = false;
  BuildContext _context = null;
  bool _secondStepToPreventInfiniteNavigation = false;

  SetWord(this._word, this._previousWasWordShow,
      this._secondStepToPreventInfiniteNavigation,
      {BuildContext contextToClose})
      : assert(_word != null &&
            _previousWasWordShow != null &&
            _secondStepToPreventInfiniteNavigation != null) {
    if (contextToClose != null) _context = contextToClose;
  }

  _SetWordS createState() => _context == null
      ? _SetWordS(
          _word, _previousWasWordShow, _secondStepToPreventInfiniteNavigation)
      : _SetWordS(
          _word, _previousWasWordShow, _secondStepToPreventInfiniteNavigation,
          contextToClose: _context);
}

class _SetWordS extends State<SetWord> {
  TextEditingController _languageOne = new TextEditingController();
  TextEditingController _languageTwo = new TextEditingController();
  bool _isTextOneRed = false;
  bool _isTextTwoRed = false;
  SmartWord _word;

  bool _previousWasWordShow = false;
  SmartWord _initialWord;
  BuildContext _context = null;

  bool _secondStepToPreventInfiniteNavigation = false;

  _SetWordS(this._word, this._previousWasWordShow,
      this._secondStepToPreventInfiniteNavigation,
      {BuildContext contextToClose}) {
    if (contextToClose != null) _context = contextToClose;
  }

  Widget build(BuildContext context) {
    _languageOne.text = _word.unknownWord;
    _languageTwo.text = _word.knownWord;
    _initialWord = _word;
    return Consumer<AppState>(
      builder: (context, model, child) {

          String previousPageTitle = DemoLocalizations.of(context).wordsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';
        return CupertinoPageScaffold(
          key: Key('SET WORD KEY 643973'),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle:
                _previousWasWordShow ? 'Word Details' : '$previousPageTitle',
            transitionBetweenRoutes: true,
            middle: Text(
              'Set word',
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
                   AppState.descriptionOne,
                    _languageOne,
                    _isTextOneRed,
                    true,
                    true,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                SettingUnits.createSettingUnitBigSpacer(),
                // Padding(padding: EdgeInsets.only(top:50)),

                SettingUnits.createSettingTextfieldUnit(
                     AppState.descriptionTwo,
                    _languageTwo,
                    _isTextTwoRed,
                    true,
                    true,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CupertinoButton.filled(
                    child: Text('Save'),
                    onPressed: () {
                      print(_languageOne.text);
                      if (_languageOne.text.isEmpty) {
                        setState(
                          () {
                            _isTextOneRed = true;
                          },
                        );
                      } else
                        _isTextOneRed = false;

                      if (_languageTwo.text.isEmpty) {
                        setState(
                          () {
                            _isTextTwoRed = true;
                          },
                        );
                      } else
                        _isTextTwoRed = false;

                      if (!_isTextOneRed && !_isTextTwoRed) {
                  
                      if (_languageOne.text.trim() ==
                                _initialWord.unknownWord &&
                            _languageTwo.text.trim() ==
                                _initialWord.knownWord) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Word has not changed'),
                                content: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 5, right: 5, bottom: 10),
                                  child: Text(
                                      'At least change one of the two parameters before saving your word.'),
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
                        } else if (AppState
                                .containsWord(_languageOne.text.trim()) &&
                            _languageOne.text.trim() !=
                                _initialWord.unknownWord) {
                          SmartWord _wordH =
                              AppState.getWordThatAlredyHasValueOfGiven(
                                  _languageOne.text.trim());
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Word exists already'),
                                content: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 5, right: 5, bottom: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_secondStepToPreventInfiniteNavigation) {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    WordShow(_wordH, true)));
                                      }
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            'You have already saved a word called ',
                                        style: TextStyle(
                                            color: CupertinoColors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: _languageOne.text.trim(),
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
                                  )
                                ],
                              );
                            },
                          );
                        } else if (_languageOne.text.trim() ==
                            _languageTwo.text.trim()) {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text('Words are the same'),
                                content: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 5, right: 5, bottom: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'The word ',
                                      style: TextStyle(
                                          color: CupertinoColors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: _languageOne.text.trim(),
                                            style: TextStyle(
                                                color: CupertinoColors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                              ' is used in both ${AppState.descriptionOne} and ${AppState.descriptionTwo} .',
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
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          String response = AppState.taskWhereWordIsUsed(_word.taskIndexReference);
                          if (response.isEmpty && response == '') {
                            //This is not the best way, check if word has changed!
                            SmartWord newWord = SmartWord(
                                newUnknownWord: _languageOne.text.trim(),
                                newknownWord: _languageTwo.text.trim(),
                                newKey: 0,
                                newCourseIndexReference: 0);
                            model.setWord(_initialWord, newWord);
                            if (_previousWasWordShow)
                              WordShowS.setWord(newWord);
                            // WordsS.updateReturn();
                            Navigator.pop(context);
                            if (_previousWasWordShow) Navigator.pop(context);
                            if (_context != null) {
                              Navigator.pop(_context);
                            }
                          } else {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String textToDisplay = ': $response';
                                return CupertinoAlertDialog(
                                  title: Text('Remove from task'),
                                  content: Padding(
                                    padding: EdgeInsets.only(
                                        top: 20, left: 5, right: 5, bottom: 10),
                                    child: Text(
                                        'If you save the changed word it will be removed from the following task$textToDisplay.'),
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            color:
                                                CupertinoColors.destructiveRed),
                                      ),
                                      onPressed: () {
                                        SmartWord newWord = SmartWord(
                                            newUnknownWord:
                                                _languageOne.text.trim(),
                                            newknownWord:
                                                _languageTwo.text.trim(),
                                            newKey: 0,//No actual key is neede, as the params of this task are copied in the original
                                            newCourseIndexReference: 0);
                                        model.setWord(
                                            _initialWord, newWord);
                                        if (_previousWasWordShow)
                                          WordShowS.setWord(newWord);
                                        // WordsS.updateReturn();
                                        Navigator.pop(context);
                                        if (_previousWasWordShow)
                                          Navigator.pop(context);
                                        if (_context != null) {
                                          Navigator.pop(_context);
                                        }
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
                          }
                        }
                      }
                    },
                  ),
                ),

                SettingUnits.createSettingInformationalUnit(
                    'If you save the changed word, all your progress of this word will be deleted.')
              ],
            ),
          ),
        );
      },
    );
  }
}
