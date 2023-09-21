import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: const BoxDecoration(color: Color(0xff3A5A69)),
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xffffffff),
          ),
        ),
      ),
    );
  }
}
