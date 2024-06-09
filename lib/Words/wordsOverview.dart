import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Objects/wordElement.dart';
import 'package:rem_bra/Settings/courses%20settings.dart';
import 'package:rem_bra/Words/addWord.dart';
import 'package:rem_bra/Words/setWord.dart';
import 'package:rem_bra/Words/wordShow.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';

class Words extends StatefulWidget {
  WordsS createState() => WordsS();
}

class WordsS extends State<Words> {
  static ScrollController _controller = ScrollController();
  TextEditingController _textEditingController = TextEditingController();
  AppState _model = null;
  int _wordsForDisplayLength = -1;

  bool _wasSearchPressed = false;
  String _searchText = '';
  Widget _sortingSymbol = Container();
  //Make the silver iOS 12 work!!! Done
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        if (_model == null) _model = model;
        if (AppState.reactiveSearchAtReturn)
          AppState.reactiveSearchAtReturn = false;

        _wordsForDisplayLength = AppState.wordsForDisplayLenght;
        switch (DataManager.displayModeIndex) {
          case 0:
            {
              _sortingSymbol = Text('↓↑');
              break;
            }
          case 1:
            {
              _sortingSymbol = Text('↑↓');
              break;
            }
          case 2:
            {
              _sortingSymbol = RotatedBox(
                child: Text('↑'),
                quarterTurns: 1,
              );
              break;
            }
          case 3:
            {
              _sortingSymbol = RotatedBox(
                child: Text('↓'),
                quarterTurns: 1,
              );
              break;
            }
          case 4:
            {
              _sortingSymbol = Text('↑↑');

              break;
            }
          case 5:
            {
              _sortingSymbol = Text('↓↓');
              break;
            }
        }

        String previousPageTitle = DemoLocalizations.of(context).wordsBigTitle;
        if (previousPageTitle.length > 12)
          previousPageTitle = previousPageTitle.substring(0, 10) + '..';

