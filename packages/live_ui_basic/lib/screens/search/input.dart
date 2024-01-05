import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_search_history_controller.dart';

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

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1f2533),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: '搜尋主播ID暱稱',
                hintStyle: const TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              onSubmitted: (value) {
                print('@@@ onSubmitted: $value');
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
              icon: const Icon(Icons.close, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
