import 'package:app_51ss/widgets/countdown.dart';
import 'package:app_51ss/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart'; // 如果需要管理色碼的話，使用這個
import 'package:shared/utils/running_main.dart'; // 啟動專案必須要引用shared的runningMain
import 'config/colors.dart';

// 以下自行決定App要什麼路由，路由的key管理則是統一放在shared中
// 如果此App沒有遊戲，那就不需要寫入game_routes
import './routes/app_routes.dart' as app_routes;
// import './routes/game_routes.dart' as game_routes;

const env = String.fromEnvironment('ENV', defaultValue: 'prod');

void main() async {
  final allRoutes = {
    ...app_routes.appRoutes,
    // ...game_routes.gameRoutes,
  };

  runningMain(
    // [非必填]SentryDNS
    'https://ede485f417b04ffe9d9632e2cdd2361b@sentry.hmtech.club/4',
    // [非必填]進入的第一個畫面
    allRoutes.keys.first,
    // [必填]DlJSON來源
    [
      // 'https://dl.122349323.store/$env/dl.json',
      // 'https://dl.dl51ss.com/$env/dl.json',
      // 'https://dl.dl51ss.net/$env/dl.json',
      //先使用sv的配置
      'https://dl.dlsv.net/$env/dl.json',
      'https://dl.dlsv.app/$env/dl.json'
    ],
    allRoutes,
    AppColors.colors,
    ({String? text}) => Loading(loadingText: text ?? '正在加载...'),
    ThemeData(
        scaffoldBackgroundColor: AppColors.colors[ColorKeys.background],
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent),
    ({int countdownSeconds = 5}) =>
        Countdown(countdownSeconds: countdownSeconds),
  );
}
