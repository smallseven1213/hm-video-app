import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    Key? key,
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
    this.onSearchButtonClick,
    this.backgroundColor = Colors.white,
  }) // 新的回调
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
  final void Function(String)? onSearchButtonClick;
  final Color backgroundColor;

  @override
  SearchInputState createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
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
      child: SizedBox(
        height: 30,
        child: Container(
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
              fillColor: widget.backgroundColor,
              suffixIcon: GestureDetector(
                onTap: () {
                  if (widget.onSearchButtonClick != null) {
                    widget.onSearchButtonClick!(_controller!.text);
                  }
                },
                child: const Icon(
                  Icons.search,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 14),
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
