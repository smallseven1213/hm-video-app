import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/widgets/avatar.dart';
import 'package:shared/widgets/posts/follow_button.dart';

import '../../../models/supplier.dart';
import '../../../navigator/delegate.dart';

class SupplierInfoWidget extends StatelessWidget {
  final Supplier supplier;
  final bool darkMode;
  final Color textColor;
  final Color buttonColor;

  const SupplierInfoWidget({
    Key? key,
    required this.supplier,
    required this.darkMode,
    required this.textColor,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => MyRouteDelegate.of(context).push(
            AppRoutes.supplier,
            args: {'id': supplier.id},
            removeSamePath: true,
          ),
          child: Row(
            children: [
              AvatarWidget(
                photoSid: supplier.photoSid,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                supplier.aliasName ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        FollowButton(
          supplier: supplier,
          isDarkMode: darkMode,
          backgroundColor: buttonColor,
          textColor: textColor,
        ),
      ],
    );
  }
}
