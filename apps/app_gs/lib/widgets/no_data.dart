import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../config/colors.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Image(
          //   image: AssetImage('assets/images/no_data.png'),
          //   width: 100.0,
          //   height: 100.0,
          // ),
          const SizedBox(height: 20),
          Text(
            'No Data',
            style: TextStyle(
              color: AppColors.colors[ColorKeys.textPrimary],
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
