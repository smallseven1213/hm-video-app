import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';

class TagItem extends StatelessWidget {
  final VoidCallback onTap;
  final String tag;

  const TagItem({Key? key, required this.tag, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xff4277DC).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