        return CupertinoPageScaffold(
          backgroundColor: DataManager.actualBackgroundColor,
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              slivers: <Widget>[
                // Continue here, try to implement SilverAppBar in iOS Style
                CupertinoSliverNavigationBar(
                  heroTag: 'words 3423',
                  largeTitle: GestureDetector(
                    child: Text(
                      '$previousPageTitle',
                      style: TextStyle(color: DataManager.actualTextColor),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: '${AppState.allWordsSimoneDomenici}'));
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text('Golden message'),
                            content: Padding(
                              padding: EdgeInsets.only(
                                  top: 20, left: 5, right: 5, bottom: 10),
                              child: Text(
                                  'Dear Mr. Domenici,\nyour complete words have just been copied in the clipboard.\nHave a nice day, and never ever give up!'),
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
                    },
                    onLongPress: () {
                      HwS.navigateToSettings();
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => CoursesSettings()));
                    },
                  ),
                  leading: CupertinoButton(
                      child: Icon(CupertinoIcons.search),
                      padding: EdgeInsets.all(10),
                      onPressed: () async {
                        _controller.animateTo(0,
                            duration: Duration(milliseconds: 300),
                            curve: ElasticInOutCurve());

                        setState(() {
                          _wasSearchPressed = !_wasSearchPressed;
                          if (!_wasSearchPressed)
                            _textEditingController.text = '';
                          _searchText = '';
                        });
                        //Needed to ensure proper APP work!
                        await new Future.delayed(
                            const Duration(milliseconds: 300));
                        _stillDisplaySearch(model);
                        //Navigator.of(context).push(CupertinoPageRoute(
                        //  builder: (context) => AddWord()));
                      }),
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CupertinoButton(
                          child: Text('+'),
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => AddWord()));
                          }),
                      CupertinoButton(
                          child: _sortingSymbol,
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            if (DataManager.isAutomaticSortingChange)
                              model.setNextDisplayModeIndex();
                            else
                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .height /
                                        3,
                                    child: Stack(
                                      children: <Widget>[
                                        CupertinoPicker(
                                          magnification: 0.8,
                                          itemExtent: 40,
                                          looping: false,
                                          children: DisplayModes
                                              .displayModeDescriptions
                                              .map((f) => Text(
                                                    '$f',
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  ))
                                              .toList(),
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: DataManager
                                                      .displayModeIndex),
                                          onSelectedItemChanged: (int i) {
                                            model.setDisplayModeIndex(i);
                                          },
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: CupertinoButton(
                                            child: Text(
                                              'Ok',
                                              style: TextStyle(
                                                color: DataManager
                                                    .actualAccentColor,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                          }),
                    ],
                  ),
                ),
                // CupertinoSliverRefreshControl(),

                // SliverPersistentHeader()
                //Try with silverlist!!!!
                // SliverList(delegate: SliverChildDelegate(),)

                if (_wasSearchPressed)
                  SliverToBoxAdapter(
                    child: Container(
                      color: DataManager.actualBackgroundColor,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: ClipRRect(
                          child: Container(
                            color: CupertinoColors.extraLightBackgroundGray,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 5, left: 5, top: 10, bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: CupertinoTextField(
                                      style: TextStyle(
                                          color: DataManager.actualTextColor),
                                      decoration: BoxDecoration(
                                          color:
                                              DataManager.actualBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      cursorColor:
                                          DataManager.actualAccentColor,
                                      controller: _textEditingController,
                                      maxLines: 1,
                                      maxLength: 20,
                                      prefix: Icon(
                                        CupertinoIcons.search,
                                        color: DataManager.actualTextColor
                                            .withOpacity(0.5),
                                      ),
                                      prefixMode: OverlayVisibilityMode.always,
                                      maxLengthEnforced: true,
                                      placeholder: 'Search ', //🔍
                                      placeholderStyle: TextStyle(
                                          color: DataManager.actualTextColor
                                              .withOpacity(0.5)),
                                      clearButtonMode:
                                          OverlayVisibilityMode.editing,
                                      onChanged: (String value) {
                                        setState(() {
                                          _searchText = value.trim();
                                        });
                                        //Needed to ensure proper AppWork!
                                        _controller.jumpTo(1);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'my id', 'my name', 'my description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Compliments!',
        'Mister Domenici, you definetly made it!', platformChannelSpecifics,
        payload: 'item gold');
  }

  List<Widget> _buildWordsOverview() {
    if (_wordsForDisplayLength == 0) {
      return [
        Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'No words available',
              style: TextStyle(
                color: CupertinoColors.inactiveGray,
              ),
            ),
          ),
        ),
      ];
    }
    return [
      Container(
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          itemCount: _wordsForDisplayLength,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (AppState.getWordAtIndexEfficentPro(index)
                .unknownWord
                .contains(_searchText.trim()))
              return wordUnitDisplay(AppState.getWordAtIndexEfficentPro(index));
            else
              return Padding(padding: EdgeInsets.only(top: 0));
          },
        ),
      )
    ];
  }

  _stillDisplaySearch(AppState AppState) async {
    bool valid = true;
    if (_controller.hasClients) valid = _controller.position.pixels < 100;
    while (valid || _textEditingController.text.isNotEmpty) {
      await new Future.delayed(const Duration(milliseconds: 50));
      if (_controller.hasClients) valid = _controller.position.pixels < 100;
    }
    //double initialX = controller.position.pixels;
    setState(() {
      _wasSearchPressed = false;
    });
    // controller.jumpTo(initialX-50);
  }

  //Needed to ensure proper AppWork!
  // static updateReturn() {
  // _controller.jumpTo(1);
  //}

  Widget wordUnitDisplay(SmartWord _word) {
// "in line 340 add this if statement if (mounted)
// we are just guarding the setState as below
// if (mounted) { setState(() { _childHidden = false; }); }
// this solved the issue for me" for delete in Cunpertinocontextmenuaction
    return Padding(
      padding: EdgeInsets.all(10),
      child: CupertinoContextMenu(
        key: Key('${_word.unknownWord}+${_word.knownWord}e'),
        actions: <Widget>[
          CupertinoContextMenuAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'View',
                  style: TextStyle(color: CupertinoColors.black),
                ),
                Icon(
                  CupertinoIcons.eye_solid,
                  color: CupertinoColors.black,
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => WordShow(_word, false)));
            },
          ),
          CupertinoContextMenuAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Set'),
                Icon(
                  CupertinoIcons.settings_solid,
                  color: CupertinoColors.black,
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => SetWord(
                    _word,
                    false,
                    false,
                    contextToClose: context,
                  ),
                ),
              );
            },
          ),
          CupertinoContextMenuAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Delete',
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                ),
                Icon(
                  CupertinoIcons.delete,
                  color: CupertinoColors.destructiveRed,
                ),
              ],
            ),
            onPressed: () {
              _model.delWord(_word);
              Navigator.pop(context);
            },
          ),
        ],
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          dismissal: SlidableDismissal(
            dismissThresholds: <SlideActionType, double>{
              SlideActionType.primary: 1.0
            },
            child: SlidableDrawerDismissal(),
            onDismissed: (action) {
              //Continue here
              _model.delWord(_word);
            },
          ),
          key: Key('${_word.unknownWord}+${_word.knownWord}'),
          actions: <Widget>[
            IconSlideAction(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => SetWord(_word, false, false),
                  ),
                );
              },
              iconWidget: Container(
                color: DataManager.actualBackgroundColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: DataManager.actualAccentColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Set',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                          Icon(
                            CupertinoIcons.settings_solid,
                            color: CupertinoColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              onTap: () {
                String response =
                    AppState.taskWhereWordIsUsed(_word.taskIndexReference);
                if (response.isEmpty) {
                  showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('Delete'),
                          content: Padding(
                            padding: EdgeInsets.only(
                                top: 20, left: 5, right: 5, bottom: 10),
                            child:
                                Text('Do you really want to delete this word?'),
                          ),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: CupertinoColors.destructiveRed),
                              ),
                              onPressed: () {
                                _model.delWord(_word);
                                Navigator.pop(context);
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
                      });
                } else {
                  showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String textToDisplay = response;

                        return CupertinoAlertDialog(
                          title: Text('Delete word'),
                          content: Padding(
                            padding: EdgeInsets.only(
                                top: 20, left: 5, right: 5, bottom: 10),
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'This word is currently used in the following task: ',
                                style: TextStyle(color: CupertinoColors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '$textToDisplay',
                                      style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          '.\nDo you really want to delete this word?',
                                      style: TextStyle(
                                          color: CupertinoColors.black))
                                ],
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: CupertinoColors.destructiveRed),
                              ),
                              onPressed: () {
                                _model.delWord(_word);
                                Navigator.pop(context);
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
                      });
                }
              },
              iconWidget: Container(
                color: DataManager.actualBackgroundColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: CupertinoColors.destructiveRed,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Delete',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                          Icon(
                            CupertinoIcons.delete,
                            color: CupertinoColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => WordShow(_word, false)));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: _word.learned
                    ? DataManager.actualAccentColor
                    : (DataManager.isDarkModeActive
                        ? CupertinoColors.inactiveGray
                        : CupertinoColors.lightBackgroundGray),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: DataManager.isDarkModeActive
                          ? CupertinoColors.inactiveGray
                          : CupertinoColors.lightBackgroundGray,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text('${_word.unknownWord}',
                                  overflow: TextOverflow.clip),
                            ),
                            Container(
                              width: 1,
                              height: 20,
                              color: CupertinoColors.black,
                            ),
                            Expanded(
                              child: Text(
                                '${_word.knownWord}',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
