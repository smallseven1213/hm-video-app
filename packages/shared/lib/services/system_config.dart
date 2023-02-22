const env = String.fromEnvironment('ENV', defaultValue: 'dev');
const _project = String.fromEnvironment('PROJECT',
    defaultValue: 'STT'); // STT | GP | 51SS | SV
const _agentCode = String.fromEnvironment('AgentCode', defaultValue: '9L1O');

class SystemConfig {
  /**
   * 這裡應該會
   * dl.json的資訊，但如果整個系統只有一次需要用到dl.json，那就別加了
   * 然後再幫我填入正確的apiHost等資訊
   */
  static final SystemConfig _instance = SystemConfig._internal();

  String apiHost = 'https://dl.dlstt.com/$env/dl.json';
  String vodHost = 'https://dl.dlstt.com/$env/dl.json';
  String imgHost = 'https://dl.dlstt.com/$env/dl.json';
  String version =
      const String.fromEnvironment('VERSION', defaultValue: '22.0713.1.0');

  bool isMaintenance = false;

  List<String> vodHostList = [
    'https://dl.dlstt.com/$env/dl.json',
    'https://dl.0272pay.com/$env/dl.json',
  ];

  int timeout = 5000;

  String project = _project;
  String agentCode = _agentCode;

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

  void setImageHost(String host) {
    imgHost = host;
  }

  void setMaintenance(bool status) {
    isMaintenance = status;
  }
}
