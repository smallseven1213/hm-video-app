import 'dart:io';

import 'package:game/controllers/game_list_controller.dart';
import 'package:game/controllers/game_response_controller.dart';
import 'package:game/models/bank.dart';
import 'package:game/models/game_activity.dart';
import 'package:game/models/game_deposit_payment_channel.dart';
import 'package:game/models/game_deposit_payment_type_list.dart';
import 'package:game/models/game_deposit_payments_type.dart';
import 'package:game/models/game_list.dart';
import 'package:game/models/game_order.dart';
import 'package:game/models/game_payment.dart';
import 'package:game/models/game_payment_channel_detail.dart';
import 'package:game/models/game_platform.dart';
import 'package:game/models/game_withdraw_record.dart';
import 'package:game/models/game_withdraw_stack_limit.dart';
import 'package:game/models/hm_api_response.dart';
import 'package:game/models/hm_api_response_with_data.dart';
import 'package:game/models/user_withdrawal_data.dart';
import 'package:game/services/game_system_config.dart';
import 'package:game/utils/fetcher.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/services/platform_service.app.dart'
    if (dart.library.html) 'package:shared/services/platform_service.web.dart'
    as app_platform_service;
import 'package:shared/utils/fetcher.dart' as shared_fetcher;

final logger = Logger();

final systemConfig = GameSystemConfig(); // 已更換api host from login

SystemConfigController systemController =
    Get.find<SystemConfigController>(); // from share
final responseController = Get.find<GameApiResponseErrorCatchController>();

_checkMaintenance(String code) {
  final GamesListController gamesListController =
      Get.put(GamesListController());

  if (code == '9999') {
    gamesListController.setMaintenanceStatus(true);
    throw Exception('目前系統維護中');
  }
}

class GameLobbyApi {
  static final GameLobbyApi _instance = GameLobbyApi._internal();

  GameLobbyApi._internal();

  factory GameLobbyApi() {
    return _instance;
  }

