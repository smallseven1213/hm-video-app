const env = String.fromEnvironment('ENV', defaultValue: 'dev');

class SystemConfig {
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
}
