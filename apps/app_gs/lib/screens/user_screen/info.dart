import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/user/user_data_getting_status_consumer.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shimmer/shimmer.dart';

import 'package:game/localization/game_localization_deletate.dart';
import '../../widgets/avatar.dart';

final logger = Logger();
const Color baseColor = Color(0xFF003068);

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  Widget _buildShimmer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF003068),
      highlightColor: const Color(0xFF00234d),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF00B2FF),
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF000916),
            Color(0xFF003F6C),
          ],
          stops: [0.0, 1.0],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Stack(
        children: [
          Row(
            children: [
              Avatar(),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfoConsumer(
                      child: (info, isVIP, isGuest) {
                        if (isVIP) {
                          return const Image(
                            image: AssetImage(
                                'assets/images/user_screen_info_vip.png'),
                            width: 20,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    Row(
                      children: [
                        UserDataGettingStatusConsumer(
                          child: (isLoading) {
                            if (isLoading) {
                              return _buildShimmer(width: 80, height: 14);
                            } else {
                              return UserInfoConsumer(
                                child: (info, isVIP, isGuest) {
                                  return Text(
                                    info.nickname ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        UserInfoConsumer(
                          child: (info, isVIP, isGuest) {
                            if (info.id.isNotEmpty && !isGuest) {
                              return GestureDetector(
                                onTap: () {
                                  MyRouteDelegate.of(context)
                                      .push('/user/nickname');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: const Image(
                                    image: AssetImage(
                                        'assets/images/user_screen_info_editor.png'),
                                    width: 15,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    UserDataGettingStatusConsumer(child: (isLoading) {
                      if (isLoading && !kIsWeb) {
                        return _buildShimmer(width: 50, height: 12);
                      } else {
                        return UserInfoConsumer(
                          child: (info, isVIP, isGuest) {
                            if (info.id.isEmpty) {
                              return const SizedBox();
                            }
                            return Text(
                              'ID: ${info.uid}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        );
                      }
                    }),
                  ],
                ),
              ),
              UserInfoConsumer(child: ((info, isVIP, isGuest) {
                if (isGuest) {
                  return Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        MyRouteDelegate.of(context).push(AppRoutes.login);
                      },
                      child: Text(
                        localizations.translate('register_login'),
                        style: const TextStyle(
                          color: Color(0xffFFC700),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color(0xffFF7A00),
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }))
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                MyRouteDelegate.of(context).push(AppRoutes.configs);
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                child: const Image(
                  image:
                      AssetImage('assets/images/user_screen_config_button.png'),
                  width: 15,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 30,
            child: GestureDetector(
              onTap: () {
                MyRouteDelegate.of(context).push(AppRoutes.notifications);
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                child: const Image(
                  image:
                      AssetImage('assets/images/user_screen_notice_button.png'),
                  width: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
