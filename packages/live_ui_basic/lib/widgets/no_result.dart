import 'package:flutter/material.dart';

import '../localization/live_localization_delegate.dart';

class NoResult extends StatelessWidget {
  const NoResult({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(height: 100),
        const Image(
          image: AssetImage('assets/images/ic_noresult.webp'),
          width: 48,
          height: 48,
        ),
        const SizedBox(height: 8),
        Text(
          localizations.translate('there_is_nothing_here'),
          style: const TextStyle(color: Color(0xff6f6f79)),
        ),
      ],
    );
  }
}
