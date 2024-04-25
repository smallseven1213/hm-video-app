import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';
import '../../models/game.dart';
import '../../enums/app_routes.dart';

const kPrimaryColor = Color(0xff00669F);

class HeaderWidget extends StatelessWidget {
  final Game gameBlocks;

  const HeaderWidget({super.key, required this.gameBlocks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            gameBlocks.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {
              MyRouteDelegate.of(context).push(
                AppRoutes.games,
                args: {
                  'gameAreaId': gameBlocks.id,
                },
              );
            },
            style: TextButton.styleFrom(
              side: const BorderSide(color: kPrimaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'See All',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
