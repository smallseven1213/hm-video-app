import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

class AuthButtons extends StatelessWidget {
  const AuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            MyRouteDelegate.of(context).push(AppRoutes.login);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF082C68),
            ),
            child: Text(I18n.login,
                style: const TextStyle(color: Color(0xffb2bac5), fontSize: 12)),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () {
            MyRouteDelegate.of(context).push(AppRoutes.register);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFF6874b6)),
            child: Text(I18n.signup,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
