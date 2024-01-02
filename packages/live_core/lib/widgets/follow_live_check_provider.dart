import 'package:flutter/material.dart';

class FollowLiveCheckProvider extends StatefulWidget {
  final Widget Function(
    bool isFollowed,
  ) child;

  const FollowLiveCheckProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _FollowLiveCheckProviderState createState() =>
      _FollowLiveCheckProviderState();
}

class _FollowLiveCheckProviderState extends State<FollowLiveCheckProvider> {
  bool isFollowed = false;

  // handleTap
  void handleTap() {
    setState(() {
      isFollowed = !isFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handleTap,
      child: widget.child(isFollowed),
    );
  }
}
