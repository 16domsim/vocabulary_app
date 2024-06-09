import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';

import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ColorSetting extends StatefulWidget {
  _ColorSettingS createState() => _ColorSettingS();
}

class _ColorSettingS extends State<ColorSetting> {
  bool _isDarkModeActive = false;
  double _darkness = 0;

  
  Widget build(BuildContext context) {
       String previousPageTitle =
            DemoLocalizations.of(context).settingsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';

    return Consumer<AppState>(
      builder: (contextExtern, model, child) {
        _isDarkModeActive = DataManager.isDarkModeActive;
        _darkness = DarknessNumbers.maxDarknessNumber -
            DataManager.darknessNumber.toDouble();
        return CupertinoPageScaffold(
          backgroundColor: DataManager.actualBackgroundColor,
          key: Key('COLOR SETTINGS 73342432'),
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              'Color',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
            previousPageTitle:
                '$previousPageTitle',
          ),
          child: Container(
            color: DataManager.isDarkModeActive
                ? DataManager.actualBackgroundColor
                : CupertinoColors.extraLightBackgroundGray,
            child: ListView(
              children: <Widget>[
                SettingUnits.createSettingUnitSmallSpacer(),
                SettingUnits.createSettingUnitPopUpChoice(
                    'Accent color', DataManager.actualAccentColorName,
                    (int newIndex) {
                  model.setAccentColorIndex(newIndex);
                },
                    DataManager.allAccentColorNames,
                    DataManager.accentColorIndex,
                    true,
                    true,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                SettingUnits.createSettingUnitBigSpacer(),
                SettingUnits.createSettingUnitSwitch(
                    'Dark mode', _isDarkModeActive, (bool newValue) {
                  setState(() {
                    _isDarkModeActive = newValue;
                    model.setDarkMode(newValue);
                  });
                },
                    true,
                    !_isDarkModeActive,
                    DataManager.actualAccentColor,
                    DataManager.actualTextColor,
                    DataManager.actualBackgroundColor,
                    context),
                if (_isDarkModeActive)
                  SettingUnits.createSettingSliderUnit(
                      "Darkness",
                      _darkness,
                      DarknessNumbers.minDarknessNumber.toDouble(),
                      DarknessNumbers.maxDarknessNumber.toDouble(),
                      (double newValue) {
                    setState(() {
                      _darkness = DarknessNumbers.maxDarknessNumber -
                          newValue.toInt().toDouble();
                      model.setDarknessNumber(_darkness.toInt());
                    });
                  },
                      false,
                      true,
                      DataManager.actualAccentColor,
                      DataManager.actualTextColor,
                      DataManager.actualBackgroundColor,
                      context),
              ],
            ),
          ),
        );
      },
    );
  }
}
