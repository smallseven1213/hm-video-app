enum Status {
  noUpdate(1), // 不更新
  suggestUpdate(2), // 建議更新
  forceUpdate(3); // 強制更新

  final int value;

  const Status(
    this.value,
  );

  static Status parse(int i) {
    if (i == -1) return Status.noUpdate;
    return Status.values.firstWhere((e) => e.value == i);
  }
}

class ApkUpdate {
  final String? url;
  final Status status;

  ApkUpdate({
    required this.status,
    this.url,
  });
}
