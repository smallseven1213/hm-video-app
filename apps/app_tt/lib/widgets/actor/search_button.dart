import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchButton extends StatelessWidget {
  final Function handleSearch;
  final String keyword;

  const SearchButton({
    Key? key,
    required this.handleSearch,
    required this.keyword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'svgs/ic-search.svg',
        width: 17,
        height: 17,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
      onPressed: () => handleSearch(keyword),
    );
  }
}
