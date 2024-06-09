import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';

import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

class WordsOvervievSetting extends StatefulWidget {
  _WordsOvervievSettingS createState() => _WordsOvervievSettingS();
}

class _WordsOvervievSettingS extends State<WordsOvervievSetting> {
  bool _hideWordsIfLearned = false;
  bool _hideWordsNotLearned = false;
  bool _autoSortingchange = false;

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (contextExtern, model, child) {
        _hideWordsIfLearned = DataManager.isHideLearnedWords;
        _hideWordsNotLearned = DataManager.isHideNotLernedWords;
        _autoSortingchange = DataManager.isAutomaticSortingChange;

            String previousPageTitle =
            DemoLocalizations.of(context).settingsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';
        
        return CupertinoPageScaffold(
          key: Key('WORD OVERVIEW SETTING 8472384'),
          navigationBar: CupertinoNavigationBar(
            middle:
                Text('Words', style: TextStyle(color: DataManager.actualTextColor)),
            previousPageTitle:              '$previousPageTitle',
          ),
          child: Container(
            color: DataManager.isDarkModeActive
                ? DataManager.actualBackgroundColor
                : CupertinoColors.extraLightBackgroundGray,
            child: ListView(
              children: <Widget>[
                SettingUnits.createSettingUnitSmallSpacer(),
                SettingUnits.createSettingUnitSwitch(
                    'Hide learned words', _hideWordsIfLearned, (bool newValue) {
                  setState(() {
                    _hideWordsIfLearned = newValue;
                    if (_hideWordsIfLearned && _hideWordsNotLearned) {
                      _hideWordsNotLearned = false;
                      model.setisHideNotLernedWords(_hideWordsNotLearned);
                    }
                    model.setHideLearnedWords(newValue);
                  });
                }, true, false, DataManager.actualAccentColor, DataManager.actualTextColor,
                    DataManager.actualBackgroundColor, context),
                SettingUnits.createSettingUnitSwitch(
                    'Hide words in learning', _hideWordsNotLearned,
                    (bool newValue) {
                  setState(() {
                    _hideWordsNotLearned = newValue;
                    if (_hideWordsNotLearned && _hideWordsIfLearned) {
                      _hideWordsIfLearned = false;
                      model.setHideLearnedWords(_hideWordsIfLearned);
                    }
                    model.setisHideNotLernedWords(newValue);
                  });
                }, false, true, DataManager.actualAccentColor, DataManager.actualTextColor,
                    DataManager.actualBackgroundColor, context),
                SettingUnits.createSettingUnitBigSpacer(),
                SettingUnits.createSettingUnitSwitch(
                    'Auto sorting change', _autoSortingchange, (bool newValue) {
                  setState(() {
                    _autoSortingchange = newValue;
                    model.setIsAutomaticSortingChange(newValue);
                  });
                }, true, true, DataManager.actualAccentColor, DataManager.actualTextColor,
                    DataManager.actualBackgroundColor, context),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    'Sorting mode changes to the next one at every tap.',
                    style: TextStyle(
                        fontSize: 12, color: CupertinoColors.inactiveGray),
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
