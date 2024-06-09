import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rem_bra/constants.dart';

import 'Managers/dataManager.dart';
import 'appsate.dart';

class StartDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (contextExtern, model, child) {


      return AnimatedContainer(
        color: DataManager.actualBackgroundColor,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('icon/icon.png'),
              ),
            ),
          ),
        ),
        duration: Duration(milliseconds: LoadSpecs.colorTransitionDuration),
      );
    });
  }
}
