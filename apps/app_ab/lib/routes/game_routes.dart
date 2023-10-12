library game_routes;

import 'package:app_ab/screens/games/game_activity.dart';
import 'package:app_ab/screens/games/game_lobby.dart';
import 'package:app_ab/screens/games/game_webview.dart';
import 'package:app_ab/screens/games/game_withdraw.dart';
import 'package:app_ab/screens/games/game_set_fundpassword.dart';
import 'package:app_ab/screens/games/game_set_bankcard.dart';
import 'package:app_ab/screens/games/game_deposit_list.dart';
import 'package:app_ab/screens/games/game_deposit_polling.dart';
import 'package:app_ab/screens/games/game_deposit_detail.dart';
import 'package:app_ab/screens/games/game_payment_result.dart';
import 'package:app_ab/screens/games/game_deposit_record.dart';
import 'package:app_ab/screens/games/game_withdraw_record.dart';
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
  GameAppRoutes.activity.value: (context, args) => const GameActivityScreen(),
};
