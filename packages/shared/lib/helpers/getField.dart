T getField<T>(Map<String, dynamic> json, String key,
    {required T defaultValue}) {
  try {
    final value = json[key];
    if (value is int && T == double) {
      return value.toDouble() as T;
    }
    return value ?? defaultValue;
  } catch (e) {
    print("Error parsing field $key: $e");
    return defaultValue;
  }
}
