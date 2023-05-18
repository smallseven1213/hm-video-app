import 'dart:io';

import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get_storage/get_storage.dart';
import 'package:game/models/bank.dart';
import 'package:game/models/game_list.dart';
import 'package:game/models/game_order.dart';
import 'package:game/models/game_payment.dart';
import 'package:game/models/hm_api_response.dart';
import 'package:game/models/hm_api_response_with_data.dart';
import 'package:game/models/user_withdrawal_data.dart';
import 'package:game/models/game_withdraw_record.dart';
import 'package:game/models/game_withdraw_stack_limit.dart';
import 'package:game/services/game_system_config.dart';
import 'package:game/utils/fetcher.dart';

final systemConfig = GameSystemConfig();
String apiPrefix =
    '${systemConfig.apiHost}/public/tp-game-platform/tp-game-platform';

class GameLobbyApi {
  Future<void> register() =>
      fetcher(url: '$apiPrefix/register', method: 'POST', body: {});

  //取得遊戲清單
  Future<List<GameItem>> getGameList() => fetcher(url: '$apiPrefix/game').then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          if (res['code'] != '00') {
            return [];
          }

          return List.from(res['data'] as List<dynamic>)
              .map((e) => GameItem.fromJson(e))
              .toList();
        },
      );

  Future enterGame(String tpCode, int gameId) async {
    var value =
        await fetcher(url: '$apiPrefix/enter-game', method: 'POST', body: {
      'tpCode': tpCode,
      'gameId': gameId,
      'device': GetPlatform.isWeb
          ? 1
          : Platform.isAndroid
              ? 3
              : 2
    });

    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return [];
    }
    return res['data'];
  }

  // 初次進入遊戲大廳
  Future registerGame() async {
    GetStorage box = GetStorage();
    if (box.hasData('register-game')) return;
    var value =
        await fetcher(url: '$apiPrefix/register', method: 'POST', body: {});
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] == '00') {
      box.write('register-game', true);
    }

    print('registerGame: $res');
    return res['data'];
  }

  // 取得遊戲大廳跑馬燈&輪播圖banner
  Future getMarqueeAndBanner() =>
      fetcher(url: '$apiPrefix/marquee-and-banner').then((value) {
        var res = (value.data as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        if (res['data'] != null) {
          return res['data'];
        }
      });

  Future<List<GameItem>> getGames() =>
      fetcher(url: '$apiPrefix/game?tpCode=wali').then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          if (res['code'] != '00') {
            return [];
          }

          List<GameItem> record = List.from(
              (res['data'] as List<dynamic>).map((e) => GameItem.fromJson(e)));

          return record;
        },
      );

  Future getPoints() => fetcher(url: '$apiPrefix/points').then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          if (res['code'] != '00') {
            return [];
          }

          return res['data'];
        },
      );

  // 金幣轉帳, post to /tp-game-platform/transfer, data會有tpCode, type, applyAmount 三個值

  Future transfer(
    int type,
    double? amount,
    String tpCode,
  ) =>
      fetcher(url: '$apiPrefix/transfer', method: 'POST', body: {
        'tpCode': tpCode,
        'type': type,
        // 'applyAmount': amount.toString()
      }).then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          if (res['code'] != '00') {
            return res;
          }

          return res;
        },
      );

  // 銀行卡設置 > 取得銀行列表
  Future<List<BankItem>> getBanks() => fetcher(url: '$apiPrefix/bank').then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          if (res['code'] != '00') {
            return [];
          }

          List<BankItem> record = List.from((res['data'] as List<dynamic>)
              .map((e) => BankItem.fromJson(e))
              .toList());

          return record;
        },
      );

  // 遊戲大廳 取得用戶遊戲提現詳情
  // 是否設置銀行卡
  // 是否設置資金密碼
  Future<Map> getUserGameWithdrawalData() async {
    var value = await fetcher(url: '$apiPrefix/gameWithdrawal');
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return res;
    }
    return {
      "code": "00",
      "data": UserWithdrawalData.fromJson(res['data']),
    };
  }

  // 檢查資金密碼，使用get call user/paymentPin?paymentPin=, function會將paymentPin帶入
  Future<HMApiResponseBaseWithDataWithData<bool>> checkPaymentPin(
      String paymentPin) async {
    var value =
        await fetcher(url: '$apiPrefix/paymentPin?paymentPin=$paymentPin');
    var res = (value.data as Map<String, dynamic>);

    return HMApiResponseBaseWithDataWithData<bool>.fromJson(res);
  }

  // 更新資金密碼
  Future<void> updatePaymentPin(String paymentPin) async {
    var value = await fetcher(
        url: '$apiPrefix/paymentPin',
        method: 'PUT',
        body: {'paymentPin': paymentPin});
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      throw Exception(res['message']);
    }
  }

  // 取得用戶流水
  Future<HMApiResponseBaseWithDataWithData<GameWithdrawStackLimit>>
      getStackLimit() async {
    var value = await fetcher(url: '$apiPrefix/stack-limit');
    var res = (value.data as Map<String, dynamic>);

    var stackLimitData = res['data'] == null
        ? null
        : GameWithdrawStackLimit.fromJson(res['data']);

    return HMApiResponseBaseWithDataWithData<GameWithdrawStackLimit>(
      code: res['code'],
      data: stackLimitData,
    );
  }

  // 取得遊戲設置config
  Future<GameConfig> getGameConfig() => fetcher(
              url:
                  '${systemConfig.apiHost}/public/game-platform-config/game-platform-config')
          .then(
        (value) {
          var res = (value.data as Map<String, dynamic>);
          if (res['code'] != '00') {
            return GameConfig(false, false, 1, 1);
          }

          return GameConfig.fromJson(res['data'] as Map<String, dynamic>);
        },
      );

  // 取得參數設定
  Future<HMApiResponseBaseWithDataWithData<GameParamConfig>>
      getGameParamConfig() async {
    var value = await fetcher(url: '$apiPrefix/parameter-config');
    var res = (value.data as Map<String, dynamic>);

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
    var value =
        await fetcher(url: '$apiPrefix/withdrawalV2', method: 'POST', body: {
      'remittanceType': remittanceType,
      'applyAmount': applyAmount,
      'paymentPin': paymentPin,
      'stakeLimit': stakeLimit,
      'validAmount': validStake,
    });
    var res = (value.data as Map<String, dynamic>);

    return HMApiResponse.fromJson(res);
  }

