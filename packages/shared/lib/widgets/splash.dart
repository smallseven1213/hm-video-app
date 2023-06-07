import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/controllers/game_response_controller.dart';
import 'package:game/services/game_system_config.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/apk_api.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/apis/dl_api.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/controllers/banner_controller.dart';
import 'package:shared/controllers/response_controller.dart';
import 'package:shared/services/system_config.dart';

import '../controllers/tag_popular_controller.dart';
import '../controllers/video_popular_controller.dart';
import '../enums/app_routes.dart';
import '../models/index.dart';
import '../navigator/delegate.dart';

final logger = Logger();

class Splash extends StatefulWidget {
  final String backgroundAssetPath;
  final Function? loading;

  const Splash({
    Key? key,
    required this.backgroundAssetPath,
    this.loading,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

void alertDialog(
  BuildContext context, {
  String? title,
  String? content,
  List<Widget>? actions,
}) {
  showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: title != null ? Text(title) : const SizedBox.shrink(),
      content: Text(content ?? ''),
      actions: actions ??
          <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('確認'),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
          ],
    ),
  );
}

class _SplashState extends State<Splash> {
  SystemConfig systemConfig = SystemConfig();
  GameSystemConfig gameSystemConfig = GameSystemConfig();
  DlApi dlApi = DlApi();
  ApkApi apkApi = ApkApi();
  UserApi userApi = UserApi();
  AuthApi authApi = AuthApi();
  BannerController bannerController = Get.put(BannerController());
  Timer? timer;
  AuthController authController = Get.find<AuthController>();
  ApiResponseErrorCatchController responseController =
      Get.find<ApiResponseErrorCatchController>();
  String loadingText = '線路檢查中...';

  GameApiResponseErrorCatchController gameResponseController =
      Get.find<GameApiResponseErrorCatchController>();

  // 取得invitationCode
  getInvitationCode() async {
    String invitationCode = '';
    // web from url ?code=xxx
    if (GetPlatform.isWeb) {
      String url = Uri.base.toString();
      Uri.base.queryParameters['code'] ?? '';
      final regExp = RegExp(r'code=([^&]+)');
      final code = regExp.firstMatch(url)?.group(1) ?? '';
      invitationCode = code;
    } else {
      // app from clipboard
      var cb = await Clipboard.getData(Clipboard.kTextPlain);
      invitationCode = cb?.text ?? '';
    }

    if (!RegExp('[0-9A-Za-z]{6}').hasMatch(invitationCode)) {
      invitationCode = '';
    }
    return invitationCode;
  }

  // Step3: fetch dl.json get apiHost & maintenance status
  fetchDlJson() async {
    logger.i('step3: fetch dl.json');
    var res = await dlApi.fetchDlJson();
    if (res != null) {
      // 設定apiHost & vodHost & imageHost & maintenance
      // https://api.pkonly8.com/
      systemConfig.setApiHost('https://api.${res['apl']?.first}');
      systemConfig.setVodHost('https://${res['dl']?.first}');
      systemConfig.setImageHost('https://${res['pl']?.first}');
      systemConfig.setMaintenance(res['maintenance'] == 'true' ? true : false);

      gameSystemConfig.setApiHost('https://api.${res['apl']?.first}');
    }

    return res;
  }

  // Step4: 檢查維護中
  checkIsMaintenance() async {
    logger.i('step4: 檢查是否維護中${systemConfig.isMaintenance}');
    if (systemConfig.isMaintenance) {
      alertDialog(context, content: '系統維護中，請稍後再試。', actions: []);
    }
    return systemConfig.isMaintenance;
  }

