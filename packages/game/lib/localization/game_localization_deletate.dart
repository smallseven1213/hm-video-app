import 'package:flutter/material.dart';

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
  bool isSupported(Locale locale) =>
      localizedStringsMaps.keys.contains(locale.toLanguageTag());

  @override
  Future<GameLocalizations> load(Locale locale) async {
    // Load the localized strings from the maps provided
    Map<String, String> localizedStrings =
        localizedStringsMaps[locale.toLanguageTag()] ?? {};
    return GameLocalizations(localizedStrings);
  }

  @override
  bool shouldReload(GameLocalizationsDelegate old) => false;
}
