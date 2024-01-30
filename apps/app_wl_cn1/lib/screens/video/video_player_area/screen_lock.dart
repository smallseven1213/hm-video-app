import 'package:flutter/material.dart';

class ScreenLock extends StatefulWidget {
  final bool isScreenLocked;
  final Function onScreenLock;

  const ScreenLock({
    super.key,
    required this.isScreenLocked,
    required this.onScreenLock,
  });

  @override
  ScreenLockState createState() => ScreenLockState();
}

class ScreenLockState extends State<ScreenLock> {
  String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: IconButton(
                icon: Icon(
                  widget.isScreenLocked ? Icons.lock_open_outlined : Icons.lock,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget.onScreenLock(!widget.isScreenLocked);
                  setState(() {
                    message = !widget.isScreenLocked ? "萤幕已锁定" : "萤幕已解锁";
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      message = null;
                    });
                  });
                },
              ),
            ),
          ),
          if (message != null)
            Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Center(
                child: Text(
                  message!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
