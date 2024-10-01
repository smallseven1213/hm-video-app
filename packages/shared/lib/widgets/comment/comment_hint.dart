import 'package:flutter/material.dart';
import 'package:shared/localization/shared_localization_delegate.dart';

class CommentHint extends StatelessWidget {
  final VoidCallback onTap;

  const CommentHint({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap, // 點擊時觸發的行為
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xff3f4253),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                localizations.translate('say_something'),
                style: const TextStyle(
                  color: Color(0xff5f6279),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
