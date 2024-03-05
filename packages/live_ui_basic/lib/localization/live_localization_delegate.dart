import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LiveLocalizations {
  final Map<String, String> _localizedStrings;
  final Map<String, String> _defaultLocalizedStrings; // 中文的本地化字符串

  LiveLocalizations(this._localizedStrings, this._defaultLocalizedStrings);

  // 如果沒找到對應的翻譯，則嘗試從中文的條目中查找
  String translate(String key) =>
      _localizedStrings[key] ?? _defaultLocalizedStrings[key] ?? key;

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
    logger.i('current Live locale: ${locale.toLanguageTag()}');

    Map<String, String> localizedStrings =
        localizedStringsMaps[locale.toLanguageTag()] ?? {};
    Map<String, String> defaultLocalizedStrings =
        localizedStringsMaps['zh-CN'] ?? {}; // 假設中文的語言標籤是'zh-CN'

    return LiveLocalizations(localizedStrings, defaultLocalizedStrings);
  }

  @override
  bool shouldReload(LiveLocalizationsDelegate old) => false;
}
