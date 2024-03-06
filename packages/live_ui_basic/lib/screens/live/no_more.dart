import 'package:flutter/material.dart';
import '../../localization/live_localization_delegate.dart';

class NoMoreWidget extends StatefulWidget {
  const NoMoreWidget({Key? key}) : super(key: key);

  @override
  NoMoreWidgetState createState() => NoMoreWidgetState();
}

class NoMoreWidgetState extends State<NoMoreWidget> {
  double _height = 60.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _height = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // 收起动画持续时间为1秒
      height: _height, // 动态高度
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(
          child: Text(
            localizations.translate('no_more'),
            style: const TextStyle(
              color: Color(0xff7b7b7b),
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
