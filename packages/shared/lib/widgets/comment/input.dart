import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget {
  final Function(String) onSend;
  final ValueChanged<bool>? onFocusChange;

  const CommentInput({
    Key? key,
    required this.onSend,
    this.onFocusChange,
  }) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isKeyboardVisible = true;
        });
        widget.onFocusChange?.call(true);
      } else {
        setState(() {
          _isKeyboardVisible = false;
        });
        widget.onFocusChange?.call(false);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1c202f),
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/play_count.webp'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              minLines: 1,
              maxLines: 3,
              scrollPadding: EdgeInsets.zero,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: '說些什麼...',
                hintStyle: const TextStyle(color: Color(0xff5f6279)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: const Color(0xff5f6279),
                  ),
                ),
                filled: true,
                fillColor: const Color(0xff3f4253),
                focusColor: const Color(0xff5f6279),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Color(0xff5f6279),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: Color.fromARGB(255, 50, 52, 64),
                              size: 12,
                            ),
                          ),
                        ),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (text) {
                setState(() {});
              },
            ),
          ),
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                widget.onSend(_controller.text);
                _controller.clear(); // Clear the text field
                FocusScope.of(context).unfocus();
                setState(() {});
              }
            },
            child: const Text('送出', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
