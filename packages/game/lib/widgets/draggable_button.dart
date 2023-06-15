import 'package:flutter/material.dart';

class DraggableFloatingActionButton extends StatefulWidget {
  final Widget child;
  final Offset initialOffset;
  final VoidCallback? onPressed;

  const DraggableFloatingActionButton({
    Key? key,
    required this.child,
    required this.initialOffset,
    this.onPressed,
  }) : super(key: key);

  @override
  DraggableFloatingActionButtonState createState() =>
      DraggableFloatingActionButtonState();
}

class DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  bool _isDragging = false;
  Offset _offset = Offset.zero;
  Offset _startPosition = Offset.zero;
  Offset _dragOffset = Offset.zero;
  double _deviceWidth = 0.0;
  double _deviceHeight = 0.0;
  final double _buttonSize = 70.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      didChangeDependencies();
    });
    _offset = widget.initialOffset;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _deviceWidth = MediaQuery.of(context).size.width;
      _deviceHeight = MediaQuery.of(context).size.height;
      _offset = Offset(_deviceWidth - _buttonSize, _deviceHeight - _buttonSize);

      _updatePosition(
        DragUpdateDetails(
          globalPosition: _offset,
          localPosition: _offset,
          delta: _offset,
        ),
      );
    });
  }

  void _startDragging(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _startPosition = _offset;
      _dragOffset = details.localPosition;
    });
  }

  void _updatePosition(DragUpdateDetails details) {
    setState(() {
      double newOffsetX =
          (_startPosition.dx + details.localPosition.dx - _dragOffset.dx)
              .clamp(0.0, _deviceWidth - _buttonSize);
      double newOffsetY =
          (_startPosition.dy + details.localPosition.dy - _dragOffset.dy)
              .clamp(0.0, _deviceHeight - _buttonSize);
      _offset = Offset(newOffsetX, newOffsetY);
    });
  }

  void _stopDragging(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: GestureDetector(
        onPanStart: _startDragging,
        onPanUpdate: _updatePosition,
        onPanEnd: _stopDragging,
        child: Stack(
          children: [
            widget.child,
            if (_isDragging)
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  child: const IgnorePointer(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
