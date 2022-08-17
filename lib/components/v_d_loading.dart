import 'package:flutter/material.dart';

class VDLoading extends StatelessWidget {
  const VDLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
