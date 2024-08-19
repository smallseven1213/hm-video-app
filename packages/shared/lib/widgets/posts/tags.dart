import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';

import '../../models/tag.dart';
import '../../navigator/delegate.dart';

class TagItem extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String tag;
  final VoidCallback onTap;

  const TagItem({
    Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.tag,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          tag,
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ),
    );
  }
}

class TagsWidget extends StatelessWidget {
  final List<Tag> tags;
  final Color backgroundColor;
  final Color textColor;
  final int? maxTags;
  final bool scrollable;

  const TagsWidget({
    Key? key,
    required this.tags,
    this.backgroundColor = const Color.fromRGBO(104, 116, 182, 0.3),
    this.textColor = const Color(0xff919bb3),
    this.maxTags,
    this.scrollable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayedTags = tags.take(maxTags ?? tags.length).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: scrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: displayedTags
                    .map((tag) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: TagItem(
                            backgroundColor: backgroundColor,
                            textColor: textColor,
                            tag: tag.name,
                            onTap: () {
                              // Handle tag tap
                              MyRouteDelegate.of(context).push(
                                AppRoutes.tag,
                                args: {
                                  'id': tag.id,
                                  'title': tag.name,
                                  'film': 3
                                },
                                removeSamePath: true,
                              );
                            },
                          ),
                        ))
                    .toList(),
              ),
            )
          : Wrap(
              spacing: 4,
              runSpacing: 4,
              children: displayedTags
                  .map((tag) => TagItem(
                        backgroundColor: backgroundColor,
                        textColor: textColor,
                        tag: tag.name,
                        onTap: () {
                          // Handle tag tap
                          MyRouteDelegate.of(context).push(
                            AppRoutes.tag,
                            args: {'id': tag.id, 'title': tag.name, 'film': 3},
                            removeSamePath: true,
                          );
                        },
                      ))
                  .toList(),
            ),
    );
  }
}
