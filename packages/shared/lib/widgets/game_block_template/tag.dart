import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../enums/app_routes.dart';
import '../../models/tag.dart';
import '../../navigator/delegate.dart';

const kTagColor = Color(0xff21488E);
const kTagTextColor = Color(0xff21AFFF);

class TagWidget extends StatelessWidget {
  final Tag tag;

  const TagWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyRouteDelegate.of(context).push(
          AppRoutes.tagGames,
          args: {
            'tag': tag.name,
          },
        );
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
              color: kTagColor,
              borderRadius:
                  kIsWeb ? BorderRadius.zero : BorderRadius.circular(10)),
          child: Text(
            tag.name,
            style: const TextStyle(
              color: kTagTextColor,
              fontSize: 10,
              height: 1.4,
            ),
          )),
    );
  }
}
