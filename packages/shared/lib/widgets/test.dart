// TestPage, has appbar , and "test" texgt in the center

import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: const Center(
        child: Text("test"),
      ),
    );
  }
}
