import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  double _value = 0;
  Duration _duration = const Duration(seconds: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Slider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Slider(
              value: _value,
              onChanged: (double value) {
                setState(() {
                  _value = value;
                  _duration = Duration(seconds: value.toInt());
                });
              },
              min: 0,
              max: 86399, // 23:59:59 in seconds
              divisions: 86399,
              label:
                  '${_duration.inHours.toString().padLeft(2, '0')}:${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 24),
            Text(
              'Slider Value in Seconds: ${_duration.inSeconds}',
            ),
          ],
        ),
      ),
    );
  }
}
