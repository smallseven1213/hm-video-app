import 'dart:async';
import 'package:flutter/material.dart';

import '../../localization/live_localization_delegate.dart';

Widget _buildLabel({
  required Color color,
  required String text,
  Icon? icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
    child: icon == null
        ? Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 9),
          )
        : RichText(
            text: TextSpan(
              children: [
                WidgetSpan(child: icon),
                TextSpan(
                  text: text,
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ],
            ),
          ),
  );
}

class CountdownTimer extends StatefulWidget {
  final String reserveAt;
  final int chargeType;

  const CountdownTimer({
    Key? key,
    required this.reserveAt,
    required this.chargeType,
  }) : super(key: key);

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (widget.reserveAt.isEmpty) return;

    final endTime = DateTime.parse(widget.reserveAt);

    if (endTime.isBefore(DateTime.now())) {
      final currentTime = DateTime.now();
      setState(() {
        _timeLeft = endTime.difference(currentTime);
      });
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final currentTime = DateTime.now();

        setState(() {
          _timeLeft = endTime.difference(currentTime);
          if (_timeLeft.isNegative) {
            _timer?.cancel();
          }
        });
      });
    }
  }

  formatTime(Duration duration) {
    if (widget.reserveAt.isEmpty) return " --:--:--";
    return " ${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;
    return _buildLabel(
      color: const Color(0xffe6cf795f),
      text: _timeLeft.isNegative
          ? localizations.translate('preview')
          : formatTime(_timeLeft),
      icon: const Icon(Icons.access_time, size: 12, color: Colors.white),
    );
  }
}
