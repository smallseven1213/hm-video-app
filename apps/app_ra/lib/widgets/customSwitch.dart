import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool? value;
  final Color? enableColor;
  final Color? disableColor;
  final double? width;
  final double? height;
  final double? switchHeight;
  final double? switchWidth;
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({
    Key? key,
    this.value,
    this.enableColor,
    this.disableColor,
    this.width,
    this.height,
    this.switchHeight,
    this.switchWidth,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    bool open = widget.value == true;
    Color enableColor =
        widget.enableColor ?? AppColors.colors[ColorKeys.primary];
    Color disableColor = widget.disableColor ?? Colors.white;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged!(true)
                : widget.onChanged!(false);
          },
          child: Container(
            width: widget.width ?? 48.0,
            height: widget.height ?? 24.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                  width: 1.0, color: open ? enableColor : disableColor),
            ),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              alignment: open ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: widget.switchWidth ?? 20.0,
                height: widget.switchHeight ?? 20.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: open ? enableColor : disableColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
