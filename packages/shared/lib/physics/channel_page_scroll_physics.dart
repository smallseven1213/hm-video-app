import 'package:flutter/material.dart';

class ChannelPageScrollPhysics extends ScrollPhysics {
  const ChannelPageScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  ChannelPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ChannelPageScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 1,
      );
}
