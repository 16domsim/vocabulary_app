import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Settings/colorSetting.dart';
import 'package:rem_bra/Settings/courses%20settings.dart';
import 'package:rem_bra/Settings/languageSettings.dart';

import 'package:rem_bra/Settings/settingunitsUltraPro.dart';
import 'package:rem_bra/Settings/statisticsSettings.dart';
import 'package:rem_bra/Settings/wordsOverViewSettings.dart';

import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  _SettingsS createState() => _SettingsS();
}

class _SettingsS extends State<Settings> {
  ScrollController _controller = ScrollController();

  Padding _space = Padding(padding: EdgeInsets.only(top: 10));

  //Prevent anonymus word deleting!

  Widget build(BuildContext context) {
    //Continue here!
    return Consumer<AppState>(
      builder: (context, model, child) {
        return CupertinoPageScaffold(
          backgroundColor: DataManager.isDarkModeActive
              ? DataManager.actualBackgroundColor
              : CupertinoColors.extraLightBackgroundGray,
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              slivers: <Widget>[
                // Continue here, try to implement SilverAppBar in iOS Style, done!
                CupertinoSliverNavigationBar(
                  heroTag: 'settings 6271',
                  largeTitle: Text(
                    '${DemoLocalizations.of(context).settingsBigTitle}',
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
                ),
                // CupertinoSliverRefreshControl(),

                // SliverPersistentHeader()
                SliverList(
                  delegate: SliverChildListDelegate(_buildWordsOverview()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildWordsOverview() {
    List<Widget> ret = [];
    ret.add(
      SettingUnits.createSettingUnitSmallSpacer(),
    );
    ret.add(
      SettingUnits.createSettingNavigationExtraBigLeadingUnit(
          Container(
            color: DataManager.actualBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
                CupertinoIcons.collections_solid,
                color: CupertinoColors.activeBlue,
                size: 50,
              ),
            ),
          ),
          'My Courses',
          () => {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => CoursesSettings()))
              },
          true,
          true,
          DataManager.actualAccentColor,
          DataManager.actualTextColor,
          DataManager.actualBackgroundColor,
          context),
    );
    ret.add(
      SettingUnits.createSettingUnitBigSpacer(),
    );
    ret.add(
      SettingUnits.createSettingNavigationUnit(
          Container(
            color: DataManager.actualBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
                DataManager.isDarkModeActive
                    ? CupertinoIcons.pencil
                    : CupertinoIcons.pen,
                color: DataManager.actualAccentColor,
              ),
            ),
          ),
          'Color',
          () => {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => ColorSetting()))
              },
          true,
          true,
          DataManager.actualAccentColor,
          DataManager.actualTextColor,
          DataManager.actualBackgroundColor,
          context),
    );
    ret.add(
      SettingUnits.createSettingUnitBigSpacer(),
    );
     ret.add(
      SettingUnits.createSettingNavigationUnit(
          Container(
            color: DataManager.actualBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
               
                    CupertinoIcons.person_solid,
                color: DataManager.actualAccentColor,
              ),
            ),
          ),
          'Language',
          () => {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => LanguageSettings()))
              },
          true,
          true,
          DataManager.actualAccentColor,
          DataManager.actualTextColor,
          DataManager.actualBackgroundColor,
          context),
    );
    ret.add(
      SettingUnits.createSettingUnitBigSpacer(),
    );
    ret.add(
      SettingUnits.createSettingNavigationUnit(
          Container(
            color: DataManager.actualBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
                CupertinoIcons.book_solid,
                color: DataManager.actualAccentColor,
              ),
            ),
          ),
          'Words',
          () => {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => WordsOvervievSetting()))
              },
          true,
          false,
          DataManager.actualAccentColor,
          DataManager.actualTextColor,
          DataManager.actualBackgroundColor,
          context),
    );

    ret.add(
      SettingUnits.createSettingNavigationUnit(
          Container(
            color: DataManager.actualBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
                CupertinoIcons.bookmark_solid,
                color: DataManager.actualAccentColor,
              ),
            ),
          ),
          'Statistics',
          () => {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => StatisticsSetting()))
              },
          false,
          true,
          DataManager.actualAccentColor,
          DataManager.actualTextColor,
          DataManager.actualBackgroundColor,
          context),
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(bottom: 20),
      ),
    );

    return ret;
  }
}
