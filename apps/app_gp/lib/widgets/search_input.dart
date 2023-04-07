// SearchInput is stateless widget

import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../config/colors.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    Key? key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.defaultValue,
    this.autoFocus = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final String? defaultValue;
  final bool autoFocus;

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.defaultValue != null) {
      _controller?.text = widget.defaultValue!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      color: AppColors.colors[ColorKeys.background],
      child: SizedBox(
        height: 30,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF00B2FF),
                Color(0xFFCCEAFF),
                Color(0xFF0075FF),
              ],
              stops: [0, 0.5, 1],
            ),
          ),
          padding: const EdgeInsets.all(2),
          child: TextField(
            // focusNode: widget.onTap != null ? AlwaysDisabledFocusNode() : null,
            onTap: widget.onTap,
            controller: _controller,
            textAlignVertical: TextAlignVertical.center,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide.none,
              ),
              hintText: '搜尋',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFF002865),
            ),
            style: const TextStyle(color: Colors.white),
            autofocus: widget.autoFocus,
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
