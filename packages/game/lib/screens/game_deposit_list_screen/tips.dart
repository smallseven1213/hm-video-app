import 'package:flutter/material.dart';

class Tips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width is 100%
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            '溫馨提示',
            style: TextStyle(
              color: Color(0xff999999),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
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
          Text(
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
          Text(
            '3：充值成功 VIP 未到賬，請聯繫在線客服。',
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
