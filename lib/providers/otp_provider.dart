import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class OtpException implements Exception {
  final String? _message;
  OtpException([this._message]);
  @override
  String toString() {
    if (_message == null) return "Exception";
    if (_message == "51817" || _message == "51805") return "請稍後再試";
    if (_message == "40000" || _message == "51818") return "手機號碼不正確";
    return "發送失敗";
  }
}

class OtpProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/otp';
    super.onInit();
  }

  Future<bool> getPinCode(String phoneNumber, int uid) =>
      post('/otp', {'phoneNumber': phoneNumber, 'uid': uid}).then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          throw OtpException(res['code']);
        }
        return true;
      });
}
