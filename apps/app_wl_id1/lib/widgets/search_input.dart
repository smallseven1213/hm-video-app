// SearchInput is stateless widget

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../config/colors.dart';

class SearchInput extends StatefulWidget {
  const SearchInput(
      {Key? key,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.onSubmitted,
      this.onTap,
      this.defaultValue,
      this.placeHolder,
      this.autoFocus = false,
      this.readOnly = false,
      this.enableInteractiveSelection = true,
      this.onSearchButtonClick}) // 新的回調
      : super(key: key);

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final String? defaultValue;
  final String? placeHolder;
  final bool autoFocus;
  final bool? readOnly;
  final bool? enableInteractiveSelection;
  final void Function(String)? onSearchButtonClick; // 新的回調

  @override
  SearchInputState createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller?.clear();
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
          decoration: kIsWeb
              ? const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFF00B2FF),
                )
              : const BoxDecoration(
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
            onTap: widget.onTap,
            controller: _controller,
            textAlignVertical: TextAlignVertical.center,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide.none,
              ),
              hintText: widget.placeHolder,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF002865),
              suffixIcon: GestureDetector(
                onTap: () {
                  if (widget.onSearchButtonClick != null) {
                    widget.onSearchButtonClick!(_controller!.text);
                  }
                },
                child: const SizedBox(
                  width: 17,
                  height: 17,
                  child: Center(
                    child: SizedBox(
                      width: 17,
                      height: 17,
                      child: Image(
                        image: AssetImage('assets/images/search_button.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            autofocus: widget.autoFocus,
            focusNode: widget.focusNode,
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
