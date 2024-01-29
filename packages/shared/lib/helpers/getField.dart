T getField<T>(Map<String, dynamic> json, String key,
    {required T defaultValue}) {
  try {
    print("getField $json \n $key");
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
