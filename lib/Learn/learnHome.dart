import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rem_bra/Learn/chooseTask.dart';
import 'package:rem_bra/Learn/learnSmart.dart';
import 'package:rem_bra/Learn/setTaskSpecifications.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Managers/languageManager.dart';
import 'package:rem_bra/Objects/taskElement.dart';
import 'package:rem_bra/appsate.dart';
import 'package:provider/provider.dart';

class TrainStart extends StatefulWidget {
  _TrainStartS createState() => _TrainStartS();
}

class _TrainStartS extends State<TrainStart> {
  ScrollController _controller = ScrollController();
  AppState _model = null;
  List<SmartTask> _trainingUnits = [];

  int _taskKeyWhereToNavigate = -1;
  bool _shouldNavigate = false;

  //Prevent anonymus word deleting!

  //Continue here: check what happens if all words in the training are deleted

  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        if (_model == null) _model = model;

        _trainingUnits = AppState.trainingElements;

        _taskKeyWhereToNavigate = DataManager.navigateToTaskKey;
        _shouldNavigate = DataManager.navigateToTask;

        DataManager.eraseBothNavigatePropeties();

        print('learn:');
        print('navigate: $_shouldNavigate');

        print('task name: $_taskKeyWhereToNavigate');

        print('trainingunits: $_trainingUnits');

        if (_shouldNavigate) navigateToTaskItem();

        return CupertinoPageScaffold(
          backgroundColor: DataManager.actualBackgroundColor,
          child: CupertinoScrollbar(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              slivers: <Widget>[
                // Continue here, try to implement SilverAppBar in iOS Style, done!
                CupertinoSliverNavigationBar(
                  heroTag: 'learn start 6332',
                  largeTitle: Text(
                    '${DemoLocalizations.of(context).learnBigTitle}',
                    style: TextStyle(color: DataManager.actualTextColor),
                  ),
                  trailing: CupertinoButton(
                    child: Text(
                      '+',
                      style: TextStyle(color: DataManager.actualAccentColor),
                    ),
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => ChooseTask()));
                    },
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

//Continue here with color adaption!
  List<Widget> _buildWordsOverview() {
    List<Widget> ret = [];
    _trainingUnits.sort((a, b) {
      int first = a.getIndexInOfTaskState(DateTime.now());
      int second = b.getIndexInOfTaskState(DateTime.now());
      if (first != second)
        return first - second;
      else
        return a.name.compareTo(b.name);
    });
    for (int i = 0; i < _trainingUnits.length; i++)
      ret.add(trainingStartingItem(
          _trainingUnits[i], _trainingUnits[i].actualColor));

    if (_trainingUnits.length == 0)
      ret.add(
        Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'No task available',
              style: TextStyle(color: CupertinoColors.inactiveGray),
            ),
          ),
        ),
      );
    return ret;
  }

  navigateToTaskItem() async {
    if (_taskKeyWhereToNavigate != null &&
        _taskKeyWhereToNavigate >= 0 &&
        AppState.isTaskKeySetted(_taskKeyWhereToNavigate)) {
      await Future.delayed(Duration(milliseconds: 30));
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => SmartTrainer(_taskKeyWhereToNavigate, false)));
    }
  }

  Widget trainingStartingItem(SmartTask element, Color backgroundColor) {
    print('Given::::: ${element.toString()}');
    if (!_model.isTaskStillValidByKey(element.key))
      return Padding(padding: EdgeInsets.only(top: 0));

//Continue here, save time when training was practiced last time and disable it or dont´save state after first practice!
    int taskStateIndex = element.getIndexInOfTaskState(DateTime.now());
    return Padding(
      padding: EdgeInsets.all(10),
      child: CupertinoContextMenu(
        key: Key('${element.name}'),
        actions: <Widget>[
          CupertinoContextMenuAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(taskStateIndex == 0 ? 'Learn' : 'Train'),
                Icon(
                  CupertinoIcons.clock,
                  color: CupertinoColors.black,
                ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => SmartTrainer(element.key, true)));
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
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => SetTaskSpecifications(element, true)));
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
              Navigator.pop(context);
              _model.delTask(element);
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
              _model.delTask(element);
            },
          ),
          key: Key('${element.name}'),
          actions: <Widget>[
            IconSlideAction(
              onTap: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) =>
                        SetTaskSpecifications(element, false)));
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
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text('Delete'),
                      content: Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: 5, right: 5, bottom: 10),
                        child: Text('Do you really want to delete this task?'),
                      ),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                                color: CupertinoColors.destructiveRed),
                          ),
                          onPressed: () {
                            _model.delTask(element);
                            Navigator.pop(context);
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(
                            'Cancel',
                            style:
                                TextStyle(color: DataManager.actualAccentColor),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
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
              taskStateIndex = element.getIndexInOfTaskState(DateTime.now());
              if (taskStateIndex != 0) {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //Notifcate at review only if previously notification where allowed in training-> no permission gives no problems then!
                      return CupertinoAlertDialog(
                        title: Text(taskStateIndex == 2
                            ? 'Already learned'
                            : 'Not available'),
                        content: Padding(
                          padding: EdgeInsets.only(
                              top: 20, left: 5, right: 5, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              Text((taskStateIndex == 2
                                      ? 'You have already used this task in learning mode today.'
                                      : (taskStateIndex == 3
                                          ? ('Your next review is on the ${element.futureReviewDate.day < 10 ? '0${element.futureReviewDate.day}' : element.futureReviewDate.day}/${element.futureReviewDate.month}/${element.futureReviewDate.year}' +
                                              (element.isNotificationActive
                                                  ? ' at ${element.futureReviewDate.hour}:${element.futureReviewDate.minute < 10 ? '0${element.futureReviewDate.minute}' : element.futureReviewDate.minute}.'
                                                  : '.'))
                                          : 'You have setted your learning time for ${element.notificationTime.hour}:${element.notificationTime.minute < 10 ? '0${element.notificationTime.minute}' : element.notificationTime.minute}.')) +
                                  ' You can still acsess it in training mode, but note that ' +
                                  'no progress will be saved.'),
                              Padding(padding: EdgeInsets.only(top: 20)),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text(
                              'Acsess',
                              style: TextStyle(
                                  color: CupertinoColors.destructiveRed),
                            ),
                            onPressed: () {
                              Navigator.pop(context);

                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) =>
                                      SmartTrainer(element.key, false)));
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
              } else
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => SmartTrainer(element.key, false)));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: backgroundColor,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${element.name}',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.clip,
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          taskStateIndex == 3
                              ? CupertinoIcons.refresh_circled
                              : (taskStateIndex == 1
                                  ? CupertinoIcons.news
                                  : (taskStateIndex == 0
                                      ? CupertinoIcons.clock
                                      : CupertinoIcons
                                          .check_mark_circled_solid)),
                          size: 30,
                          color: CupertinoColors.black,
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
    );
  }
}
