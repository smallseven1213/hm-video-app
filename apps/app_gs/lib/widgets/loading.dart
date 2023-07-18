import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final String? loadingText;

  const Loading({Key? key, this.loadingText}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.repeat();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: kIsWeb ? null : BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(0, 0, 0, 0.8),
            Color.fromRGBO(0, 16, 28, 0.8),
            Color.fromRGBO(0, 47, 81, 0.8)
          ],
          stops: [0.0, 0.7, 1.0],
        ),
      ),
      width: 90,
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _animation,
            child: const Image(
              image: AssetImage('assets/images/loading.png'),
              width: 30.0,
              height: 30.0,
            ),
          ),
          const SizedBox(height: 10),
          DefaultTextStyle(
            style: const TextStyle(
              color: Color(0xFF00B0D4),
              fontSize: 10,
            ),
            child: Text(widget.loadingText ?? ''),
          ),
        ],
      ),
    );
  }
}