// 遊戲大廳 取得支付渠道
  Future<List<Payment>> getPaymentsBy(int productId, String amount) => fetcher(
              url:
                  '$apiPrefix/payment-channel?productId=$productId&deviceType=${GetPlatform.isWeb ? 1 : Platform.isAndroid ? 2 : 3}&amount=$amount')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        return List.from(
            (res['data'] as List<dynamic>).map((e) => Payment.fromJson(e)));
      });

  // new version 遊戲大廳 取得支付渠道
  Future<Map> getDepositChannel() async {
    var value = await fetcher(
        url:
            '$apiPrefix/deposit-channel?deviceType=${GetPlatform.isWeb ? 1 : Platform.isAndroid ? 2 : 3}');
    var res = (value.data as Map<String, dynamic>);
    if (res['code'] != '00') {
      return res;
    }
    return res['data'];
  }

  Future<List<Product>> getProductManyBy(
          {int type = 1, int page = 1, int limit = 100}) =>
      fetcher(
              url:
                  '${systemConfig.apiHost}/public/product/list?page=$page&limit=$limit&type=$type')
          .then((value) {
        var res = (value.data as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        return List.from((res['data']['data'] as List<dynamic>)
            .map((e) => Product.fromJson(e)));
      });

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
    print('paymentStatus, $paymentStatus');
    var value = await fetcher(
        url:
            '$apiPrefix/deposit?page=$page&limit=$limit${paymentStatus != null ? '&paymentStatus=$paymentStatus' : ''}${startedAt != null ? '&startedAt=$startedAt' : ''}${endedAt != null ? '&endedAt=$endedAt' : ''}');

    var res = (value.data as Map<String, dynamic>);

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
    String path = '$apiPrefix/withdrawal';
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
    return fetcher(url: path).then((value) {
      var res = (value.data as Map<String, dynamic>);
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
    var value = await fetcher(
      url: '$apiPrefix/depositV2',
      method: 'POST',
      body: {
        'amount': amount,
        'paymentChannelId': paymentChannelId,
        'name': name,
      },
    );
    var res = (value.data as Map<String, dynamic>);
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
    var value =
        await fetcher(url: '$apiPrefix/paymentSecurity', method: 'POST', body: {
      'account': account,
      'remittanceType': remittanceType,
      'bankName': bankName,
      'legalName': legalName,
      'branchName': branchName
    });
    var res = (value.data as Map<String, dynamic>);

    return HMApiResponse.fromJson(res);
  }
}
