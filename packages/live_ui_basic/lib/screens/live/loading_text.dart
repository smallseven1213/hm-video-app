import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';

final List<String> loadingTextList = [
  '檔案很大，你忍一下',
  '還沒準備好，你先悠著來',
  '精彩即將呈現',
  '努力加載中',
  '讓檔案載一會兒',
  '美好事物，值得等待',
  '拼命搬磚中',
];

class LoadingText extends StatefulWidget {
  const LoadingText({Key? key}) : super(key: key);

  @override
  LoadingTextState createState() => LoadingTextState();
}

class LoadingTextState extends State<LoadingText> {
  var rng = Random();
  var text = '';

  @override
  void initState() {
    super.initState();
    _updateLoadingText();
  }

  @override
  void didUpdateWidget(LoadingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLoadingText();
  }

  void _updateLoadingText() {
    setState(() {
      text = loadingTextList[rng.nextInt(loadingTextList.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 15.0,
          width: 15.0,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
            width: 8), // Add some space between the icon and the text
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class LoadingTextWidget extends StatefulWidget {
  const LoadingTextWidget({Key? key}) : super(key: key);

  @override
  _LoadingTextWidgetState createState() => _LoadingTextWidgetState();
}

class _LoadingTextWidgetState extends State<LoadingTextWidget> {
  // 修改這裡
  final LiveListController _controller = Get.find<LiveListController>();

  @override
  void dispose() {
    _controller.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Obx(() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: _controller.isLoading.value
            ? const LoadingText()
            : const SizedBox.shrink(),
      );
    }));
  }
}
