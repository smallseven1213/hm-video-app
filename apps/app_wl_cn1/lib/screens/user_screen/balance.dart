import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';
import 'package:shared/modules/user/user_info_reload_button.dart';

final logger = Logger();
const Color baseColor = Color(0xFF1E1E1E); // Dark background color

class UserBalance extends StatelessWidget {
  const UserBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: UserInfoV2Consumer(
          child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
        return Row(
          children: [
            Expanded(
              child: Container(
                height: 34,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xff272B36),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '\$ ${info.points}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            UserInfoReloadButton(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xff272B36),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
