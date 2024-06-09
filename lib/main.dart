import 'package:disk_space/disk_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rem_bra/Managers/dataManager.dart';
import 'package:rem_bra/Settings/settings.dart';
import 'package:rem_bra/Stats/statistics.dart';
import 'package:rem_bra/Learn/learnHome.dart';
import 'package:rem_bra/startDisplay.dart';
import 'package:rxdart/rxdart.dart';
import 'Managers/languageManager.dart';
import 'appsate.dart';
import 'package:provider/provider.dart';
import 'package:rem_bra/Words/wordsOverview.dart';
import 'constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

//Add navigation to Training after App was opened, add set Training with notification time!

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  bool navigateToTask = false;
  String paramsForNavigation = '';

//Request later on after launch!
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String title, String body, String payload) async {
      navigateToTask = true;
      paramsForNavigation = payload;
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id, title: title, body: body, payload: payload));
    },
  );
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        navigateToTask = true;
        paramsForNavigation = payload;
      }
      selectNotificationSubject.add(payload);
    },
  );

  return runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(navigateToTask, paramsForNavigation),
    ),
  );
}

class MyApp extends StatelessWidget {
  bool _navigateToTask = false;
  String _paramsForNavigation = '';

  MyApp(this._navigateToTask, this._paramsForNavigation);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, model, child) {
      return CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'RemBra by Simone Domenici',
        theme: CupertinoThemeData(
          primaryColor: DataManager.actualAccentColor,
          barBackgroundColor: DataManager.actualBackgroundColor,
          // textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontStyle:FontStyle.normal, fontWeight: FontWeight.normal ))
        ),
        localizationsDelegates: [
          const DemoLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale(SupportedLanguages.englishUnicodeID, ''),
          const Locale(SupportedLanguages.italianUnicodeID, ''),
          const Locale(SupportedLanguages.germanUnicodeID, ''),
        ],
        home: Hw(
          showLearnAtStart: _navigateToTask,
          paramsForNavigation: _paramsForNavigation,
        ),
      );
    });
  }
}

class Hw extends StatefulWidget {
  bool _showLearnAtStart = false;
  String _paramsForNavigation = "";

  Hw({bool showLearnAtStart, String paramsForNavigation}) {
    _showLearnAtStart = showLearnAtStart;
    _paramsForNavigation = paramsForNavigation;
  }

  HwS createState() => HwS(_showLearnAtStart, _paramsForNavigation);
}

class HwS extends State<Hw> {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  bool _navigateToTask = false;
  String _paramsForNavigation = "";

  static CupertinoTabController _cupertinoTabController =
      CupertinoTabController();

  static navigateToHome() {
    _cupertinoTabController.index = 0;
  }

  static navigateToSettings() {
    _cupertinoTabController.index = 3;
  }

  HwS(this._navigateToTask, this._paramsForNavigation);

