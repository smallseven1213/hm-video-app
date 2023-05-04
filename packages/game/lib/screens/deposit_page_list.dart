import 'package:flutter/material.dart';

class GameDeposit extends StatefulWidget {
  const GameDeposit({super.key});

  @override
  State<GameDeposit> createState() => _GameDepositState();
}

class _GameDepositState extends State<GameDeposit> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Game Deposit Type List',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
