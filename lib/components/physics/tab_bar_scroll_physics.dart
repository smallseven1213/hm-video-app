import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class TabBarScrollPhysics extends ScrollPhysics {
  const TabBarScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  TabBarScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return TabBarScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 500,
        stiffness: 1000,
        damping: .1,
      );
}
