import 'dart:ui';

import 'package:csv/csv_settings_autodetection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class CsvAssetLoader extends AssetLoader {
  CSVParser? csvParser;

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    if (csvParser == null) {
      // log('easy localization loader: load csv file $path');
      csvParser = CSVParser(await rootBundle.loadString(path));
    } else {
      // log('easy localization loader: CSV parser already loaded, read cache');
    }
    return csvParser!.getLanguageMap(locale.toString());
  }
}

class CSVParser {
  final String csvString;
  final List<List<dynamic>> lines;
  final String? fieldDelimiter;
  final String? eol;

  /// Enables automatic detection of the following
  ///
  /// [eols]: '\r\n' '\n'
  ///
  /// [fieldDelimiters]: ',' '\t'
  ///
  /// corresponding arguments must be [null]
  final bool useAutodetect;

  CSVParser(
    this.csvString, {
    this.fieldDelimiter,
    this.eol,
    this.useAutodetect = true,
  }) : lines = CsvToListConverter().convert(
          csvString,
          fieldDelimiter: fieldDelimiter,
          eol: eol,
          csvSettingsDetector:
              useAutodetect && fieldDelimiter == null && eol == null
                  ? const FirstOccurrenceSettingsDetector(
                      eols: ['\r\n', '\n'],
                      fieldDelimiters: [',', '\t'],
                    )
                  : null,
        );

  List getLanguages() {
    return lines.first.sublist(1, lines.first.length);
  }

  Map<String, dynamic> getLanguageMap(String localeName) {
    final indexLocale = lines.first.indexOf(localeName);

    var translations = <String, dynamic>{};
    for (var i = 1; i < lines.length; i++) {
      translations.addAll({lines[i][0]: lines[i][indexLocale]});
    }
    return translations;
  }
}
