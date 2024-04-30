import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

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
            width: 70,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF00669F), width: 1),
              color: Colors.transparent,
            ),
            child: const Center(
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            MyRouteDelegate.of(context).push(AppRoutes.register);
          },
          child: Container(
            width: 70,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFF00669F), width: 1),
              color: const Color(0xFF082C68),
            ),
            child: const Center(
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
