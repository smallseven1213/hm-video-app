String formatDateTime(
  String dateTime,
) {
  String result = '';
  // 格式化日期和時間 to yyyy/MM/dd HH:mm:ss
  if (dateTime != '') {
    // 解析和調整時間
    final adjustedDate = formatTimeWithTimeZone(dateTime);
    final formattedDate =
        '${adjustedDate.year}/${adjustedDate.month.toString().padLeft(2, '0')}/${adjustedDate.day.toString().padLeft(2, '0')}';
    final formattedTime =
        '${adjustedDate.hour.toString().padLeft(2, '0')}:${adjustedDate.minute.toString().padLeft(2, '0')}:${adjustedDate.second.toString().padLeft(2, '0')}';
    result = '$formattedDate $formattedTime';
  }
  return result;
}

formatTimeWithTimeZone(String dateTime) {
  return dateTime != ''
      ? DateTime.parse(dateTime).add(const Duration(hours: 8))
      : null;
}
