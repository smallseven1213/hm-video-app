import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LiveLocalizations {
  final Map<String, String> _localizedStrings; //

  LiveLocalizations(this._localizedStrings);

  String translate(String key) => _localizedStrings[key] ?? key;

  static LiveLocalizations? of(BuildContext context) {
    return Localizations.of<LiveLocalizations>(context, LiveLocalizations);
  }
}

class LiveLocalizationsDelegate
    extends LocalizationsDelegate<LiveLocalizations> {
  final Map<String, Map<String, String>> localizedStringsMaps;

  LiveLocalizationsDelegate(this.localizedStringsMaps);

  @override
  bool isSupported(Locale locale) {
    var languageTag = locale.toLanguageTag();
    return localizedStringsMaps.keys.contains(languageTag);
  }

  @override
  Future<LiveLocalizations> load(Locale locale) async {
    // Load the localized strings from the maps provided
    logger.i('current Live locale: ${locale.toLanguageTag()}');

    Map<String, String> localizedStrings =
        localizedStringsMaps[locale.toLanguageTag()] ?? {};
    // Map<String, String> localizedStrings = localizedStringsMaps['en-US'] ?? {};

    return LiveLocalizations(localizedStrings);
  }

  @override
  bool shouldReload(LiveLocalizationsDelegate old) => false;
}
