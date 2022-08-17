import 'package:get/get.dart';
import 'package:wgp_video_h5app/providers/index.dart';

abstract class BaseProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>(
        (request) => AuthProvider.authenticator(request));
    httpClient.addAuthenticator<dynamic>(
        (request) => AuthProvider.authenticator(request));
  }
}
