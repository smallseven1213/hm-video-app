import 'package:flutter/material.dart';

class BannersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Set the height you want
      child: PageView(
        children: [
          // Replace with your actual banner widgets
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue),
        ],
      ),
    );
  }
}
