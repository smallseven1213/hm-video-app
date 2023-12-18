import 'package:flutter/material.dart';

void showLiveDialog(BuildContext context,
    {String? title, Widget? content, List<Widget>? actions}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF242a3d),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.7)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200.0),
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 15.7, color: Colors.white)),
                  ),
                if (content != null)
                  Expanded(
                    child: Center(
                      child: content,
                    ),
                  ),
                if (actions != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: actions!
                        .asMap()
                        .entries
                        .map((entry) => [
                              Expanded(
                                child: entry.value,
                              ),
                              if (entry.key != actions.length - 1)
                                SizedBox(width: 16)
                            ])
                        .expand((element) => element)
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
