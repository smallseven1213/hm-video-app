import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:universal_html/html.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';

class AppController extends GetxController {
  static AppController get cc => Get.find<AppController>();
  String version =
      const String.fromEnvironment('VERSION', defaultValue: '7_29_1');

  late RouteObserver<ModalRoute<void>> routeObserver;
  bool isShowNotice = false;
  int navigationBarIndex = 0.obs();
  String currentRouteName = '/home'.obs();
  String token = ''.obs();
  String invitationCode = ''.obs();
  String agentCode = '9L1O'.obs();
  String loginLinkCode = ''.obs();
  late Database db;
  late VEndpoint endpoint;

  setRouteObserver(RouteObserver<ModalRoute<void>> _routeObserver) {
    routeObserver = _routeObserver;
    update();
  }

  setEndpoint(VEndpoint _endpoint) {
    endpoint = _endpoint;
    update();
  }

  toNamed(String route, int index) {
    navigationBarIndex = index;
    currentRouteName = route;
    gto(route);
    update();
  }

  updateNavigationIndex(String route, index) {
    navigationBarIndex = index;
    currentRouteName = route;
    update();
  }

  init() async {
    if (kIsWeb) {
      var factory = databaseFactoryWeb;
      db = await factory.openDatabase('images');
    } else {
      //   var factory = databaseFactoryIo;
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      print(dir.path);
      //   db = await factory.openDatabase(join(dir.path, 'images.db'));
    }
    if (gsss().hasData('auth-token')) {
      token = gsss().read('auth-token');
    }
    if (gsss().hasData('auth-login-code')) {
      loginLinkCode = gsss().read('auth-login-code');
    }
    if (kIsWeb) {
      var q = window.location.host.split('.')[0];
      if (q.isNotEmpty == true) {
        agentCode = q.toString();
      }
      var qs = window.location.hash;
      if (qs.isNotEmpty && qs.length > 3) {
        var qsArr = qs.replaceRange(0, 3, '').split('=');
        if (qsArr.length > 1 && qsArr[0] == 'code') {
          invitationCode = qsArr[1];
        }
      }
    }
    update();
  }

  updateInvitationCode(String code) {
    var _code = code.replaceAll('&code=', '');
    invitationCode = _code;
    update();
  }

  updateAgentCode(String code) {
    agentCode = code;
    update();
  }

  login(String authToken) {
    token = authToken;
    gsss().write('auth-token', token);
    update();
  }

  void showNotice() {
    isShowNotice = true;
    update();
  }
}
