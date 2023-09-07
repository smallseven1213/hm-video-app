import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/user/user_info_consumer.dart';

final logger = Logger();
const Color baseColor = Color(0xFF003068);

class UserBalance extends StatelessWidget {
  const UserBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: baseColor,
      child: UserInfoConsumer(child: (info, isVIP, isGuest) {
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Text('\$${info.points}'),
            ),
            InkWell(
                onTap: () {},
                child: Container(
                  width: 24,
                  // refresh icon
                  child: Image.asset(
                    'assets/images/refresh.png',
                    fit: BoxFit.cover,
                  ),
                ))
          ],
        );
      }),
    );
  }
}
