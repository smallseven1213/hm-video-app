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
  final Map<String, String> localizedStrings;

  GameLocalizationsDelegate(this.localizedStrings);

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<GameLocalizations> load(Locale locale) async {
    return GameLocalizations(localizedStrings);
  }

  @override
  bool shouldReload(GameLocalizationsDelegate old) => false;
}
