import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Objects/wordElement.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';
import 'package:rem_bra/Words/wordShow.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

class AddWord extends StatefulWidget {
  _AddWordS createState() => _AddWordS();
}

class _AddWordS extends State<AddWord> {
  TextEditingController _languageOne = new TextEditingController();
  TextEditingController _languageTwo = new TextEditingController();
  bool _isTextOneRed = false;
  bool _isTextTwoRed = false;

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {

          String previousPageTitle = DemoLocalizations.of(context).wordsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';

        return CupertinoPageScaffold(
          key: Key('ADD WORD KEY 3030484'),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle:            '$previousPageTitle',
            middle: Text(
              'Add word',
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
                        //Prevent that Separator is putted in is not longer necessary
                        if (AppState.containsWord(
                            _languageOne.text.trim())) {
                          SmartWord _word =
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
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  WordShow(_word, false)));
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
                          bool performanceCheckerPro = false;
                          if (performanceCheckerPro) {
                            for (var i = 0; i < 1000; i++) {
                              model.addWord(SmartWord(
                                  newUnknownWord:
                                      _languageOne.text.trim() + '$i',
                                  newknownWord: _languageTwo.text.trim() + '$i',
                                  newKey: DataManager.nextSmartwordKey,
                                  newCourseIndexReference:
                                      DataManager.actualCourseKey));
                            }
                          } else
                            model.addWord(SmartWord(
                                newUnknownWord: _languageOne.text.trim(),
                                newknownWord: _languageTwo.text.trim(),
                                newKey: DataManager.nextSmartwordKey,
                                newCourseIndexReference:
                                    DataManager.actualCourseKey));
                          Navigator.pop(context);
                          //WordsS.updateReturn();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