  // 已更換api host from login
  Future enterGame(String tpCode, String gameId) async {
    var value = await fetcher(
        url: '${systemConfig.apiHost}/public/game/game/enter-game',
        method: 'POST',
        body: {
          'tpCode': tpCode,
          'gameId': gameId,
        });

    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return [];
    }
    return res['data'];
  }

  // 已更換api host from login
  // 取得遊戲列表
  Future<List<GameItem>> getGames() =>
      fetcher(url: '${systemConfig.apiHost}/public/game/game/list').then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          _checkMaintenance(res['code']);

          if (res['code'] != '00') {
            return [];
          }

          List<GameItem> record =
              List.from((res['data'] as List<dynamic>).map((d) {
            try {
              return GameItem.fromJson(d);
            } catch (e) {
              logger.e('GameItem.fromJson error: $e');

              return GameItem(
                id: 0,
                name: '',
                gameId: '',
                imgUrl: '',
                orderIndex: 0,
                isHot: false,
                gameType: 0,
                tpCode: '',
                direction: 0,
                hotOrderIndex: 0,
              );
            }
          }));

          return record;
        },
      );

  // 已更換api host from login
  // 取得遊戲平台列表
  Future<List<GamePlatformItem>> getGamePlatform() => fetcher(
              url:
                  '${systemConfig.apiHost}/public/gamePlatforms/gamePlatform/list?supportDevice=2')
          .then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          _checkMaintenance(res['code']);

          if (res['code'] != '00') {
            return [];
          }

          List<GamePlatformItem> record = List.from(
              (res['data'] as List<dynamic>)
                  .map((e) => GamePlatformItem.fromJson(e))
                  .toList());

          return record;
        },
      );

  // 已更換api host from login
  // 取得支付類型 transfer bank / mobile deposit
  Future<List<DepositPaymentsType>> getPaymentsType() async {
    var value =
        await fetcher(url: '${systemConfig.apiHost}/public/payments/type');
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return [];
    }

    return List.from((res['data'] as List<dynamic>)
        .map((e) => DepositPaymentsType.fromJson(e)));
  }

  // 已更換api host from login
  // 存款充值建單 transfer bank / mobile deposit
  Future<String> depositByPaymentType({
    String agentAccount = '',
    required String amount,
    required int paymentChannelId,
    String? name,
  }) async {
    var value = await fetcher(
      url:
          '${systemConfig.apiHost}/public/orders/order/deposit/by-payment-type',
      method: 'POST',
      body: {
        'amount': amount,
        'paymentTypeId': paymentChannelId,
        'name': name,
      },
    );
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return res['code'];
    }
    return res['data']['paymentLink'];
  }

  // 已更換api host from login
  // 綁定資金密碼
  Future<HMApiResponseBaseWithDataWithData<bool>> checkPaymentPin(
      String paymentPin) async {
    var value = await fetcher(
        url:
            '${systemConfig.apiHost}/public/users/user/payment/payment-pin-code',
        method: 'POST',
        body: {'paymentPin': paymentPin});
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    return HMApiResponseBaseWithDataWithData<bool>.fromJson(res);
  }

  // 已更換api host from login
  // 更新資金密碼
  Future<void> updatePaymentPin(String paymentPin) async {
    var value = await fetcher(
        url:
            '${systemConfig.apiHost}/public/users/user/payment/payment-pin-code',
        method: 'PATCH',
        body: {'paymentPin': paymentPin});
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      throw Exception(res['message']);
    }
  }

  // 已更換api host from login
  // 會員點數轉回GP / 轉回餘額
  Future transfer() => fetcher(
          url: '${systemConfig.apiHost}/public/users/user/points/collect',
          method: 'POST',
          body: {}).then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          _checkMaintenance(res['code']);

          if (res['code'] != '00') {
            return res;
          }

          return res;
        },
      );

  // =================================== 以下 API HOST FROM VIDEO =================================== //

  Future<void> register() => shared_fetcher.fetcher(
      url:
          '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/register',
      method: 'POST',
      body: {});

  // 初次進入遊戲大廳
  Future registerGame() async {
    GetStorage box = GetStorage();
    if (box.hasData('register-game')) return;
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/register',
        method: 'POST',
        body: {});
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] == '00') {
      box.write('register-game', true);
    }

    logger.i('registerGame: $res');
    return res['data'];
  }

  // 取得遊戲大廳跑馬燈&輪播圖banner
  Future getMarqueeAndBanner() => shared_fetcher
          .fetcher(
              url:
                  '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/marquee-and-banner')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        _checkMaintenance(res['code']);

        if (res['code'] != '00') {
          return [];
        }
        if (res['data'] != null) {
          return res['data'];
        }
      });

  Future getPoints() => shared_fetcher
          .fetcher(
              url:
                  '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/points')
          .then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          _checkMaintenance(res['code']);

          if (res['code'] != '00') {
            return [];
          }

          return res['data'];
        },
      );

  // 遊戲大廳 取得用戶遊戲提現詳情
  // 是否設置銀行卡
  // 是否設置資金密碼
  Future<Map> getUserGameWithdrawalData() async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/gameWithdrawal');
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return res;
    }
    return {
      "code": "00",
      "data": UserWithdrawalData.fromJson(res['data']),
    };
  }

  // 取得用戶流水
  Future<HMApiResponseBaseWithDataWithData<GameWithdrawStackLimit>>
      getStackLimit() async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/stack-limit');
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    var stackLimitData = res['data'] == null
        ? null
        : GameWithdrawStackLimit.fromJson(res['data']);

    return HMApiResponseBaseWithDataWithData<GameWithdrawStackLimit>(
      code: res['code'],
      data: stackLimitData,
    );
  }

  // 取得遊戲設置config
  Future<GameConfig> getGamePlatformConfig() => shared_fetcher
          .fetcher(
              url:
                  '${systemController.apiHost.value}/public/game-platform-config/game-platform-config')
          .then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          _checkMaintenance(res['code']);

          if (res['code'] != '00') {
            return GameConfig(
              enabled: false,
              distributed: false,
              paymentPage: 1,
              pageColor: 1,
              needsPhoneVerification: false,
              countryCode: null,
              isGameLobbyBalanceShow: true,
            );
          }

          return GameConfig.fromJson(res['data'] as Map<String, dynamic>);
        },
      );

  // 取得參數設定
  Future<HMApiResponseBaseWithDataWithData<GameParamConfig>>
      getGameParamConfig() async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/parameter-config');
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    var paramConfigData =
        res['data'] == null ? null : GameParamConfig.fromJson(res['data']);

    return HMApiResponseBaseWithDataWithData<GameParamConfig>(
      code: res['code'],
      data: paramConfigData,
    );
  }

  // 提款申請v2
  Future<HMApiResponse> applyWithdrawalV2(
      int remittanceType,
      String applyAmount,
      String paymentPin,
      String stakeLimit,
      String validStake) async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/withdrawalV2',
        method: 'POST',
        body: {
          'remittanceType': remittanceType,
          'applyAmount': applyAmount,
          'paymentPin': paymentPin,
          'stakeLimit': stakeLimit,
          'validAmount': validStake,
        });
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    return HMApiResponse.fromJson(res);
  }

