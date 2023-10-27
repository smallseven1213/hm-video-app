library game_routes;

import 'package:game/enums/game_app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../screens/games/game_lobby.dart';
import '../screens/games/game_payment_result.dart';
import '../screens/games/game_set_bankcard.dart';
import '../screens/games/game_set_fundpassword.dart';
import '../screens/games/game_webview.dart';
import '../screens/games/game_withdraw.dart';
import '../screens/games/game_withdraw_record.dart';
import '../screens/games/game_deposit_detail.dart';
import '../screens/games/game_deposit_list.dart';
import '../screens/games/game_deposit_polling.dart';
import '../screens/games/game_deposit_record.dart';
import '../screens/games/game_activity.dart';

final Map<String, RouteWidgetBuilder> gameRoutes = {
  GameAppRoutes.lobby: (context, args) => const GameScreen(),
  GameAppRoutes.webview: (context, args) => GameWebviewScreen(
        gameUrl: args['url'] as String,
        direction: args['direction'] as int,
      ),
  GameAppRoutes.depositList: (context, args) => const GameDepositListScreen(),
  GameAppRoutes.depositPolling: (context, args) =>
      const GameDepositPollingScreen(),
  GameAppRoutes.depositDetail: (context, args) => GameDepositDetailScreen(
        payment: args['payment'] as String,
        paymentChannelId: args['paymentChannelId'] as int,
      ),
  GameAppRoutes.withdraw: (context, args) => const GameWithdrawScreen(),
  GameAppRoutes.setFundPassword: (context, args) =>
      const GameSetFundPasswordScreen(),
  GameAppRoutes.setBankcard: (context, args) => const GameSetBankCardScreen(),
  GameAppRoutes.paymentResult: (context, args) =>
      const GamePaymentResultScreen(),
  GameAppRoutes.depositRecord: (context, args) =>
      const GameDepositRecordScreen(),
  GameAppRoutes.withdrawRecord: (context, args) =>
      const GameWithdrawRecordScreen(),
  GameAppRoutes.activity: (context, args) => GameActivityScreen(
        id: args['id'] as int,
      ),
};