  @override
  void initState() {
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    super.initState();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen(
      (ReceivedNotification receivedNotification) async {
        await showDialog(
          context: this.context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: receivedNotification.title != null
                ? Text(receivedNotification.title)
                : null,
            content: receivedNotification.body != null
                ? Text(receivedNotification.body)
                : null,
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() {
                    _navigateToTask = true;
                  });
                },
              )
            ],
          ),
        );
      },
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        setState(() {
          _navigateToTask = true;
          _paramsForNavigation = payload;
        });
      },
    );
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  Future<bool> checkPlatformStateValid() async {
    double freeSpace = -1;
    double totalSpace = -1;

    while (freeSpace == -1) {
      try {
        freeSpace = await DiskSpace.getFreeDiskSpace;
      } on PlatformException {
        freeSpace = -1;
        await Future.delayed(Duration(milliseconds: 10));
      }
    }
    while (totalSpace == -1) {
      try {
        totalSpace = await DiskSpace.getTotalDiskSpace;
      } on PlatformException {
        totalSpace = -1;
        await Future.delayed(Duration(milliseconds: 10));
      }
    }

    // print('Memorycontrol:');
    // print(
    //     'Update Interval: ${FreeSpace.memorySpaceControllerIntervall.inMilliseconds}ms');
    // print('Minimal free space required: ${FreeSpace.minSpaceToRunApp}MB');
    // print("The free disk space is: $freeSpace");
    // print("The total disk space is: $totalSpace");

    if (freeSpace > FreeSpace.minSpaceToRunApp) return false;

    return true;
  }

  String errorMessage =
      'You run out of memory space. Free up some memory space to continue using RemBra.';

  _showLowMemoryAlertNotification() {
    if (context != null) {
      showCupertinoDialog(
          context: this.context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Memory problem'),
              content: Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 10),
                child: Text('$errorMessage'),
              ),
              // actions: <Widget>[
              //   CupertinoDialogAction(
              //     child: Text(
              //       'Ok',
              //       style: TextStyle(color: CupertinoColors.destructiveRed),
              //     ),
              //     onPressed:(){
              //       //
              //     }
              //   ),
              // ],
            );
          });
    }
  }

  bool _memoryCheckerStarted = false;

  ultraConstantMemoryLowChecker() async {
    if (!_memoryCheckerStarted) {
      _memoryCheckerStarted = true;
      while (true) {
        await Future.delayed(FreeSpace.memorySpaceControllerIntervall);
        if (await checkPlatformStateValid() == true) {
          _showLowMemoryAlertNotification();
          while (await checkPlatformStateValid() == true) {
            await Future.delayed(FreeSpace.memorySpaceControllerIntervall);
          }
          Navigator.pop(this.context);
        }
      }
    }
  }

  //Add Tab Navigation with History
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, model, child) {
        if (!_memoryCheckerStarted) ultraConstantMemoryLowChecker();

        print('main:');
        print('navigate: $_navigateToTask');

        print('This is the actual course Key: ${DataManager.actualCourseKey}');

        if (_navigateToTask) {
          int taskKey = int.parse(_paramsForNavigation.substring(
              0, _paramsForNavigation.indexOf('|')));
          int courseKey = int.parse(_paramsForNavigation
              .substring(_paramsForNavigation.indexOf('|') + 1));
          print('course key: $courseKey | task key: $taskKey');
          model.setAllNavigationPropertiesOfTask(
              _navigateToTask, courseKey, taskKey);
        }

        _navigateToTask = false;
        _paramsForNavigation = '';

        if (DataManager.navigateToTask) _cupertinoTabController.index = 1;

        //Sets locale languagecode if it was not setted before
        if (DataManager.languageUnicodeID == '')
          model.setLanguageUnicodeID(
              DemoLocalizations.of(context).locale.languageCode);

        return AppState.loaded
            ? CupertinoTabScaffold(
                controller: _cupertinoTabController,
                tabBar: CupertinoTabBar(
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.book),
                        activeIcon: Icon(
                          CupertinoIcons.book_solid,
                          color: DataManager.actualAccentColor,
                        ),
                        title: Text(
                          '${DemoLocalizations.of(context).wordsBottomIcon}',
                        ),
                        backgroundColor: DataManager.actualAccentColor),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.clock),
                        activeIcon: Icon(
                          CupertinoIcons.clock_solid,
                          color: DataManager.actualAccentColor,
                        ),
                        title: Text(
                          '${DemoLocalizations.of(context).learnBottomIcon}',
                        ),
                        backgroundColor: DataManager.actualAccentColor),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.bookmark),
                        activeIcon: Icon(
                          CupertinoIcons.bookmark_solid,
                          color: DataManager.actualAccentColor,
                        ),
                        title: Text(
                          '${DemoLocalizations.of(context).statisticsBottomIcon}',
                        ),
                        backgroundColor: DataManager.actualAccentColor),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.settings),
                        activeIcon: Icon(
                          CupertinoIcons.settings_solid,
                          color: DataManager.actualAccentColor,
                        ),
                        title: Text(
                          '${DemoLocalizations.of(context).settingsBottomIcon}',
                        ),
                        backgroundColor: DataManager.actualAccentColor),
                  ],
                ),

                //Make Silverlist https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/cupertino/cupertino_navigation_demo.dart
                //Middle the +
                //Make saved nicer
                tabBuilder: (BuildContext context, int index) {
                  switch (index) {
                    case 0:
                      return Words();
                    case 1:
                      return TrainStart();
                    case 2:
                      return Statistics();
                    case 3:
                      return Settings();
                  }
                },
              )
            : StartDisplay();
      },
    );
  }
}
