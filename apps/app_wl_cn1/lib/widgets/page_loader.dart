import 'package:flutter/widgets.dart';

import 'flash_loading.dart';

class PageLoadingEffect extends StatelessWidget {
  const PageLoadingEffect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FlashLoading(),
    );
  }
}
