import 'package:flutter/material.dart';
import 'package:shared/localization/shared_localization_delegate.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

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
            Text(localizations.translate('nothing_here'),
                style: const TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}
