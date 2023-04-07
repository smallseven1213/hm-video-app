import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';

class TagItem extends StatelessWidget {
  final String tag;

  TagItem({Key? key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyRouteDelegate.of(context).push('/search_result', args: {
          'keyword': tag,
        });
      },
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
