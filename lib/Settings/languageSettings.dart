import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Settings/addCourse.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class LanguageSettings extends StatefulWidget {
  _LanguageSettingsS createState() => _LanguageSettingsS();
}

class _LanguageSettingsS extends State<LanguageSettings> {
  AppState _model = null;

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (contextExtern, model, child) {
        if (_model == null) _model = model;

        List<String> _languageDescriptions =
            SupportedLanguages.languageDescriptions;
        List<String> _languageUnicodeID = SupportedLanguages.languageUnicodeIDs;

        List<Widget> languagesDisplay = [];

        for (int i = 0; i < _languageDescriptions.length; i++) {
          languagesDisplay.add(_createSettingUnit(_languageDescriptions[i], () {
            model.setLanguageUnicodeID(_languageUnicodeID[i]);
          }, i == 0, i == (_languageDescriptions.length - 1),
              _languageUnicodeID[i] == DataManager.languageUnicodeID));
        }

        String previousPageTitle =
            DemoLocalizations.of(context).settingsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';

        return CupertinoPageScaffold(
          backgroundColor: DataManager.actualBackgroundColor,
          key: Key('LANGUAGE SETTING 23482374'),
          navigationBar: CupertinoNavigationBar(
            middle: Text(
              'Language',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
            previousPageTitle: '$previousPageTitle',
          ),
          child: Container(
            color: DataManager.isDarkModeActive
                ? DataManager.actualBackgroundColor
                : CupertinoColors.extraLightBackgroundGray,
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: ListView(children: languagesDisplay),
            ),
          ),
        );
      },
    );
  }

  Widget _createSettingUnit(
      String description, onPressed(), bool first, bool last, bool selected) {
    Widget up = Padding(padding: EdgeInsets.only(top: 0));
    if (first) {
      up = SettingUnits.separtionLineWidget;
    }
    Widget down = SettingUnits.separtionLineWidgetSmall(context);
    if (last) {
      down = SettingUnits.separtionLineWidget;
    }

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: DataManager.actualBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            up,
            Padding(
              padding: EdgeInsets.only(right: 10, left: 5, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  selected
                      ? SizedBox(
                          width: 25,
                          height: 25,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                  color: DataManager.actualAccentColor,
                                  child: Padding(padding: EdgeInsets.all(25))),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 25,
                          height: 25,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Center(),
                            ),
                          ),
                        ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Container(
                    child: Text(
                      '${description}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: DataManager.actualTextColor),
                    ),
                  ),
                ],
              ),
            ),
            down,
          ],
        ),
      ),
    );
  }
}
