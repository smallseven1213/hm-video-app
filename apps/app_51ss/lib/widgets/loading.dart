import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final String? loadingText;

  const Loading({Key? key, this.loadingText}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      width: 90,
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
              color: Color.fromARGB(208, 255, 255, 255)),
          const SizedBox(height: 10),
          DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
            child: Text(widget.loadingText ?? ''),
          ),
        ],
      ),
    );
  }
}
