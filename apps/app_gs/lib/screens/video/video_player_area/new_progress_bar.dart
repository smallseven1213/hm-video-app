import 'package:flutter/material.dart';

class NewProgressBar extends StatefulWidget {
  final String test1;
  final double currentProgress; // Current video progress in seconds
  final double videoDuration; // Total video duration in seconds
  final Function(double) onDragUpdate; // Callback when slider is dragged

  NewProgressBar({
    required this.test1,
    required this.currentProgress,
    required this.videoDuration,
    required this.onDragUpdate,
  });

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<NewProgressBar> {
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.currentProgress / widget.videoDuration;
  }

  @override
  void didUpdateWidget(NewProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sliderValue = widget.currentProgress / widget.videoDuration;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.blue,
        inactiveTrackColor: Colors.blue.withOpacity(0.5),
        trackShape: const RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbColor: Colors.transparent,
        thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: 0.0), // Remove the thumb
        overlayColor: Colors.blue,
        overlayShape: const RoundSliderOverlayShape(
            overlayRadius: 0.0), // Remove the overlay
      ),
      child: Slider(
        value: _sliderValue,
        onChanged: (value) {
          setState(() {
            _sliderValue = value;
            widget.onDragUpdate(
                value * widget.videoDuration); // Call the provided callback
          });
        },
      ),
    );
  }
}
