import 'package:flutter/material.dart';

import '../../localization/game_localization_delegate.dart';

class PaymentDetailTips extends StatelessWidget {
  const PaymentDetailTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                'please_be_sure_to_provide_true_information_to_facilitate_the_verification_of_the_transfer_data'),
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
                'please_write_the_required_information_in_the_remittance_remarks_to_speed_up_the_recharge_process'),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
            ),
            maxLines: 2,
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    );
  }
}
