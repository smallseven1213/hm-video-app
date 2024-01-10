import 'dart:async';
import 'package:flutter/material.dart';
import 'package:live_core/models/room.dart';

Widget _buildLabel({
  required Color color,
  required String text,
  Icon? icon,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
    child: icon == null
        ? Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 9),
          )
        : RichText(
            text: TextSpan(
              children: [
                WidgetSpan(child: icon),
                TextSpan(
                  text: text,
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
              ],
            ),
          ),
  );
}

class CountdownTimer extends StatefulWidget {
  final String reserveAt;
  final int chargeType;

  CountdownTimer({
    Key? key,
    required this.reserveAt,
    required this.chargeType,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
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
    print('@_timeLeft: $_timeLeft');
    return _timeLeft.isNegative
        ? _buildLabel(
            color: widget.chargeType == RoomChargeType.free.index
                ? const Color(0xffe65fcf95)
                : const Color(0xffe6845fcf),
            text: widget.chargeType == RoomChargeType.free.index ? '免費' : '付費',
          )
        : _buildLabel(
            color: const Color(0xffe6cf795f),
            text: formatTime(_timeLeft),
            icon: Icon(Icons.access_time, size: 12, color: Colors.white),
          );
  }
}
