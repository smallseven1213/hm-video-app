import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../../../../widgets/cache_image.dart';

final logger = Logger();

class GameListItem extends StatefulWidget {
  final String imageUrl;
  final int gameType;
  final String name;

  const GameListItem(
      {Key? key,
      required this.imageUrl,
      required this.gameType,
      required this.name})
      : super(key: key);

  @override
  State<GameListItem> createState() => _GameListItemState();
}

class _GameListItemState extends State<GameListItem> {
  @override
  Widget build(BuildContext context) {
    final theme = themeMode[GetStorage().hasData('pageColor')
            ? GetStorage().read('pageColor')
            : 1]
        .toString();

    return Container(
      decoration: BoxDecoration(
        color: gameLobbyUserInfoColor2,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: -2,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: AspectRatio(
              aspectRatio: 60 / 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: widget.imageUrl.isNotEmpty
                    ? kIsWeb
                        ? Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                          )
                        : CacheImage(
                            url: widget.imageUrl,
                            fit: BoxFit.cover,
                            emptyImageUrl:
                                'packages/game/assets/images/game_lobby/game_empty-$theme.webp',
                          )
                    : Image.asset(
                        'packages/game/assets/images/game_lobby/game_empty-$theme.webp',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                widget.name,
                style: TextStyle(
                  color: gameLobbyPrimaryTextColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
