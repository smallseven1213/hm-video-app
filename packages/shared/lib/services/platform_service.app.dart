abstract class PlatformService {
  String getHost();
}

class AppPlatformService implements PlatformService {
  @override
  String getHost() {
    return const String.fromEnvironment('AgentCode', defaultValue: '--');
  }
}
