import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GameTemplateLink extends StatelessWidget {
  final String url;
  final Widget child;

  const GameTemplateLink({super.key, required this.url, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(),
      child: child,
    );
  }

  void _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
