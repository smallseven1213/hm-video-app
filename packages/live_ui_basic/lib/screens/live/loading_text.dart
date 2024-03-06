import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';

import '../../localization/live_localization_delegate.dart';

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
  }

  @override
  void didUpdateWidget(LoadingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateLoadingText();
  }

  void _updateLoadingText() {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;
    final List<String> loadingTextList = [
      localizations.translate('the_file_is_large_please_wait'),
      localizations.translate('its_not_ready_yet_please_take_your_time'),
      localizations.translate('exciting_moments_are_coming_soon'),
      localizations.translate('loading'),
      localizations.translate('let_the_file_load_for_a_while'),
      localizations.translate('good_things_are_worth_the_wait'),
      localizations.translate('working_hard'),
    ];
    setState(() {
      text = loadingTextList[rng.nextInt(loadingTextList.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
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
            height: 8), // Add some space between the icon and the text
        Text(
          text,
          style: const TextStyle(
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
  LoadingTextWidgetState createState() => LoadingTextWidgetState();
}

class LoadingTextWidgetState extends State<LoadingTextWidget> {
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
