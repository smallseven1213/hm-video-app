import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/widgets.dart';

class PageLoadingEffect extends StatelessWidget {
  const PageLoadingEffect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(I18n.loadingNow),
    );
  }
}
