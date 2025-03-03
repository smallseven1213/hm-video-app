import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class GameLocalizations {
  final Map<String, String> _localizedStrings;

  GameLocalizations(this._localizedStrings);

  String translate(String key) => _localizedStrings[key] ?? key;

  static GameLocalizations? of(BuildContext context) {
    return Localizations.of<GameLocalizations>(context, GameLocalizations);
  }
}

class GameLocalizationsDelegate
    extends LocalizationsDelegate<GameLocalizations> {
  final Map<String, Map<String, String>> localizedStringsMaps;

  GameLocalizationsDelegate(this.localizedStringsMaps);

  @override
  bool isSupported(Locale locale) {
    var languageTag = locale.toLanguageTag();
    return localizedStringsMaps.keys.contains(languageTag);
  }

  @override
  Future<GameLocalizations> load(Locale locale) async {
    // Load the localized strings from the maps provided
    logger.i('current game locale: ${locale.toLanguageTag()}');

    // Map<String, String> localizedStrings = localizedStringsMaps['en-US'] ?? {};
    Map<String, String> localizedStrings =
        localizedStringsMaps[locale.toLanguageTag()] ?? {};
    return GameLocalizations(localizedStrings);
  }

  @override
  bool shouldReload(GameLocalizationsDelegate old) => false;

  String getCurrentLanguageTag(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.toLanguageTag();
  }
}
