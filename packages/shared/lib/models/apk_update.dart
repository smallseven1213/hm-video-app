enum ApkStatus {
  noUpdate(1), // 不更新
  suggestUpdate(2), // 建議更新
  forceUpdate(3); // 強制更新

  final int value;

  const ApkStatus(
    this.value,
  );

  static ApkStatus parse(int i) {
    if (i == -1) return ApkStatus.noUpdate;
    return ApkStatus.values.firstWhere((e) => e.value == i);
  }
}

class ApkUpdate {
  final String? url;
  final ApkStatus status;

  ApkUpdate({
    required this.status,
    this.url,
  });
}
