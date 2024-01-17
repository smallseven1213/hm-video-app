import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum LottieDataProvider { network, asset }

class LottieDialog extends StatefulWidget {
  final String path;
  final LottieDataProvider provider;

  const LottieDialog({
    Key? key,
    required this.path,
    required this.provider,
  }) : super(key: key);

  @override
  LottieDialogState createState() => LottieDialogState();
}

class LottieDialogState extends State<LottieDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          Navigator.of(context).pop();
        }
      });
  }

  @override
  void dispose() {
    _lottieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogBackgroundColor: Colors.transparent,
        dialogTheme: const DialogTheme(elevation: 0),
      ),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Lottie.network(
          widget.path,
          controller: _lottieController,
          onLoaded: (composition) {
            _lottieController!
              ..duration = composition.duration
              ..forward();
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Lottie.asset(
              'packages/live_ui_basic/assets/lotties/present.json',
              controller: _lottieController,
              onLoaded: (composition) {
                _lottieController!
                  ..duration = composition.duration
                  ..forward();
              },
            );
          },
        ),
      ),
    );
  }
}
