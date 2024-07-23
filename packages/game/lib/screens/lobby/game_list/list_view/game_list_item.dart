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

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final imageSize = availableWidth - 30;
        const textHeight = 30.0; // 文字區域高度

        return Column(
          mainAxisSize: MainAxisSize.min, // 讓Column只佔用需要的空間
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  color: gameLobbyEmptyColor,
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
            Container(
              height: textHeight,
              alignment: Alignment.center,
              child: Text(
                widget.name,
                style:
                    TextStyle(color: gameLobbyPrimaryTextColor, fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
