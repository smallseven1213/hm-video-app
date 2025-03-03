import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final String? loadingText;

  const Loading({Key? key, this.loadingText}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

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
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
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
          Transform.scale(
            scale: .7,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: _animationController.drive(
                ColorTween(
                  begin: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  end: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DefaultTextStyle(
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10,
            ),
            child: Text(widget.loadingText ?? ''),
          ),
        ],
      ),
    );
  }
}
