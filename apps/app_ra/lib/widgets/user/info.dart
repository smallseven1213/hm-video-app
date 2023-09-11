import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/user/user_data_getting_status_consumer.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/avatar.dart';
import '../../widgets/button.dart';

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
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                      fontSize: 16,
                                      color: Color(0xFFFDDCEF),
                                      fontWeight: FontWeight.w800,
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
                              ),
                            );
                          },
                        );
                      }
                    }),
                  ],
                ),
              ),
              SizedBox(
                  width: 150,
                  child: UserInfoConsumer(child: ((info, isVIP, isGuest) {
                    if (isGuest) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 註冊 and 登入按鈕
                          SizedBox(
                            width: 60,
                            height: 35,
                            child: Button(
                                size: 'small',
                                onPressed: () {
                                  MyRouteDelegate.of(context)
                                      .push(AppRoutes.register);
                                },
                                text: '註冊'),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60,
                            height: 35,
                            child: Button(
                                size: 'small',
                                onPressed: () {
                                  MyRouteDelegate.of(context)
                                      .push(AppRoutes.login);
                                },
                                text: '登入'),
                          ),
                        ],
                      );
                    } else if (info.nickname != null) {
                      if (isVIP) {
                        return Column(
                          children: [
                            const Text('永久至尊特權會員',
                                style: TextStyle(
                                  color: const Color(0xFFFDDCEF),
                                  fontSize: 16,
                                )),
                            Text('效期至 ${info.vipExpiredAt}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                          ],
                        );
                      } else {
                        return SizedBox(
                          width: 70,
                          height: 35,
                          child: Button(
                              size: 'small',
                              onPressed: () => MyRouteDelegate.of(context)
                                  .push(AppRoutes.vip),
                              text: '開通VIP'),
                        );
                      }
                    }
                    return Container();
                  })))
            ],
          ),
        ],
      ),
    );
  }
}
