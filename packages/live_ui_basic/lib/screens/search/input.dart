import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_search_controller.dart';

import '../../localization/live_localization_delegate.dart';

class SearchInputWidget extends StatefulWidget {
  final String? query;
  final Function(String)? onSearch;
  final Function(String)? onChanged;
  final Function()? onCancel;
  final bool showCancel;

  const SearchInputWidget({
    Key? key,
    this.query,
    this.onSearch,
    this.onChanged,
    this.onCancel,
    this.showCancel = false,
  }) : super(key: key);

  @override
  SearchInputWidgetState createState() => SearchInputWidgetState();
}

class SearchInputWidgetState extends State<SearchInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final LiveSearchController liveSearchController = Get.find();
  late final RxString keyword;

  @override
  void initState() {
    super.initState();
    ever(liveSearchController.keyword, (_) {
      _controller.text = liveSearchController.keyword.value;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF323d5c),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 5),
            child: Icon(Icons.search, color: Colors.white54),
          ),
          Expanded(
            child: Container(
              height: 35.0, // 設定容器高度為 30
              alignment: Alignment.center, // 確保內部元素垂直居中
              child: TextField(
                textAlignVertical:
                    TextAlignVertical.center, // 確保文字在TextField內垂直居中
                style: const TextStyle(fontSize: 14.0, color: Colors.white),
                decoration: InputDecoration(
                  isDense: true, // 減少TextField的總高度和內部空間
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0), // 最小化垂直內距
                  border: InputBorder.none, // 可選，根據需要移除邊框
                  hintText:
                      localizations.translate('search_host_id_or_nickname'),
                  hintStyle:
                      const TextStyle(color: Color(0xff5a6077), fontSize: 14),
                ),
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                onSubmitted: (value) {
                  if (widget.onSearch != null) {
                    widget.onSearch!(value);
                  }
                },
              ),
            ),
          ),
          if (widget.showCancel)
            InkWell(
              onTap: () {
                _controller.clear();
                if (widget.onCancel != null) {
                  widget.onCancel!();
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 5, right: 10),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
