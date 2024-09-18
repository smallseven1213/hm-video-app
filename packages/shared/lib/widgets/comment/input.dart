import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget {
  final VoidCallback onSend;
  final VoidCallback onFocus;

  const CommentInput({
    Key? key,
    required this.onSend,
    required this.onFocus,
  }) : super(key: key);

  @override
  CommentInputState createState() => CommentInputState();
}

class CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 當焦點變化時，檢查是否獲得焦點
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.onFocus(); // 執行 onFocus 回調
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // 銷毀 FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1c202f),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/play_count.webp'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              focusNode: _focusNode, // 使用 FocusNode
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
                          setState(() {}); // 刷新 UI
                        },
                      )
                    : null,
              ),
              onChanged: (text) {
                setState(() {}); // 當輸入框內容變化時刷新 UI
              },
            ),
          ),
          TextButton(
            onPressed: widget.onSend,
            child: const Text('送出', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
