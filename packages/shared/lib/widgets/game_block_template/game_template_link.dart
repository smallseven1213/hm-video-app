import 'package:flutter/material.dart';
import 'package:shared/utils/handle_url.dart';

class GameTemplateLink extends StatelessWidget {
  final String url;
  final Widget child;

  const GameTemplateLink({super.key, required this.url, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(context),
      child: child,
    );
  }

  void _launchURL(BuildContext context) async {
    handleDefaultScreenKey(context, url);
  }
}
