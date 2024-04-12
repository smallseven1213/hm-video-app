import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const kTagColor = Color(0xff21488E);
const kTagTextColor = Color(0xff21AFFF);

class TagWidget extends StatelessWidget {
  final String name;

  TagWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
              color: kTagColor,
              borderRadius:
                  kIsWeb ? BorderRadius.zero : BorderRadius.circular(10)),
          child: Text(
            name,
            style: const TextStyle(
              color: kTagTextColor,
              fontSize: 10,
              height: 1.4,
            ),
          )),
    );
  }
}
