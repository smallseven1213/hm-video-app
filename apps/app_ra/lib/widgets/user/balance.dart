import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user/user_info_reload_button.dart';

final logger = Logger();
const Color baseColor = Color(0xFF003068);

class UserBalance extends StatelessWidget {
  const UserBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: UserInfoConsumer(child: (info, isVIP, isGuest) {
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Text('\$${info.points}',
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
            UserInfoReloadButton(
                child: const SizedBox(
              width: 24,
              // refresh icon from flutter Icon
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ))
          ],
        );
      }),
    );
  }
}
