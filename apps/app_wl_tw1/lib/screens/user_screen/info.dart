import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/user/user_data_getting_status_consumer.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shimmer/shimmer.dart';

import 'package:app_wl_tw1/config/colors.dart';
import '../../widgets/avatar.dart';
import 'balance.dart';

final logger = Logger();
const Color baseColor = Color(0xFF003068);

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  Widget _buildShimmer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF003068),
      highlightColor: const Color(0xFF00234d),
      child: SizedBox(
        width: width,
        height: height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: AppColors.colors[ColorKeys.primary],
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            UserInfoV2Consumer(
                              child: (info, isVIP, isGuest, isLoading,
                                  isInfoV2Init) {
                                if (isVIP) {
                                  return const Image(
                                    image: AssetImage(
                                        'assets/images/user_screen_info_vip.webp'),
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
                                      return _buildShimmer(
                                          width: 80, height: 14);
                                    } else {
                                      return UserInfoV2Consumer(
                                        child: (info, isVIP, isGuest, isLoading,
                                            isInfoV2Init) {
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
                                UserInfoV2Consumer(
                                  child: (info, isVIP, isGuest, isLoading,
                                      isInfoV2Init) {
                                    if (!isGuest) {
                                      return GestureDetector(
                                        onTap: () {
                                          MyRouteDelegate.of(context)
                                              .push('/user/nickname');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: const Icon(
                                            Icons.border_color_rounded,
                                            size: 15,
                                            color: Colors.white,
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
                                return UserInfoV2Consumer(
                                  child: (info, isVIP, isGuest, isLoading,
                                      isInfoV2Init) {
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
                    ],
                  ),
                  const UserBalance(),
                ],
              ),
              UserInfoV2Consumer(
                child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
                  return Positioned(
                    top: 0,
                    right: 0,
                    child: !isGuest
                        ? GestureDetector(
                            onTap: () {
                              MyRouteDelegate.of(context)
                                  .push(AppRoutes.configs);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.settings_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              MyRouteDelegate.of(context).push(AppRoutes.login);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.login,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  );
                },
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
                    child: const Icon(
                      Icons.mail_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: AppColors.colors[ColorKeys.primary] as Color,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 32,
              color: const Color(0xff1c202f),
            ),
          ),
        ),
      ],
    );
  }
}
