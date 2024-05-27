import 'package:get_storage/get_storage.dart';

String getTimeString(timeLength) =>
    '${((timeLength ?? 0) / 3600).floor().toString().padLeft(2, '0')}:${(((timeLength ?? 0) / 60).floor() % 60).toString().padLeft(2, '0')}:${((timeLength ?? 0) % 60).floor().toString().padLeft(2, '0')}';

String formatNumberToUnit(int videoViewTimes,
    {bool shouldCalculateThousands = true}) {
  var locale = GetStorage('locale').read('locale');

  var times = videoViewTimes;
  var timeStr = videoViewTimes.toString();

  String formatNumber(double number) {
    String roundedNumber = number.toStringAsFixed(1);
    double roundedNumberAsDouble = double.parse(roundedNumber);

    if (roundedNumberAsDouble == roundedNumberAsDouble.floor()) {
      return roundedNumberAsDouble.floor().toString();
    } else {
      return roundedNumber;
    }
  }

  String formattedNumber;
  if (timeStr.length > 9) {
    formattedNumber = '${(times / 1000000000).floor()}G';
  } else if (timeStr.length > 6) {
    formattedNumber = '${(times / 1000000).floor()}M';
  } else if (shouldCalculateThousands && timeStr.length > 4) {
    if (locale == 'zh-CN' || locale == 'zh-TW' || locale == 'zh-HK') {
      formattedNumber = '${formatNumber(times / 10000)}萬';
    } else {
      formattedNumber = '${formatNumber(times / 1000)}k';
    }
  } else {
    formattedNumber = timeStr;
  }

  return formattedNumber;
}
