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
    var pos = int.parse(dePos.replaceAll(posChar, ''));
    return word.substring(posLen, posLen + pos) +
        word.substring(posLen + pos + passLen);
  } catch (e) {
    logger.i('format error: $e');
    return '';
  }
}
