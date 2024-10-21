import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/user/user_data_getting_status_consumer.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import 'package:app_wl_tw1/config/colors.dart';
import '../../widgets/avatar.dart';
import 'balance.dart';

const Color baseColor = Color(0xFF003068);
const Color highlightColor = Color(0xFF00234d);

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  Widget _buildShimmer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SizedBox(
        width: width,
        height: height,
      ),
    );
  }

  Widget _buildUserName(BuildContext context) {
    return Row(
      children: [
        UserDataGettingStatusConsumer(
          child: (isLoading) {
            if (isLoading) {
              return _buildShimmer(width: 80, height: 14);
            } else {
              return UserInfoV2Consumer(
                child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
                  return Row(
                    children: [
                      // 如需显示VIP图标，请取消注释
                      if (isVIP)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Image(
                            image: AssetImage(
                                'assets/images/user_screen_info_vip.webp'),
                            width: 34,
                          ),
                        ),
                      Text(
                        info.nickname,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
        UserInfoV2Consumer(
          child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
            if (!isGuest) {
              return GestureDetector(
                onTap: () {
                  MyRouteDelegate.of(context).push('/user/nickname');
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
    );
  }

  Widget _buildUserID() {
    return UserDataGettingStatusConsumer(
      child: (isLoading) {
        if (isLoading && !kIsWeb) {
          return _buildShimmer(width: 50, height: 12);
        } else {
          return UserInfoV2Consumer(
            child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
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
      },
    );
  }

  Widget _buildSettingsIcon(BuildContext context) {
    return UserInfoV2Consumer(
      child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
        return Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => MyRouteDelegate.of(context)
                .push(!isGuest ? AppRoutes.configs : AppRoutes.login),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Icon(
                !isGuest ? Icons.settings_outlined : Icons.login,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Positioned(
      top: 0,
      right: 30,
      child: GestureDetector(
        onTap: () => MyRouteDelegate.of(context).push(AppRoutes.notifications),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: const Icon(
            Icons.mail_outlined,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserName(context),
                        const SizedBox(height: 5),
                        _buildUserID(),
                      ],
                    ),
                  ),
                ],
              ),
              const UserBalance(),
            ],
          ),
          _buildSettingsIcon(context),
          _buildNotificationIcon(context),
        ],
      ),
    );
  }

  Widget _buildBottomCurve() {
    return Container(
      color: AppColors.colors[ColorKeys.primary] as Color,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          height: 16,
          color: const Color(0xff1c202f),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildUserInfoSection(context),
        _buildBottomCurve(),
      ],
    );
  }
}
