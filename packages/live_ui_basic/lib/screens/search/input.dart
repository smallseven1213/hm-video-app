import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_search_controller.dart';

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
  _SearchInputWidgetState createState() => _SearchInputWidgetState();
}

class _SearchInputWidgetState extends State<SearchInputWidget> {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFF323d5c),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: '搜尋主播ID暱稱',
                hintStyle: TextStyle(color: Color(0xff5a6077), fontSize: 14),
                border: InputBorder.none,
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
          if (widget.showCancel)
            IconButton(
              onPressed: () {
                _controller.clear();
                if (widget.onCancel != null) {
                  widget.onCancel!();
                }
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
        ],
      ),
    );
  }
}
