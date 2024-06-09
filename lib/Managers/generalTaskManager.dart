import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class GeneralTaskManager {
  static navigateToHome() {
    HwS.navigateToHome();
    print('Navigated to home');
  }

//Control that task gets loaded correctly in relevance to the course!!!
  static Future<void> showTaskWeeklyAtDayAndTime(
      String textToDisplay,
      Time displaytime,
      Day displayDay,
      int key,
      int keyOfTraingForPayload,
      int keyOfCourseForPayload) async {
    //The error was solved! Sometimes the tinest things make the biggest errors!
    print(
        'Notification setted: text=$textToDisplay key=$key payload=$keyOfTraingForPayload|$keyOfCourseForPayload displayTime:${displaytime.hour}:${displaytime.minute} DisplayDay:${displayDay.value}}');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        key,
        'Time to learn!',
        '$textToDisplay',
        displayDay,
        displaytime,
        platformChannelSpecifics,
        payload: '$keyOfTraingForPayload|$keyOfCourseForPayload');
  }

  static Future<void> showReviewNextWeeks(
      String textToDisplay,
      Time displaytime,
      int key,
      int keyOfTraingForPayload,
      int weeksAmountToShow,
      int keyOfCourseForPayload) async {
    //The error was solved! Sometimes the tinest things make the biggest errors!

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    DateTime h = DateTime.now();
    DateTime displayDate =
        DateTime(h.year, h.month, h.day, displaytime.hour, displaytime.minute);
    for (int i = 0; i < weeksAmountToShow && i < 6; i++) {
      displayDate = displayDate.add(Duration(days: 7));
      print(
          'Notification setted: text=$textToDisplay key=$key payload=$keyOfTraingForPayload|$keyOfCourseForPayload displayDate=$displayDate');
      await flutterLocalNotificationsPlugin.schedule(key + i, 'Time to review!',
          '$textToDisplay', displayDate, platformChannelSpecifics,
          payload: '$keyOfTraingForPayload|$keyOfCourseForPayload');
    }
  }

  //Work on canceling the right notification!
  static Future<void> cancelNotificationByKey(int key) async {
    await flutterLocalNotificationsPlugin.cancel(key);
    print('Notification canceled:  key=$key');
  }
}
