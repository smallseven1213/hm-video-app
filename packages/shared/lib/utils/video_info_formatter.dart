String getTimeString(timeLength) =>
    '${((timeLength ?? 0) / 3600).floor().toString().padLeft(2, '0')}:${(((timeLength ?? 0) / 60).floor() % 60).toString().padLeft(2, '0')}:${((timeLength ?? 0) % 60).floor().toString().padLeft(2, '0')}';

String formatNumberToUnit(int videoViewTimes,
    {bool shouldCalculateThousands = true}) {
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

  return timeStr.length > 9
      ? '${(times / 1000000000).floor()}G'
      : (timeStr.length > 6
          ? '${(times / 1000000).floor()}M'
          : (shouldCalculateThousands && timeStr.length > 4
              ? '${formatNumber(times / 10000)}萬'
              : timeStr));
}
