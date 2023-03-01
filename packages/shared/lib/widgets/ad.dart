import 'package:flutter/material.dart';

class Ad extends StatelessWidget {
  // onNext
  final void Function() onNext;

  const Ad({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: // button ,and click it will call onNext
            TextButton(
                onPressed: () {
                  onNext();
                },
                child: const Text('go to home')),
      ),
    );
  }
}
