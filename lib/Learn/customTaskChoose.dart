import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Objects/wordElement.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

import 'addTaskSpecifications.dart';

class CustomTask extends StatefulWidget {
  _CustomTaskS createState() => _CustomTaskS();
}

class _CustomTaskS extends State<CustomTask> {
  int _totalWords = 0;

  int _wordsDisplayLength = 0;

  int _selectedWords = 0;

  static final int minInitialWordamount = 5;

  static final int maxWordAmount = 50;

  static Color _colorForCheckMarkOfSingleWord;

  static Color _colorForTextOfSingleWord;

  List<bool> _wordsThatAreChecked = [];

  String _searchText = '';

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        if (_wordsThatAreChecked.isEmpty) {
          AppState.initializeCustomTaskMode();
          _totalWords = AppState.wordsForDisplayLenghtCustomTask;

          for (int i = 0; i < _totalWords; i++) _wordsThatAreChecked.add(false);
          _colorForCheckMarkOfSingleWord = DataManager.actualAccentColor;
          _colorForTextOfSingleWord = DataManager.actualTextColor;
        }

        _wordsDisplayLength = AppState.wordsForDisplayLenghtCustomTask + 3;

        _selectedWords = _wordsThatAreChecked.where((b) {
          return b;
        }).length;

        String textToDisplayInMenu = '';

        if (_selectedWords < minInitialWordamount)
          textToDisplayInMenu = '$_selectedWords/$minInitialWordamount';
        else
          textToDisplayInMenu = '$_selectedWords/$maxWordAmount';

        int totalOfCurrentWordsDisplayed = 0;

        return CupertinoPageScaffold(
          backgroundColor: DataManager.actualBackgroundColor,
          key: Key('CUSTOM TASK KEY 3212312'),
          navigationBar: CupertinoNavigationBar(
            previousPageTitle: 'choose task',
            transitionBetweenRoutes: true,
            middle: Text(
              'custom task',
              style: TextStyle(color: DataManager.actualTextColor),
            ),
          ),
          child: SafeArea(
            child: _totalWords < minInitialWordamount
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Add some words to add a custom task',
                        style: TextStyle(color: CupertinoColors.inactiveGray),
                      ),
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: _wordsDisplayLength,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0)
                            return Container(
                              color: DataManager.actualBackgroundColor,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: ClipRRect(
                                  child: Container(
                                    color: CupertinoColors
                                        .extraLightBackgroundGray,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 5,
                                          left: 5,
                                          top: 10,
                                          bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: CupertinoTextField(
                                              style: TextStyle(
                                                  color: DataManager.actualTextColor),
                                              decoration: BoxDecoration(
                                                  color: DataManager
                                                      .actualBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              cursorColor:
                                                  DataManager.actualAccentColor,
                                              prefix: Icon(
                                                CupertinoIcons.search,
                                                color: DataManager.actualTextColor
                                                    .withOpacity(0.5),
                                              ),
                                              prefixMode:
                                                  OverlayVisibilityMode.always,
                                              maxLines: 1,
                                              maxLength: 20,
                                              maxLengthEnforced: true,
                                              placeholder: 'Search ', //🔍
                                              placeholderStyle: TextStyle(
                                                  color: DataManager.actualTextColor
                                                      .withOpacity(0.5)),
                                              clearButtonMode:
                                                  OverlayVisibilityMode.editing,
                                              onChanged: (String value) {
                                                setState(() {
                                                  _searchText = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          if (index == 1)
                            return _wordsDisplayLength == 2
                                ? Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: Text(
                                        'No items available',
                                        style: TextStyle(
                                            color:
                                                CupertinoColors.inactiveGray),
                                      ),
                                    ),
                                  )
                                : Padding(padding: EdgeInsets.only(top: 0));
                          if (index == _wordsDisplayLength - 1) {
                            if (totalOfCurrentWordsDisplayed > 0)
                              return Padding(
                                padding: EdgeInsets.only(bottom: 100),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 0.3,
                                        color: CupertinoColors.inactiveGray,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            return Padding(
                              padding: EdgeInsets.only(top: 0),
                            );
                          }
                          if (AppState
                              .getWordAtIndexEfficentProCustomTask(index - 2)
                              .unknownWord
                              .contains(_searchText.trim())) {
                            totalOfCurrentWordsDisplayed++;
                            return SingleWordDisplay(
                              () {
                                setState(() {
                                  _wordsThatAreChecked[index - 2] =
                                      !_wordsThatAreChecked[index - 2];
                                });
                              },
                              AppState.getWordAtIndexEfficentProCustomTask(
                                  index - 2),
                              _wordsThatAreChecked[index - 2],
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.only(top: 0),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 10, left: 20, right: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: CupertinoColors.lightBackgroundGray,
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CupertinoButton.filled(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Text('Add'),
                                              disabledColor: DataManager
                                                  .actualAccentColor
                                                  .withOpacity(0.6),
                                              onPressed: _selectedWords <
                                                      minInitialWordamount
                                                  ? null
                                                  : () {
                                                      List<int> _keys = [];
                                                      for (int i = 0;
                                                          i <
                                                              _wordsThatAreChecked
                                                                  .length;
                                                          i++) {
                                                        if (_wordsThatAreChecked[
                                                            i])
                                                          _keys.add(AppState
                                                              .getWordAtIndexEfficentProCustomTask(
                                                                  i)
                                                              .key);
                                                      }
                                                      Navigator.of(context)
                                                          .push(
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              AddTaskSpecifications(
                                                                  _keys,
                                                                  DataManager
                                                                      .nextRandomColorIndex,
                                                                  true),
                                                        ),
                                                      );
                                                    }),
                                          Text('$textToDisplayInMenu'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget singleWordDisplay(dynamic onChanged, SmartWord smartWord) {}
}

class SingleWordDisplay extends StatefulWidget {
  dynamic _onChanged;
  SmartWord _word;
  bool _active;

  SingleWordDisplay(this._onChanged, this._word, this._active);

  _SingleWordDisplayS createState() =>
      _SingleWordDisplayS(_onChanged, _word, _active);
}

class _SingleWordDisplayS extends State<SingleWordDisplay> {
  dynamic _onChanged;
  bool _active = false;
  SmartWord _word;

  _SingleWordDisplayS(
    this._onChanged,
    this._word,
    this._active,
  );

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _onChanged();
        setState(() {
          _active = !_active;
        });
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 0.3,
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 5, top: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${_word.unknownWord}',
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: _CustomTaskS._colorForTextOfSingleWord),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: _CustomTaskS._colorForTextOfSingleWord,
                  ),
                  Expanded(
                    child: Text(
                      '${_word.knownWord}',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: _CustomTaskS._colorForTextOfSingleWord),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  Container(
                    width: 0.3,
                    height: 35,
                    color: CupertinoColors.inactiveGray,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(
                      _active
                          ? CupertinoIcons.check_mark_circled_solid
                          : CupertinoIcons.circle,
                      color: _CustomTaskS._colorForCheckMarkOfSingleWord,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
