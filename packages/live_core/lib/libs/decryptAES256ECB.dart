import 'package:encrypt/encrypt.dart';

String decryptAES256ECB(String encryptedText) {
  const g_arEnKeys = [
    '1ct1v80d1qa95n71344w9z2sw84l1nht',
    'tn1ie73x5johgg0d79tp0k4oofpr8fh8',
    'h75znftpohyuaj4pkr5423k0u2qka7u6',
    '49ratphlufehici750n9qckp5mf3isk4',
    'obhm5z8xwln30rwq53i5kvpb82s5whay',
    '9st4p75qy7n6w8po70ehhq66h1s52ur0',
    'yy7ue0wyuj45yvsoxqnvwv2heroqb7yd',
    'uau1zpl0irnar9tkcvy9kc623pev3m42',
    'tsbuwbgclcl9e0nuvpd6osuezrcd2gjp',
    'xlh34607se23knfpuzpbp30x1e3manh3'
  ];

  int nKeyIdx = int.parse(encryptedText.substring(
      encryptedText.length - 3, encryptedText.length - 2));
  String enData = encryptedText.substring(0, encryptedText.length - 3) +
      encryptedText.substring(encryptedText.length - 2);

  final key = Key.fromUtf8(g_arEnKeys[nKeyIdx]);
  final encrypter = Encrypter(AES(key, mode: AESMode.ecb, padding: null));

  // final decrypted = encrypter.decrypt16(enData);
  // return decrypted.trim();

  final decrypted = encrypter.decrypt16(enData);
  String result = String.fromCharCodes(decrypted.runes.where((rune) {
    return rune != 0x07; // 移除 %07 字符
  }));
  return result;
}
