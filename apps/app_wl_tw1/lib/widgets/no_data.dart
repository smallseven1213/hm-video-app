import 'package:app_wl_tw1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/list_no_more.webp'),
              width: 80,
              height: 106,
            ),
            const SizedBox(height: 18),
            Text('這裡什麼都沒有',
                style: TextStyle(color: AppColors.colors[ColorKeys.menuColor]))
          ],
        ),
      ),
    );
  }
}
