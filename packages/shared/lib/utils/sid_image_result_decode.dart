import 'package:logger/logger.dart';

final logger = Logger();

String getSidImageDecode(
  String word, {
  int posStartAt = 0,
  String posChar = 'p',
  int posLen = 3,
  int passLen = 16,
}) {
  try {
    var dePos = word.substring(posStartAt, posLen);
    String input = dePos.replaceAll(posChar, '');
    var pos = 0;

    if (double.tryParse(input) != null) {
      pos = int.parse(input);
    } else {
      logger.i('@@@The input is not a numeric string, word: $word');
      return '00000000';
    }

    return word.substring(posLen, posLen + pos) +
        word.substring(posLen + pos + passLen);
  } catch (e) {
    logger.i('format error: $e');
    return '';
  }
}
