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
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: const Color(0xFFFF3B52)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.search,
                    size: 16,
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
                    style: const TextStyle(color: Color(0xff50525a)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Color(0xFFFF3B52),
                ),
                child: TextButton(
                  onPressed: onSearchButtonClick,
                  child: Text(
                    I18n.searchFor,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
