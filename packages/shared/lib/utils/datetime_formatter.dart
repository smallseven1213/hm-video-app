String formatDateTime(String? dateTime) {
  if (dateTime == null || dateTime == '') {
    return '';
  }
  // 解析和調整時間
  final adjustedDate = formatTimeWithTimeZone(dateTime);
  if (adjustedDate == null) {
    return '';
  }

  final formattedDate =
      '${adjustedDate.year}/${adjustedDate.month.toString().padLeft(2, '0')}/${adjustedDate.day.toString().padLeft(2, '0')}';
  final formattedTime =
      '${adjustedDate.hour.toString().padLeft(2, '0')}:${adjustedDate.minute.toString().padLeft(2, '0')}:${adjustedDate.second.toString().padLeft(2, '0')}';

  return '$formattedDate $formattedTime';
}

DateTime? formatTimeWithTimeZone(String? dateTime) {
  if (dateTime == null || dateTime == '') {
    return null;
  }

  return DateTime.parse(dateTime).add(const Duration(hours: 8));
}
