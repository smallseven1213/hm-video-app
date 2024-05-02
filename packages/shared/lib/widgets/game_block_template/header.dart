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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: () {
              MyRouteDelegate.of(context).push(
                AppRoutes.games,
                args: {
                  'gameAreaId': gameBlocks.id,
                  'gameAreaName': gameBlocks.name,
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.blue),
              ),
              child:
                  const Text('See All', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
