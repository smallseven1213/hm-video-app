const env = String.fromEnvironment('ENV', defaultValue: 'dev');

class SystemConfig {
  /**
   * 這裡應該會
   * dl.json的資訊，但如果整個系統只有一次需要用到dl.json，那就別加了
   * 然後再幫我填入正確的apiHost等資訊
   */
  static final SystemConfig _instance = SystemConfig._internal();

  String apiHost = 'https://dl.dlstt.com/$env/dl.json';
  String vodHost = 'https://dl.dlstt.com/$env/dl.json';
  List<String> vodHostList = [
    'https://dl.dlstt.com/$env/dl.json',
    'https://dl.0272pay.com/$env/dl.json',
  ];

  int timeout = 5000;

  factory SystemConfig() {
    return _instance;
  }

  SystemConfig._internal();

  // settle
  void setApiHost(String host) {
    apiHost = host;
  }

  void setVodHost(String host) {
    vodHost = host;
  }
}
