import 'package:flutter/material.dart';

import '../../localization/game_localization_delegate.dart';

class Tips extends StatelessWidget {
  const Tips({super.key});

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations.translate('warm_tips'),
            style: const TextStyle(
              color: Color(0xff999999),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            localizations.translate(
                'payment_was_not_successful_please_try_to_pay_several_times'),
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
            localizations.translate(
                'can_not_pull_up_the_payment_order_is_due_to_pull_up_the_order_more_people_please_try_to_pull_up_the_payment_several_times'),
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
            localizations.translate(
                'please_contact_our_online_customer_service_if_the_recharge_is_successful_but_not_arrived'),
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
