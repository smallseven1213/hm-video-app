import 'package:flutter/material.dart';

class GameWithdraw extends StatefulWidget {
  const GameWithdraw({super.key});

  @override
  State<GameWithdraw> createState() => _GameWithdrawState();
}

class _GameWithdrawState extends State<GameWithdraw> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Game Withdraw',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
