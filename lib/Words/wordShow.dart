import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Settings/settingunitsUltraPro.dart';
import 'package:rem_bra/Words/setWord.dart';
import 'package:rem_bra/Objects/wordElement.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class WordShow extends StatefulWidget {
  SmartWord _word;
  bool _secondStepToPreventInfiniteNavigation;
  WordShow(this._word, this._secondStepToPreventInfiniteNavigation)
      : assert(_word != null, _secondStepToPreventInfiniteNavigation != null);

  WordShowS createState() =>
      WordShowS(_word, _secondStepToPreventInfiniteNavigation);
}

class WordShowS extends State<WordShow> {
  static SmartWord _word;
  String _sucsessRateString = '-';
  double _sucsessRateNumber = 0;

  bool _firstEnterForProgressAnimation = true;

  bool _secondStepToPreventInfiniteNavigation;

  Padding _sspace = Padding(
    padding: EdgeInsets.only(top: 26),
  );
  Padding _bspace = Padding(
    padding: EdgeInsets.only(top: 40),
  );

  WordShowS(wordOne, secondStepToPreventInfiniteNavigation) {
    _word = wordOne;
    _secondStepToPreventInfiniteNavigation =
        secondStepToPreventInfiniteNavigation;
  }

  static setWord(SmartWord word) {
    if (word != null) _word = word;
  }

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        if (_word.tries != '-') {
          if (_word.strikes != '-') {
            int tries = int.parse(_word.tries);
            int strikes = int.parse(_word.strikes);
            _sucsessRateNumber = (10000 * strikes / tries).round() / 100;
            _sucsessRateString = '$_sucsessRateNumber';
            if (_sucsessRateString.endsWith('.0'))
              _sucsessRateString = _sucsessRateString.substring(
                  0, _sucsessRateString.length - 2);
            if (_sucsessRateString.endsWith('0') &&
                _sucsessRateString.contains('.'))
              _sucsessRateString = _sucsessRateString.substring(
                  0, _sucsessRateString.length - 1);
            _sucsessRateNumber /= 100;
            if (_firstEnterForProgressAnimation) _sucsessRateNumber = 0;
          } else
            _sucsessRateString = '0';
        }

        if (_firstEnterForProgressAnimation) {
          _firstEnterForProgressAnimation = false;
          _waitToAnimatePercent();
        }

           String previousPageTitle = DemoLocalizations.of(context).wordsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';

        return CupertinoPageScaffold(
          key: Key('SHOW WORD KEY 283643'),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle:  '$previousPageTitle',
            transitionBetweenRoutes: true,
            middle: Text(
              'Word details',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
            trailing: CupertinoButton(
              child: Text(
                'Set',
                style: TextStyle(color: DataManager.actualAccentColor),
              ),
              padding: EdgeInsets.all(10),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => SetWord(
                        _word, true, _secondStepToPreventInfiniteNavigation)));
              },
            ),
          ),
          child: Container(
            color: DataManager.actualBackgroundColor,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: <Widget>[
              
                 Text(
                      AppState.descriptionOne,
                      style: TextStyle(color: DataManager.actualTextColor),
                    
                  ),
                  Text(
                    _word.unknownWord,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: DataManager.actualTextColor),
                  ),
                  _sspace,
                  Text(
                    AppState.descriptionTwo,
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
                  Text(
                    _word.knownWord,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: DataManager.actualTextColor),
                  ),
                    _bspace,
                  Text(
                    'Strikes',
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
                  Text(
                    '${_word.strikes}',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: DataManager.actualTextColor),
                  ),
                _sspace,
                  Text(
                    'Tries',
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
                  Text(
                    '${_word.tries}',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: DataManager.actualTextColor),
                  ),
                   _sspace,
                  Text(
                    'Success',
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
                  Text(
                    _sucsessRateString != '-'
                        ? '$_sucsessRateString%'
                        : '$_sucsessRateString',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: DataManager.actualTextColor),
                  ),
                  Stack(
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
                          width: (MediaQuery.of(context).size.width - 40) *
                              _sucsessRateNumber,
                          color: DataManager.actualAccentColor,
                          duration: ProgressIndicatorParams.animationDuration,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _waitToAnimatePercent() async {
    await Future.delayed(Duration(milliseconds: 5));
    setState(() {});
  }
}
