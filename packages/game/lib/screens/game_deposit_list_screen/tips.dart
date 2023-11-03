import 'package:flutter/material.dart';

class Tips extends StatelessWidget {
  const Tips({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width is 100%
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '溫馨提示',
            style: TextStyle(
              color: Color(0xff999999),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          const Text(
            '1：支付不成功，請多次嘗試支付。',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
          SizedBox(
            height: 3,
          ),
          const Text(
            '2：無法拉起支付訂單，是由於拉起訂單人數較多，請多次嘗試拉起支付。',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
          SizedBox(
            height: 3,
          ),
          const Text(
            '3：充值成功未到賬，請聯繫在線客服。',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
