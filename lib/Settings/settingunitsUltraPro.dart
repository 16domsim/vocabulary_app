import 'package:flutter/cupertino.dart';

class SettingUnits {
  static final double settingLineWidth = 0.5;

  static final separtionLineWidget = Row(
    children: <Widget>[
      Expanded(
        child: Container(
          height: settingLineWidth,
          color: CupertinoColors.inactiveGray,
        ),
      ),
    ],
  );

  static Widget separtionLineWidgetSmall(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          height: SettingUnits.settingLineWidth,
          width: MediaQuery.of(context).size.width - 40,
          color: CupertinoColors.inactiveGray,
        ),
      ],
    );
  }

  static Widget createSettingUnitSwitch(
      String text,
      bool value,
      onChanged(bool newValue),
      bool first,
      bool last,
      Color accentColor,
      Color textColor,
      Color backgroundColor,
      BuildContext context) {
    Widget up = Padding(padding: EdgeInsets.all(0));
    if (first) up = separtionLineWidget;
    Widget down = separtionLineWidgetSmall(context);
    if (last) down = separtionLineWidget;

    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          up,
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$text',
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(color: textColor)),
                SizedBox(
                    height: 10,
                    child: CupertinoSwitch(
                      activeColor: accentColor,
                      value: value,
                      onChanged: onChanged,
                    )),
              ],
            ),
          ),
          down,
        ],
      ),
    );
  }

  static Widget createSettingUnitPopUpChoice(
      String text,
      String buttonText,
      onChanged(int newIndex),
      List<String> possibleValues,
      int initialItemIndex,
      bool first,
      bool last,
      Color accentColor,
      Color textColor,
      Color backgroundColor,
      BuildContext context) {
    Widget up = Padding(padding: EdgeInsets.all(0));
    if (first) up = separtionLineWidget;

    Widget down = separtionLineWidgetSmall(context);
    if (last) down = separtionLineWidget;

    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: Stack(
                children: <Widget>[
                  CupertinoPicker(
                    magnification: 0.8,
                    itemExtent: 40,
                    looping: false,
                    children: possibleValues
                        .map((f) => Text(
                              '$f',
                              style: TextStyle(fontSize: 30),
                            ))
                        .toList(),
                    backgroundColor: CupertinoColors.lightBackgroundGray,
                    scrollController: FixedExtentScrollController(
                        initialItem: initialItemIndex),
                    onSelectedItemChanged: (int i) {
                      onChanged(i);
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: CupertinoButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          color: accentColor,
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
      },
      child: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            up,
            Padding(
              padding:
                  EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$text',
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    '$buttonText',
                    style: TextStyle(color: accentColor),
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

  static Widget createSettingNavigationUnit(
      Widget settingIcon,
      String text,
      onPressed(),
      bool first,
      bool last,
      Color accentColor,
      Color textColor,
      Color backgroundColor,
      BuildContext context) {
    Widget up = Padding(padding: EdgeInsets.only(top: 0));
    if (first) up = separtionLineWidget;
    Widget down = separtionLineWidgetSmall(context);
    if (last) down = separtionLineWidget;

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            up,
            Padding(
              padding: EdgeInsets.only(right: 10, left: 5, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: settingIcon,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        '$text',
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                  Text(
                    '>',
                    style: TextStyle(color: CupertinoColors.inactiveGray),
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

  static Widget createSettingSliderUnit(
      String text,
      double value,
      double min,
      double max,
      onChanged(double newIndex),
      bool first,
      bool last,
      Color accentColor,
      Color textColor,
      Color backgroundColor,
      BuildContext context) {
    Widget up = Padding(padding: EdgeInsets.all(0));
    if (first) up = separtionLineWidget;
    Widget down = separtionLineWidgetSmall(context);
    if (last) down = separtionLineWidget;

    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          up,
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    '$text',
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(color: textColor),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 10,
                    child: CupertinoSlider(
                      value: value,
                      min: min,
                      max: max,
                      divisions: (max - min).toInt(),
                      onChanged: (double newValue) {
                        onChanged(newValue);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          down,
        ],
      ),
    );
  }

  static Widget createSettingNavigationExtraBigLeadingUnit(
      Widget settingIcon,
      String text,
      onPressed(),
      bool first,
      bool last,
      Color accentColor,
      Color textColor,
      Color backgroundColor,
      BuildContext context) {
    Widget up = Padding(padding: EdgeInsets.only(top: 0));
    if (first) up = separtionLineWidget;
    Widget down = separtionLineWidgetSmall(context);
    if (last) down = separtionLineWidget;

    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            up,
            Padding(
              padding: EdgeInsets.only(right: 10, left: 5, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: settingIcon,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        '$text',
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: TextStyle(color: textColor, fontSize: 18),
                      )
                    ],
                  ),
                  Text(
                    '>',
                    style: TextStyle(color: CupertinoColors.inactiveGray),
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

  static Widget createSettingTextfieldUnit(
      String title,
      TextEditingController textEditingController,
      bool isTextRed,
      bool first,
      bool last,
      Color accentColor,
      Color textColor,
      Color backgroundColor,
      BuildContext context) {
    Widget up = Padding(padding: EdgeInsets.all(0));
    if (first) up = separtionLineWidget;
    Widget down = separtionLineWidgetSmall(context);
    if (last) down = separtionLineWidget;

    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          up,
          Padding(
            padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  child: Text(
                    '$title',
                    style: TextStyle(
                        color: isTextRed
                            ? CupertinoColors.destructiveRed
                            : textColor),
                  ),
                ),
                Expanded(
                  child: CupertinoTextField(
                    maxLines: 1,
                    maxLength: 20,
                    maxLengthEnforced: true,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    controller: textEditingController,
                    placeholderStyle:
                        TextStyle(color: textColor.withOpacity(0.5)),
                    style: TextStyle(color: textColor),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 0.5, color: accentColor),
                    ),
                    cursorColor: accentColor,
                  ),
                ),
              ],
            ),
          ),
          down,
        ],
      ),
    );
  }

  static Widget createSettingInformationalUnit(String textToDisplay) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 10, bottom: 15, left: 10),
      child: Text(
        '$textToDisplay',
        style: TextStyle(fontSize: 12, color: CupertinoColors.inactiveGray),
      ),
    );
  }

  static Widget createSettingUnitTimePopUpChoice(
      String text,
      String buttonText,
      onChanged(DateTime newDateTime),
      DateTime initialTime,
      bool first,
      bool last,
      Color accentColor,
      Color textColor,
      Color backgroundColor,
      BuildContext context) {
    Widget up = Padding(padding: EdgeInsets.all(0));
    if (first) up = separtionLineWidget;

    Widget down = separtionLineWidgetSmall(context);
    if (last) down = separtionLineWidget;

    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: Stack(
                children: <Widget>[
                  CupertinoDatePicker(
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.time,
                    backgroundColor: CupertinoColors.lightBackgroundGray,
                    initialDateTime: initialTime,
                    onDateTimeChanged: (DateTime duration) {
                      onChanged(duration);
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: CupertinoButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          color: accentColor,
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
      },
      child: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            up,
            Padding(
              padding:
                  EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$text',
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    '$buttonText',
                    style: TextStyle(color: accentColor),
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

  static Widget createSettingUnitWrapper(
      Widget child,
      bool first,
      bool last,
      Color accentColor,
      Color textColor,
      Color backgroundColor,
      BuildContext context,
      {String title}) {
    Widget up = Padding(padding: EdgeInsets.all(0));
    if (first) up = separtionLineWidget;

    Widget down = separtionLineWidgetSmall(context);
    if (last) down = separtionLineWidget;

    Widget possibleTitle = Padding(padding: EdgeInsets.only(top: 0));

    if (title != null) {
      possibleTitle = Padding(
        padding: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
        child: Text(
          '$title',
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: TextStyle(color: textColor),
        ),
      );
    }

    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          up,
          possibleTitle,
          Padding(
              padding:
                  EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
              child: child),
          down,
        ],
      ),
    );
  }

  static Widget createSettingUnitSmallSpacer() {
    return Padding(padding: EdgeInsets.only(top: 30));
  }

  static Widget createSettingUnitBigSpacer() {
    return Padding(padding: EdgeInsets.only(top: 60));
  }
}
