import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StaticSearchInput extends StatelessWidget {
  final String defaultValue;
  final VoidCallback onSearchButtonClick;
  final VoidCallback onInputClick;
  const StaticSearchInput({
    Key? key,
    required this.defaultValue,
    required this.onSearchButtonClick,
    required this.onInputClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 4),
      margin: const EdgeInsets.only(top: 4, left: 8),
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: const Color(0xFFFF3B52)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 25,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                'assets/svgs/ic-search.svg',
                width: 16,
                height: 16,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              onPressed: onInputClick,
            ),
          ),
          // IconButton(
          //   icon: SvgPicture.asset(
          //     'svgs/ic-search.svg',
          //     width: 17,
          //     height: 17,
          //     colorFilter:
          //         const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          //   ), // First button with "add" icon
          //   onPressed: () {
          //     // Define your action here
          //   },
          // ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onInputClick,
              child: Text(
                defaultValue,
                style: const TextStyle(
                    color: Color(0xff50525a), fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 5),
          TextButton(
            onPressed: onSearchButtonClick,
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.only(left: 10, right: 10)),
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFFFF3B52)),
              foregroundColor:
                  MaterialStateProperty.all(const Color(0xFFFFFFFF)),
              overlayColor: MaterialStateProperty.all(
                  const Color(0xFFFF3B52).withOpacity(0.5)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            child: Text(
              I18n.searchFor,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
