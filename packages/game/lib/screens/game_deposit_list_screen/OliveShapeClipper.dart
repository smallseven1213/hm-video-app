import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OliveShape extends StatelessWidget {
  const OliveShape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 25,
        height: 25,
        color: const Color(0xfffd5900),
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Text(
          '推',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: GetPlatform.isWeb ? FontWeight.normal : FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
