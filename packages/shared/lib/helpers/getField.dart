T getField<T>(Map<String, dynamic> json, String key,
    {required T defaultValue}) {
  try {
    return json[key] ?? defaultValue;
  } catch (e) {
    print("Error parsing field $key: $e");
    return defaultValue;
  }
}
