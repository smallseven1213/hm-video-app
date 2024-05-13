import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../localization/live_localization_delegate.dart';

class BottomSheetMessageInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function() onSend;
  const BottomSheetMessageInput(
      {super.key, required this.textEditingController, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.only(
              bottom: kIsWeb ? 0 : MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 64,
            child: MessageInputWidget(
              controller: textEditingController,
              onSend: onSend,
            ),
          )),
    );
    // return SingleChildScrollView(
    //   child: Padding(
    //       padding: EdgeInsets.only(
    //           bottom: kIsWeb ? 0 : MediaQuery.of(context).viewInsets.bottom),
    //       child: SizedBox(
    //         height: 64,
    //         child: MessageInputWidget(
    //           controller: textEditingController,
    //           onSend: onSend,
    //         ),
    //       )),
    // );
  }
}

class MessageInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputWidget({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  MessageInputWidgetState createState() => MessageInputWidgetState();
}

class MessageInputWidgetState extends State<MessageInputWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Container(
      height: 54,
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
        top: 5,
        bottom: 5 + MediaQuery.of(context).padding.bottom,
      ),
      color: const Color(0xFF242a3d),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                autofocus: true,
                controller: widget.controller,
                style: const TextStyle(fontSize: 14, color: Color(0xFF242A3D)),
                decoration: InputDecoration(
                  hintText:
                      localizations.translate('say_something_to_the_host'),
                  hintStyle:
                      const TextStyle(fontSize: 14, color: Color(0xFF7b7b7b)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10),
                ),
                onSubmitted: (_) {
                  widget.onSend(); // 當按下Enter鍵時調用
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              widget.onSend();
            },
            child: SizedBox(
              width: 60,
              child: Center(
                child: Text(
                  localizations.translate('send'),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
