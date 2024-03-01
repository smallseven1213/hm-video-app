import 'package:flutter/material.dart';

class NoMoreWidget extends StatefulWidget {
  const NoMoreWidget({Key? key}) : super(key: key);

  @override
  _NoMoreWidgetState createState() => _NoMoreWidgetState();
}

class _NoMoreWidgetState extends State<NoMoreWidget> {
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // 收起动画持续时间为1秒
      height: _height, // 动态高度
      child: const Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Center(
          child: Text(
            '沒有更多了',
            style: TextStyle(
              color: Color(0xff7b7b7b),
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
