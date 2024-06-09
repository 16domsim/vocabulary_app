import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';

import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

class StatisticsSetting extends StatefulWidget {
  _StatisticsSettingS createState() => _StatisticsSettingS();
}

class _StatisticsSettingS extends State<StatisticsSetting> {
  bool _navigationExperience = false;

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (contextExtern, model, child) {
        _navigationExperience = DataManager.navigationExperienceStatistics;
         String previousPageTitle =
            DemoLocalizations.of(context).settingsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';
        return CupertinoPageScaffold(
          key: Key('STATISTICS SETTING 7237237'),
          navigationBar: CupertinoNavigationBar(
            middle: Text('Statistics',
                style: TextStyle(color: DataManager.actualTextColor)),
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
                    'Navigation experience', _navigationExperience,
                    (bool newValue) {
                  setState(() {
                    _navigationExperience = newValue;
                    model.setnavigationExperienceStatistics(newValue);
                  });
                }, true, true, DataManager.actualAccentColor, DataManager.actualTextColor,
                    DataManager.actualBackgroundColor, context),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    'Words settings will be changed automatically if active.',
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
