library game_routes;

import 'package:game/enums/game_app_routes.dart';
import 'package:game/screens/game_activity_screen/index.dart';
import 'package:shared/navigator/delegate.dart';

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
  GameAppRoutes.lobby.value: (context, args) => const GameLobby(),
  GameAppRoutes.webview.value: (context, args) => GameLobbyWebview(
        gameUrl: args['url'] as String,
        direction: args['direction'] as int,
      ),
  GameAppRoutes.depositList.value: (context, args) => const GameDepositList(),
  GameAppRoutes.depositPolling.value: (context, args) =>
      const GameDepositPolling(),
  GameAppRoutes.depositDetail.value: (context, args) => GameDepositDetail(
        payment: args['payment'] as String,
        paymentChannelId: args['paymentChannelId'] as int,
      ),
  GameAppRoutes.withdraw.value: (context, args) => const GameWithdraw(),
  GameAppRoutes.setFundPassword.value: (context, args) =>
      const GameSetFundPassword(),
  GameAppRoutes.setBankcard.value: (context, args) => const GameSetBankCard(),
  GameAppRoutes.paymentResult.value: (context, args) =>
      const GamePaymentResult(),
  GameAppRoutes.depositRecord.value: (context, args) =>
      const GameDepositRecord(),
  GameAppRoutes.withdrawRecord.value: (context, args) =>
      const GameWithdrawRecord(),
  GameAppRoutes.activity.value: (context, args) => const GameActivity(),
};
