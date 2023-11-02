import 'package:flutter/material.dart';

import '../../localization/i18n.dart';

class Tips extends StatelessWidget {
  const Tips({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width is 100%
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            I18n.warmTips,
            style: const TextStyle(
              color: Color(0xff999999),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            I18n.paymentWasNotSuccessfulPleaseTryToPaySeveralTimes,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            I18n.canNotPullUpThePaymentOrderIsDueToPullUpTheOrderMorePeoplePleaseTryToPullUpThePaymentSeveralTimes,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            I18n.pleaseContactOurOnlineCustomerServiceIfTheRechargeIsSuccessfulButNotArrived,
            style: const TextStyle(
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
