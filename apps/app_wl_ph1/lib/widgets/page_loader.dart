import 'package:flutter/widgets.dart';

import 'wave_loading.dart';

class PageLoadingEffect extends StatelessWidget {
  const PageLoadingEffect({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: WaveLoading(
        color: Color.fromRGBO(255, 255, 255, 0.3),
        duration: Duration(milliseconds: 1000),
        size: 17,
        itemCount: 3,
      ),
    );
  }
}
