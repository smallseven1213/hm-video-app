import 'package:flutter/material.dart';

class PaymentDetailTips extends StatelessWidget {
  const PaymentDetailTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
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
          Text(
            '1. 請務必提供真實資訊，以利核對轉帳資料。',
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
            '2. 請在匯款備註寫入要求資訊，加速充值流程。',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
          SizedBox(
            height: 3,
          ),
        ],
      ),
    );
  }
}
