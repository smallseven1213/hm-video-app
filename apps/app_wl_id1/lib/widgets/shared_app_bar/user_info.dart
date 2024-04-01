import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';

class UserInfo extends StatelessWidget {
  final User info;

  const UserInfo({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              const Text(
                'Total Balance:',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              Text(
                info.depositedAmount ?? "0",
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ],
          ),
          const Image(
            image: AssetImage('assets/images/user_balance.png'),
            fit: BoxFit.contain,
            height: 35,
          )
        ],
      ),
    );
  }
}
