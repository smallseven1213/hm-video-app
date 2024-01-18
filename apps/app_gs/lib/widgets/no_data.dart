import 'package:app_gs/localization/i18n.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: [
            const Image(
              image: AssetImage('assets/images/list_no_more.webp'),
              width: 48,
              height: 48,
            ),
            Text(I18n.thereIsNothingHere,
                style: TextStyle(color: Colors.white.withOpacity(0.6)))
          ],
        ),
      ),
    );
  }
}