// 遊戲大廳 取得支付渠道
  Future<List<Payment>> getPaymentsBy(String amount) async {
    Map<String, int> deviceType = {
      'web': 1,
      'ios': 2,
      'android': 3,
    };

    String platformKey = GetPlatform.isWeb
        ? 'web'
        : Platform.isAndroid
            ? 'android'
            : 'ios';

    return shared_fetcher
        .fetcher(
            url:
                '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/payment-channel?deviceType=${deviceType[platformKey] ?? 1}&amount=$amount')
        .then((value) {
      var res = (value.data as Map<String, dynamic>);
      _checkMaintenance(res['code']);

      if (res['code'] != '00') {
        return [];
      }
      return List.from(
          (res['data'] as List<dynamic>).map((e) => Payment.fromJson(e)));
    });
  }

  // 取得存款渠道v2
  Future<Map<String, dynamic>> getDepositChannel() async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/deposit-channel-v2?deviceType=${GetPlatform.isWeb ? 1 : Platform.isAndroid ? 2 : 3}');
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return {
        'code': res['code'],
        'message': res['message'],
      };
    }

    final Map<String, dynamic> data = res['data'] as Map<String, dynamic>;
    final Map<String, dynamic> depositChannels = {};

    data.forEach((key, value) {
      final List<dynamic>? paymentChannelsData = value['paymentChannel'];
      if (paymentChannelsData != null) {
        List<DepositPaymentChannel> paymentChannels =
            paymentChannelsData.map((channelData) {
          try {
            return DepositPaymentChannel.fromJsonWithNullCheck(channelData);
          } catch (e) {
            logger.e('Error creating DepositPaymentChannel: $e');
            rethrow;
          }
        }).toList();
        depositChannels[key] = paymentChannels;
      } else {
        depositChannels[key] = []; // 如果 paymentChannel 是 null，則設置為空列表
      }
    });

    return {
      'code': res['code'],
      'data': depositChannels,
    };
  }

  // 取得存款支付類型列表
  Future<List<DepositPaymentTypeList>> getPaymentList() async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/payment/payment-type/list');
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return [];
    }
    return List.from((res['data'] as List<dynamic>)
        .map((e) => DepositPaymentTypeList.fromJson(e)));
  }

  // 遊戲大廳 取得渠道詳情
  Future<HMApiResponseBaseWithDataWithData<GamePaymentChannelDetail>>
      getDepositPaymentChannelDetail(int paymentChannelId) async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/payment-channel-detail?paymentChannelId=$paymentChannelId');
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    return HMApiResponseBaseWithDataWithData<GamePaymentChannelDetail>(
      code: res['code'],
      data: res['data'] == null
          ? null
          : GamePaymentChannelDetail.fromJson(res['data']),
    );
  }

  // 取得匯率 CNY to USDT
  Future getCNYToUSDTRate() async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform?from=CNY&to=USDT');

    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return [];
    }
    return res['data'];
  }

  // 公司入款訂單建立 存款選擇 selfdebit, selfusdt
  Future<Map> companyOrderDeposit(
    String amount,
    int paymentChannelId,
    String remark,
  ) async {
    try {
      var value = await shared_fetcher.fetcher(
          url:
              '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/company-order-deposit',
          method: 'POST',
          body: {
            'amount': amount,
            'paymentChannelId': paymentChannelId,
            'remark': remark,
          });
      var res = (value.data as Map<String, dynamic>);
      _checkMaintenance(res['code']);

      if (res['code'] != '00') {
        return res['message'];
      }
      return {
        'code': res['code'],
        'data': res['data']['data'],
      };
    } catch (e) {
      return {
        'code': responseController.responseStatus.value,
        'message': responseController.responseMessage.value,
      };
    }
  }

  // 參數配置 > 取得存款金額配置
  Future<List<int>> getAmount() async {
    try {
      var value = await shared_fetcher.fetcher(
          url:
              '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/amount-config');
      var res = value.data as Map<String, dynamic>;
      _checkMaintenance(res['code']);

      if (res['code'] != '00') {
        res['code'];
      }

      var depositAmountString = res['data']['DEPOSIT_AMOUNT'] as String;
      var depositAmountList =
          depositAmountString.split(',').map(int.parse).toList();

      logger.i('depositAmountList: $depositAmountList');
      return depositAmountList;
    } catch (e) {
      logger.i('getAmount error: $e');
      return [];
    }
  }

  // 遊戲大廳 取得存款記錄
  Future<List<GameOrder>> getManyBy({
    int page = 1,
    int limit = 20,
    // required String userId,
    int? paymentStatus = 0,
    int type = 1,
    String? startedAt,
    String? endedAt,
  }) async {
    logger.i('paymentStatus, $paymentStatus');
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/deposit?page=$page&limit=$limit${paymentStatus != null ? '&paymentStatus=$paymentStatus' : ''}${startedAt != null ? '&startedAt=$startedAt' : ''}${endedAt != null ? '&endedAt=$endedAt' : ''}');

    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return [];
    }
    return List.from((res['data']['data'] as List<dynamic>)
        .map((e) => GameOrder.fromJson(e)));
  }

  // 取得提款記錄
  Future<List> getWithdrawalRecord({
    int page = 1,
    int limit = 20,
    int? remittanceType,
    int? status,
    String? startedAt,
    String? endedAt,
  }) {
    String path =
        '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/withdrawal';
    Map qs = <String, dynamic>{};
    if (page != 1) {
      qs['page'] = page;
    }
    if (limit != 20) {
      qs['limit'] = limit;
    }
    if (remittanceType != null) {
      qs['remittanceType'] = remittanceType;
    }
    if (status != null) {
      qs['status'] = status;
    }
    if (startedAt != null) {
      qs['startedAt'] = startedAt;
    }
    if (endedAt != null) {
      qs['endedAt'] = endedAt;
    }
    if (qs.isNotEmpty) {
      path += '?';
      path += qs.entries.map((e) => '${e.key}=${e.value}').join('&');
    }
    return shared_fetcher.fetcher(url: path).then((value) {
      var res = (value.data as Map<String, dynamic>);
      _checkMaintenance(res['code']);

      List<WithdrawalRecord> record = List.from(
          (res['data']['data'] as List<dynamic>)
              .map((e) => WithdrawalRecord.fromJson(e)));
      return record;
    });
  }

  // new version 遊戲大廳 存款申請v2
  Future<String> makeOrderV2({
    String agentAccount = '',
    required String amount,
    required int paymentChannelId,
    String? name,
  }) async {
    var value = await shared_fetcher.fetcher(
      url:
          '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/depositV2',
      method: 'POST',
      body: {
        'amount': amount,
        'paymentChannelId': paymentChannelId,
        'name': name,
      },
    );
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    if (res['code'] != '00') {
      return res['code'];
    }
    return res['data']['paymentLink'];
  }

  // 遊戲大廳 新增資金安全
  Future<HMApiResponse> updatePaymentSecurity(
      String account,
      int remittanceType,
      String bankName,
      String legalName,
      String branchName) async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/paymentSecurity',
        method: 'POST',
        body: {
          'account': account,
          'remittanceType': remittanceType,
          'bankName': bankName,
          'legalName': legalName,
          'branchName': branchName
        });
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    return HMApiResponse.fromJson(res);
  }

  // 遊戲大廳 取得活動列表
  Future<List<ActivityItem>> getActivityList() async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/campaign?page=1&limit=100');
    var res = (value.data as Map<String, dynamic>);
    // _checkIsMaintenance(res['code']);

    if (res['code'] != '00') {
      return [];
    }

    List<ActivityItem> record = List.from((res['data'] as List<dynamic>)
        .map((e) => ActivityItem.fromJson(e))
        .toList());

    return record;
  }

  // 遊戲大廳 申請活動
  Future<Map> submitCampaign(
    int id,
  ) async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/campaign',
        method: 'POST',
        body: {'campaignId': id});
    var res = (value.data as Map<String, dynamic>);

    if (res['code'] != '00') {
      return {
        'code': res['code'],
      };
    }
    return {
      'code': res['code'],
      'message': res['data']['message'],
      'status': res['data']['status'],
    };
  }

  // 取得apk下載位置
  Future getApkPath() async {
    var host = app_platform_service.AppPlatformService().getHost();
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/apk-path?host=$host&device=ANDROID');
    var res = (value.data as Map<String, dynamic>);

    if (res['code'] != '00') {
      return [];
    }
    return res['data'];
  }

  // 取得隨機帳密
  Future getDiversion() async {
    var value = await shared_fetcher.fetcher(
        url:
            '${systemController.apiHost.value}/public/tp-game-platform/tp-game-platform/diversion-update');
    if (value == null) return [];

    var res = (value.data as Map<String, dynamic>);

    if (res['code'] == '00' && res['data'] != null) {
      return res['data'];
    }
  }

  // =================================== 以下 API HOST FROM VIDEO & 沒有使用tp-game-platform prefix =================================== //

  // 銀行卡設置 > 取得銀行列表
  Future<List<BankItem>> getBanks(int remittanceType) => shared_fetcher
          .fetcher(
              url:
                  '${systemController.apiHost.value}/api/v1/third/bank/cards?type=$remittanceType')
          .then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          _checkMaintenance(res['code']);

          if (res['code'] != '00') {
            return [];
          }

          List<BankItem> record = List.from((res['data'] as List<dynamic>)
              .map((e) => BankItem.fromJson(e))
              .toList());

          return record;
        },
      );

  // 註冊綁定手機號 - 請求綁定
  Future<HMApiResponse> registerMobileBinding({
    required String countryCode,
    required String phoneNumber,
  }) async {
    var value = await shared_fetcher.fetcher(
        url: '${systemController.apiHost.value}/api/v1/mobile/binding',
        method: 'POST',
        body: {
          'countryCode': countryCode,
          'phoneNumber': phoneNumber,
        });
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    return HMApiResponse.fromJson(res);
  }

  // 註冊綁定手機號 - 綁定驗證
  Future<HMApiResponse> registerMobileConfirm({
    required String countryCode,
    required String phoneNumber,
    required String otp,
  }) async {
    var value = await shared_fetcher.fetcher(
        url: '${systemController.apiHost.value}/api/v1/mobile/confirm',
        method: 'POST',
        body: {
          'countryCode': countryCode,
          'phoneNumber': phoneNumber,
          'otp': otp,
        });
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    return HMApiResponse.fromJson(res);
  }

  // 註冊綁定身分證 - 用戶KYC申請 / 送出KYC身分證正反面
  Future<HMApiResponse> registerKycApply({
    required String idFront,
    required String idBack,
  }) async {
    var value = await shared_fetcher.fetcher(
        url: '${systemController.apiHost.value}/api/v1/third/user/kyc-apply',
        method: 'POST',
        body: {
          'idFront': idFront,
          'idBack': idBack,
        });
    var res = (value.data as Map<String, dynamic>);
    _checkMaintenance(res['code']);

    return HMApiResponse.fromJson(res);
  }
}
