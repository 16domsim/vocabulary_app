import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import '../constants.dart';
import 'dataManager.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  /**
   * To generate the new Methods go to the codeGenerator and use this RegEs:
   * 
   * search: [^\)]*
   * 
   * replace(x=your code): x$0x 
   * 
   * For the getters the replace is: String get $0 =>  _localizedValues[locale.languageCode]
      [PrefixesForDisplayedTextes.$0];
   */

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    SupportedLanguages.englishUnicodeID: {
      PrefixesForDisplayedTextes.wordsBottomIcon: 'Words',
      PrefixesForDisplayedTextes.wordsBigTitle: 'My Words',
      PrefixesForDisplayedTextes.learnBottomIcon: 'Learn',
      PrefixesForDisplayedTextes.learnBigTitle: 'Learn',
      PrefixesForDisplayedTextes.statisticsBottomIcon: 'Stats',
      PrefixesForDisplayedTextes.statisticsBigTitle: 'Statistics',
      PrefixesForDisplayedTextes.settingsBottomIcon: 'Settings',
      PrefixesForDisplayedTextes.settingsBigTitle: 'Setting',
    },
    SupportedLanguages.italianUnicodeID: {
      PrefixesForDisplayedTextes.wordsBottomIcon: 'Parole',
      PrefixesForDisplayedTextes.wordsBigTitle: 'Parole',
      PrefixesForDisplayedTextes.learnBottomIcon: 'Imparare',
      PrefixesForDisplayedTextes.learnBigTitle: 'Imparare',
      PrefixesForDisplayedTextes.statisticsBottomIcon: 'Statistiche',
      PrefixesForDisplayedTextes.statisticsBigTitle: 'Statistiche',
      PrefixesForDisplayedTextes.settingsBottomIcon: 'Impostazioni',
      PrefixesForDisplayedTextes.settingsBigTitle: 'Impostazioni',
    },
    SupportedLanguages.germanUnicodeID: {
      PrefixesForDisplayedTextes.wordsBottomIcon: 'Wörter',
      PrefixesForDisplayedTextes.wordsBigTitle: 'Wörter',
      PrefixesForDisplayedTextes.learnBottomIcon: 'Lernen',
      PrefixesForDisplayedTextes.learnBigTitle: 'Lernen',
      PrefixesForDisplayedTextes.statisticsBottomIcon: 'Statistik',
      PrefixesForDisplayedTextes.statisticsBigTitle: 'Statistik',
      PrefixesForDisplayedTextes.settingsBottomIcon: 'Einstellungen',
      PrefixesForDisplayedTextes.settingsBigTitle: 'Einstellungen',
    },
  };

  String get wordsBottomIcon => _localizedValues[DataManager.languageUnicodeID]
      [PrefixesForDisplayedTextes.wordsBottomIcon];
  String get wordsBigTitle => _localizedValues[DataManager.languageUnicodeID]
      [PrefixesForDisplayedTextes.wordsBigTitle];
  String get learnBottomIcon => _localizedValues[DataManager.languageUnicodeID]
      [PrefixesForDisplayedTextes.learnBottomIcon];
  String get learnBigTitle => _localizedValues[DataManager.languageUnicodeID]
      [PrefixesForDisplayedTextes.learnBigTitle];
  String get statisticsBottomIcon => _localizedValues[DataManager.languageUnicodeID]
      [PrefixesForDisplayedTextes.statisticsBottomIcon];
  String get statisticsBigTitle => _localizedValues[DataManager.languageUnicodeID]
      [PrefixesForDisplayedTextes.statisticsBigTitle];
  String get settingsBottomIcon => _localizedValues[DataManager.languageUnicodeID]
      [PrefixesForDisplayedTextes.settingsBottomIcon];
  String get settingsBigTitle => _localizedValues[DataManager.languageUnicodeID]
      [PrefixesForDisplayedTextes.settingsBigTitle];
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => [
        SupportedLanguages.englishUnicodeID,
        SupportedLanguages.italianUnicodeID,
        SupportedLanguages.germanUnicodeID
      ].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
