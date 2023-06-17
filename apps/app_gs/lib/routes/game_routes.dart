library game_routes;

import 'package:app_gs/screens/games/game_lobby_screen/lobby.dart';
import 'package:app_gs/screens/games/game_webview_screen/index.dart';
import 'package:app_gs/screens/games/game_withdraw_screen/index.dart';
import 'package:app_gs/screens/games/game_set_fundpassword_screen/index.dart';
import 'package:app_gs/screens/games/game_set_bankcard_screen/index.dart';
import 'package:app_gs/screens/games/game_deposit_list_screen/index.dart';
import 'package:app_gs/screens/games/game_deposit_polling_screen/index.dart';
import 'package:app_gs/screens/games/game_deposit_detail_screen/index.dart';
import 'package:app_gs/screens/games/game_payment_result_screen/index.dart';
import 'package:app_gs/screens/games/game_deposit_record_screen/index.dart';
import 'package:app_gs/screens/games/game_withdraw_record_screen/index.dart';
import 'package:game/enums/game_app_routes.dart';
import 'package:shared/navigator/delegate.dart';

final Map<String, RouteWidgetBuilder> gameRoutes = {
  GameAppRoutes.lobby.value: (context, args) => const GameScreen(),
  GameAppRoutes.webview.value: (context, args) => GameWebviewScreen(
        gameUrl: args['url'] as String,
        direction: args['direction'] as int,
      ),
  GameAppRoutes.depositList.value: (context, args) =>
      const GameDepositListScreen(),
  GameAppRoutes.depositPolling.value: (context, args) =>
      const GameDepositPollingScreen(),
  GameAppRoutes.depositDetail.value: (context, args) => GameDepositDetailScreen(
        payment: args['payment'] as String,
        paymentChannelId: args['paymentChannelId'] as int,
      ),
  GameAppRoutes.withdraw.value: (context, args) => const GameWithdrawScreen(),
  GameAppRoutes.setFundPassword.value: (context, args) =>
      const GameSetFundPasswordScreen(),
  GameAppRoutes.setBankcard.value: (context, args) =>
      const GameSetBankCardScreen(),
  GameAppRoutes.paymentResult.value: (context, args) =>
      const GamePaymentResultScreen(),
  GameAppRoutes.depositRecord.value: (context, args) =>
      const GameDepositRecordScreen(),
  GameAppRoutes.withdrawRecord.value: (context, args) =>
      const GameWithdrawRecordScreen(),
};
