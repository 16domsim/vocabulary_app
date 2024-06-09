import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/generalTaskManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class Statistics extends StatefulWidget {
  _StatisticsS createState() => _StatisticsS();
}

class _StatisticsS extends State<Statistics> {
  ScrollController _controller = ScrollController();
  String _sucsessRateString = "-";
  double _sucsessRateNumber = 0;
  AppState _model = null;
  bool _navigationExperience = false;
  bool _firstEnterForProgressAnimation = true;

  Padding _space = Padding(padding: EdgeInsets.only(top: 10));

  //Prevent anonymus word deleting!

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        if (_model == null) _model = model;
        _navigationExperience = DataManager.navigationExperienceStatistics;

        if (AppState.totalTries > 0) {
          _sucsessRateNumber =
              (10000 * AppState.totalStrikes / AppState.totalTries).round() /
                  100;
          _sucsessRateString = '$_sucsessRateNumber';
          if (_sucsessRateString.endsWith('.0'))
            _sucsessRateString =
                _sucsessRateString.substring(0, _sucsessRateString.length - 2);
          if (_sucsessRateString.endsWith('0') &&
              _sucsessRateString.contains('.'))
            _sucsessRateString =
                _sucsessRateString.substring(0, _sucsessRateString.length - 1);
          _sucsessRateNumber /= 100;
          if (_firstEnterForProgressAnimation) _sucsessRateNumber = 0;
        } else {
          _sucsessRateString = "-";
          _sucsessRateNumber = 0;
        }

        if (_firstEnterForProgressAnimation) {
          _firstEnterForProgressAnimation = false;
          _waitToAnimatePercent();
        }

        return CupertinoPageScaffold(
          backgroundColor: DataManager.actualBackgroundColor,
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              slivers: <Widget>[
                // Continue here, try to implement SilverAppBar in iOS Style, done!
                CupertinoSliverNavigationBar(
                  heroTag: 'statistics 3425',
                  largeTitle: Text(
                    '${DemoLocalizations.of(context).statisticsBigTitle}',
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
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10, top: 10),
        child: GestureDetector(
          onTap: () {
            if (_navigationExperience) {
              _model.setHideLearnedWords(false);
              _model.setisHideNotLernedWords(false);
              GeneralTaskManager.navigateToHome();
            }
          },
          child: Text(
            'Total words ',
            style: TextStyle(color: DataManager.actualTextColor),
          ),
        ),
      ),
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: GestureDetector(
          onTap: () {
            if (_navigationExperience) {
              _model.setHideLearnedWords(false);
              _model.setisHideNotLernedWords(false);
              GeneralTaskManager.navigateToHome();
            }
          },
          child: Text(
            '${AppState.totalWords}',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: DataManager.actualTextColor),
          ),
        ),
      ),
    );
    ret.add(
      _space,
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: GestureDetector(
          onTap: () {
            if (_navigationExperience) {
              _model.setHideLearnedWords(false);
              _model.setisHideNotLernedWords(true);
              GeneralTaskManager.navigateToHome();
            }
          },
          child: Text(
            'Learned words ',
            style: TextStyle(color: DataManager.actualTextColor),
          ),
        ),
      ),
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: GestureDetector(
          onTap: () {
            if (_navigationExperience) {
              _model.setHideLearnedWords(false);
              _model.setisHideNotLernedWords(true);
              GeneralTaskManager.navigateToHome();
            }
          },
          child: Text(
            '${AppState.totalWordsLearned}',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: DataManager.actualTextColor),
          ),
        ),
      ),
    );
    ret.add(
      _space,
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text(
          'Total strikes ',
          style: TextStyle(color: DataManager.actualTextColor),
        ),
      ),
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text(
          '${AppState.totalStrikes}',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: DataManager.actualTextColor),
        ),
      ),
    );
    ret.add(
      _space,
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text(
          'Total tries ',
          style: TextStyle(color: DataManager.actualTextColor),
        ),
      ),
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text(
          '${AppState.totalTries}',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: DataManager.actualTextColor),
        ),
      ),
    );
    ret.add(
      _space,
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text(
          'Success quote ',
          style: TextStyle(color: DataManager.actualTextColor),
        ),
      ),
    );
    print('Success rate $_sucsessRateString');
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text(
          _sucsessRateString != '-'
              ? '$_sucsessRateString%'
              : '$_sucsessRateString',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: DataManager.actualTextColor),
        ),
      ),
    );
    ret.add(
      Padding(
        padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 12,
                      color: ProgressIndicatorParams.backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AnimatedContainer(
                height: 12,
                width: (MediaQuery.of(context).size.width - 20) *
                    _sucsessRateNumber,
                color: DataManager.actualAccentColor,
                duration: ProgressIndicatorParams.animationDuration,
              ),
            ),
          ],
        ),
      ),
    );
    return ret;
  }

  _waitToAnimatePercent() async {
    await Future.delayed(Duration(milliseconds: 5));
    setState(() {});
  }
}
