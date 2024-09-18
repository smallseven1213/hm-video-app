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

    // Listen to focus changes
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
    _focusNode.dispose(); // Dispose of the focus node
    _controller.dispose(); // Dispose of the text controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: const Color(0xff1c202f),
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 20,
        bottom: 20,
      ),
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
              scrollPadding: const EdgeInsets.all(0),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '說些什麼...',
                hintStyle: const TextStyle(color: Color(0xff5f6279)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: const Color(0xff3f4253),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _controller.clear();
                          setState(() {}); // Refresh UI
                        },
                      )
                    : null,
              ),
              onChanged: (text) {
                setState(() {}); // Refresh UI when text changes
              },
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle send action
              if (_controller.text.isNotEmpty) {
                widget.onSend(_controller.text);
                _controller.clear();
                FocusScope.of(context).unfocus();
                setState(() {}); // Refresh UI
              }
            },
            child: const Text('送出', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