  // Step5: 檢查是否有更新
  checkApkUpdate() async {
    if (GetPlatform.isWeb) return true;
    if (mounted) {
      setState(() => loadingText = '檢查更新...');
    }
    logger.i('step5: 檢查是否有更新');
    final apkUpdate = await apkApi.checkVersion(
      version: systemConfig.version,
      agentCode: systemConfig.agentCode,
    );
    logger.i('apkUpdate: ${apkUpdate.status}');

    if (apkUpdate.status == ApkStatus.forceUpdate) {
      if (mounted) {
        alertDialog(
          context,
          content: '請更新至最新版本',
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('確認'),
              onPressed: () {
                Navigator.of(context).pop();
                userLogin();
              },
            ),
          ],
        );
      }
    } else if (apkUpdate.status == ApkStatus.suggestUpdate) {
      if (mounted) {
        alertDialog(
          context,
          title: '已有新版本',
          content: '已發布新版本，為了更流暢的觀影體驗，請更新版本',
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('確認'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                userLogin();
              },
            ),
          ],
        );
      }
    }
    return apkUpdate.status == ApkStatus.noUpdate;
  }

  // Step6: 檢查是否登入 - key: 'auth-token'
  userLogin() async {
    if (mounted) {
      setState(() => loadingText = '用戶登入...');
    }
    logger.i('step6: 檢查是否有token (是否登入 ${authController.token.value != ''})');

    logger.i('userApi: ${authController.token.value}');
    if (authController.token.value != '') {
      // Step6-1: 有: 記錄用戶登入 401 > 訪客登入 > 取得入站廣告 > 有廣告 > 廣告頁
      fetchInitialDataAndNavigate();
    } else {
      // Step6-2: 無: 訪客登入
      logger.i('step6.2: 無token (訪客登入)');
      try {
        String invitationCode = await getInvitationCode();
        final res = await authApi.guestLogin(
          invitationCode: invitationCode,
        );
        authController.setToken(res.data['token']);
        responseController.clear();

        gameResponseController.clear();

        logger.i('res.status ${res.code}');
        if (res.code == '00') {
          fetchInitialDataAndNavigate();
        } else {
          // if (mounted) {
          //   alertDialog(
          //     context,
          //     title: '失敗',
          //     content: res.message,
          //   );
          // }
          var message = '';
          if (res.code == '51633') {
            message = '帳號建立失敗，裝置停用。';
          } else {
            message = '帳號建立失敗。';
          }
          if (mounted) {
            alertDialog(
              context,
              title: '失敗',
              content: message,
            );
          }
        }
      } catch (err) {
        logger.i('err: $err');
        alertDialog(
          context,
          title: '失敗',
          content: '帳號建立失敗。($err)',
        );
      }
    }
  }

  // Step7.1: 取得nav bar內容
  getNavBar() {
    if (mounted) {
      setState(() => loadingText = '取得最新資源...');
    }
    logger.i('step7.1: 取得nav bar內容');
    // final NavBarController navBarController = Get.put(NavBarController());
    //  navBarController.fetchNavBar();
  }

  // Step7: 在首頁前要取得的資料
  // Step7.1: 取得nav bar內容
  // Step7.2: 取得入站廣告 > 有廣告 > 廣告頁
  // DI一些登入後才能用的資料(Controllers)
  fetchInitialDataAndNavigate() async {
    userApi.writeUserLoginRecord();
    if (mounted) {
      setState(() => loadingText = '取得最新資源...');
    }
    Get.put(VideoPopularController());
    Get.put(TagPopularController());
    logger.i('step7.2: 取得入站廣告 > 有廣告 > 廣告頁');
    List landingBanners =
        await bannerController.fetchBanner(BannerPosition.landing);

    if (landingBanners.isEmpty && mounted) {
      logger.i('沒有廣告，直接進入首頁');
      MyRouteDelegate.of(context)
          .pushAndRemoveUntil(AppRoutes.home.value, hasTransition: false);
    } else {
      logger.i('有廣告，進入廣告頁');
      MyRouteDelegate.of(context)
          .pushAndRemoveUntil(AppRoutes.ad.value, hasTransition: false);
    }
  }

  @override
  void initState() {
    Future.microtask(() async {
      WidgetsFlutterBinding.ensureInitialized();
      final dlJson = await fetchDlJson();
      bool isMaintenance = await checkIsMaintenance();
      if (dlJson == null || isMaintenance) return;
      // ---- init end ----
      bool enterable = await checkApkUpdate();
      if (enterable) {
        userLogin();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              widget.backgroundAssetPath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Center(
              child: widget.loading!(text: loadingText) ??
                  const CircularProgressIndicator(),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Text(
                '版本 ${systemConfig.version}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
