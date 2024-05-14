library game_routes;

import 'package:game/enums/game_app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../screens/game_register_id_card_binding_screen/index.dart';
import '../screens/game_register_mobile_confirm_screen/index.dart';
import '../screens/game_register_mobile_binding_screen/index.dart';
import '../screens/game_activity_screen/index.dart';
import '../screens/game_deposit_detail_screen/index.dart';
import '../screens/game_deposit_list_screen/index.dart';
import '../screens/game_deposit_polling_screen/index.dart';
import '../screens/game_deposit_record_screen/index.dart';
import '../screens/game_payment_result_screen/index.dart';
import '../screens/game_set_bankcard_screen/index.dart';
import '../screens/game_set_fundpassword_screen/index.dart';
import '../screens/game_webview_screen/index.dart';
import '../screens/game_withdraw_record_screen/index.dart';
import '../screens/game_withdraw_screen/index.dart';
import '../screens/lobby.dart';

final Map<String, RouteWidgetBuilder> gameRoutes = {
  GameAppRoutes.lobby: (context, args) => const GameLobby(),
  GameAppRoutes.webview: (context, args) => GameLobbyWebview(
        gameUrl: args['url'] as String,
        direction: args['direction'] as int,
      ),
  GameAppRoutes.depositList: (context, args) => const GameDepositList(),
  GameAppRoutes.depositPolling: (context, args) => const GameDepositPolling(),
  GameAppRoutes.depositDetail: (context, args) => GameDepositDetail(
        payment: args['payment'] as String,
        paymentChannelId: args['paymentChannelId'] as int,
      ),
  GameAppRoutes.withdraw: (context, args) => const GameWithdraw(),
  GameAppRoutes.setFundPassword: (context, args) => const GameSetFundPassword(),
  GameAppRoutes.setBankcard: (context, args) => GameSetBankCard(
        remittanceType: args['remittanceType'] as int,
      ),
  GameAppRoutes.paymentResult: (context, args) => const GamePaymentResult(),
  GameAppRoutes.depositRecord: (context, args) => const GameDepositRecord(),
  GameAppRoutes.withdrawRecord: (context, args) => const GameWithdrawRecord(),
  GameAppRoutes.activity: (context, args) => GameActivity(
        id: args['id'] as int?,
      ),
  GameAppRoutes.registerMobileBinding: (context, args) =>
      const GameRegisterMobileBinding(),
  GameAppRoutes.registerMobileConfirm: (context, args) =>
      GameRegisterMobileConfirm(
        parsePhoneNumber: args['parsePhoneNumber'] as String,
      ),
  GameAppRoutes.registerIdCardBinding: (context, args) =>
      const GameRegisterIdCardBinding(),
};
