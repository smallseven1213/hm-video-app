import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/show_confirm_dialog.dart';
import 'package:shared/widgets/avatar.dart';
import 'package:shared/widgets/ui_bottom_safearea.dart';

class CommentInput extends StatefulWidget {
  final Function(String) onSend;
  final ValueChanged<bool> onFocusChange;
  final bool? autoFocusInput;

  const CommentInput({
    Key? key,
    required this.onSend,
    required this.onFocusChange,
    this.autoFocusInput,
  }) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();
  // final FocusNode _focusNode = FocusNode();

  // @override
  // void initState() {
  //   super.initState();
  //   _focusNode.addListener(_onFocusChange);
  //   if (widget.autoFocusInput == true) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _focusNode.requestFocus();
  //     });
  //   }
  // }

  // void _onFocusChange() {
  //   widget.onFocusChange(_focusNode.hasFocus);
  // }

  @override
  void dispose() {
    // _focusNode.removeListener(_onFocusChange);
    // _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    print('widget.autoFocusInput@: ${widget.autoFocusInput}');
    return Container(
      color: const Color(0xff1c202f),
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
      child: UIBottomSafeArea(
        child: Row(
          children: [
            UserInfoConsumer(
              child: (info, isVIP, isGuest, isLoading) {
                return AvatarWidget(
                  photoSid: info.avatar,
                  width: 40,
                  height: 40,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Focus(
                autofocus: widget.autoFocusInput ?? false,
                onFocusChange: (hasFocus) {
                  print('@@@hasFocus: $hasFocus');
                  widget.onFocusChange(hasFocus);
                },
                child: TextField(
                  // focusNode: _focusNode,
                  controller: _controller,
                  minLines: 1,
                  maxLines: 3,
                  scrollPadding: EdgeInsets.zero,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: localizations.translate('say_something'),
                    hintStyle: const TextStyle(color: Color(0xff5f6279)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff5f6279)),
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
                              decoration: const BoxDecoration(
                                color: Color(0xff5f6279),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
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
            ),
            UserInfoConsumer(
              child: (info, isVIP, isGuest, isLoading) {
                return TextButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      if (isGuest) {
                        showConfirmDialog(
                          context: context,
                          title: '',
                          message: localizations.translate('please_login'),
                          showCancelButton: true,
                          showConfirmButton: true,
                          cancelButtonText: localizations.translate('cancel'),
                          confirmButtonText: localizations.translate('login'),
                          onCancel: () {
                            Navigator.of(context).pop();
                          },
                          onConfirm: () {
                            Navigator.of(context).pop();
                            MyRouteDelegate.of(context).push(AppRoutes.login);
                          },
                        );
                        return;
                      }
                      widget.onSend(_controller.text);
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    }
                  },
                  child: Text(localizations.translate('send'),
                      style: TextStyle(
                        color: _controller.text.isNotEmpty
                            ? Colors.white
                            : Colors.grey,
                      )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
