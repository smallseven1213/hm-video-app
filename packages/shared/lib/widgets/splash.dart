import 'dart:async';
import 'package:flutter/foundation.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../controllers/system_config_controller.dart';
import '../controllers/tag_popular_controller.dart';
import '../controllers/video_popular_controller.dart';
import '../enums/app_routes.dart';
import '../localization/shared_localization_delegate.dart';
import '../models/index.dart';
import '../navigator/delegate.dart';

final logger = Logger();

class Splash extends StatefulWidget {
  final String backgroundAssetPath;
  final Function? loading;
  final bool skipNavigation;

  const Splash({
    Key? key,
    required this.backgroundAssetPath,
    this.loading,
    this.skipNavigation = false,
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
  final SharedLocalizations localizations = SharedLocalizations.of(context)!;

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
              child: Text(localizations.translate('confirm')),
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
  late SharedLocalizations localizations; // 延后初始化

  final SystemConfigController systemConfigController =
      Get.find<SystemConfigController>();
  // SystemConfig systemConfig = SystemConfig();
  GameSystemConfig gameSystemConfig = GameSystemConfig();
  DlApi dlApi = DlApi();
  ApkApi apkApi = ApkApi();
  UserApi userApi = UserApi();
  AuthApi authApi = AuthApi();
  BannerController bannerController = Get.find<BannerController>();
  Timer? timer;
  AuthController authController = Get.find<AuthController>();
  ApiResponseErrorCatchController responseController =
      Get.find<ApiResponseErrorCatchController>();
  String loadingText = 'loading...';

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

    if (!RegExp(r'^[0-9A-Za-z]{6}$').hasMatch(invitationCode)) {
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
      systemConfigController.setApiHost('https://api.${res['apl']?.first}');
      systemConfigController.setVodHost('https://${res['dl']?.first}');
      systemConfigController.setImageHost('https://${res['pl']?.first}');
      systemConfigController
          .setMaintenance(res['maintenance'] == 'true' ? true : false);

      gameSystemConfig.setApiHost('https://api.${res['apl']?.first}');
    }

    return res;
  }

  // Step4: 檢查維護中
  checkIsMaintenance() async {
    logger.i('step4: 檢查是否維護中${systemConfigController.isMaintenance}');
    if (systemConfigController.isMaintenance.value) {
      alertDialog(context,
          content: localizations
              .translate('system_under_maintenance_please_try_again_later'),
          actions: []);
    }
    return systemConfigController.isMaintenance.value;
  }

  // Step5: 檢查是否有更新
  checkApkUpdate() async {
    if (GetPlatform.isWeb) return true;
    if (mounted) {
      setState(() => loadingText =
          localizations.translate('checking_for_updates')); //檢查更新....
    }
    logger.i('step5: 檢查是否有更新');
    ApkUpdate apkUpdate = await apkApi.checkVersion(
      version: systemConfigController.version.value,
      agentCode: systemConfigController.agentCode.value,
    );
    logger.i('apkUpdate: ${apkUpdate.status}');

    if (apkUpdate.status == ApkStatus.forceUpdate) {
      if (mounted) {
        alertDialog(
          context,
          title: localizations.translate('new_version_available'),
          content: localizations.translate(
              'a_new_version_has_been_released_for_a_smoother_experience_please_update'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(localizations.translate('update_now')),
              // ignore: deprecated_member_use
              onPressed: () => launch('https://${apkUpdate.url ?? ''}'),
            ),
          ],
        );
      }
    } else if (apkUpdate.status == ApkStatus.suggestUpdate) {
      if (mounted) {
        alertDialog(
          context,
          title: localizations.translate('new_version_available'),
          content: localizations.translate(
              'a_new_version_has_been_released_for_a_smoother_experience_please_update'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(localizations.translate('experience_now')),
              // ignore: deprecated_member_use
              onPressed: () => launch('https://${apkUpdate.url ?? ''}'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(localizations.translate('do_not_upgrade')),
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
      setState(() => loadingText = localizations.translate('user_login'));
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
        logger.i('res.status ${res.code}');
        if (res.code == '00') {
          responseController.clear();
          gameResponseController.clear();
          fetchInitialDataAndNavigate();
        } else {
          var message = '';
          if (res.code == '51633') {
            message = localizations
                .translate('account_creation_failed_device_disabled');
          } else {
            final String code = res.code ?? '';
            final String data = res.data.toString();
            final String response = 'code: $code, data: $data';
            message = localizations.translate('account_creation_failed') +
                '.$response';
            await Clipboard.setData(ClipboardData(text: response));
          }
          if (mounted) {
            alertDialog(
              context,
              title: localizations.translate('failure'),
              content: message,
            );
          }
        }
      } catch (err) {
        logger.i('err: $err');
        alertDialog(
          context,
          title: localizations.translate('failure'),
          content: 'account_creation_failed.($err)',
        );
      }
    }
  }

// Step7.1: 取得nav bar內容
  getNavBar() {
    if (mounted) {
      setState(() =>
          loadingText = localizations.translate('getting_latest_resources'));
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
      setState(() =>
          loadingText = localizations.translate('getting_latest_resources'));
    }
    Get.put(VideoPopularController());
    Get.put(TagPopularController());
    logger.i('step7.2: 取得入站廣告 > 有廣告 > 廣告頁');
    List landingBanners =
        await bannerController.fetchBanner(BannerPosition.landing);
// check if 401
    if (responseController.apiResponse.value.status == 401 ||
        widget.skipNavigation) {
      return;
    }
    if (landingBanners.isEmpty && mounted) {
      logger.i('沒有廣告，直接進入首頁');
      MyRouteDelegate.of(context)
          .pushAndRemoveUntil(AppRoutes.home, hasTransition: false);
    } else {
      logger.i('有廣告，進入廣告頁');
      MyRouteDelegate.of(context)
          .pushAndRemoveUntil(AppRoutes.ad, hasTransition: false);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      WidgetsFlutterBinding.ensureInitialized();
      final dlJson = await fetchDlJson();
      bool isMaintenance = await checkIsMaintenance();
      if (dlJson == null || isMaintenance) return;
// –– init end ––
      bool enterable = await checkApkUpdate();
      if (enterable) {
        userLogin();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = SharedLocalizations.of(context)!;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // HC: 煩死，勿動!!
      child: Scaffold(
        body: Stack(
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
              bottom: kIsWeb ? 20 : 70,
              right: 20,
              child: Text(
                '${localizations.translate('version')} ${systemConfigController.version.value}',
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
