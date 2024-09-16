import 'package:flutter/material.dart';
import 'package:shared/utils/handle_url.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 使用 WidgetsBinding 確保轉址在頁面構建後執行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const url = "/home?defaultScreenKey=game&depositType=1";
      handleGameDepositType(
        context,
        url,
      );
    });

    return const SizedBox();
  }
}
