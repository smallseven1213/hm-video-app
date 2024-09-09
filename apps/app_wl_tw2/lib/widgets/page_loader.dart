import 'package:app_wl_tw2/widgets/flash_loading.dart';
import 'package:flutter/widgets.dart';

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
