import 'package:flutter/material.dart';

class TiktokScrollPhysics extends PageScrollPhysics {
  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final tolerance = this.tolerance;
    final portion = (position.pixels / position.viewportDimension);
    final page = (portion).roundToDouble();
    final offset = page * position.viewportDimension;

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      offset,
      velocity,
      tolerance: tolerance,
    );
  }
}
