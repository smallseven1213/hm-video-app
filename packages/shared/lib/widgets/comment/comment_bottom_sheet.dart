import 'package:flutter/material.dart';
import 'package:shared/widgets/comment/input.dart';
import 'package:shared/widgets/comment/list.dart';
import 'package:shared/widgets/ui_bottom_safearea.dart';

class AppColors {
  static const contentText = Color(0xff919bb3);
  static const background = Colors.black;
}

class CommentBottomSheet extends StatefulWidget {
  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  bool showInput = true;

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return UIBottomSafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: showInput ? MediaQuery.of(context).viewInsets.bottom : 16),
        child: Container(
          height: 400,
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '評論',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: CommentList(),
              ),
              CommentInput(
                onFocus: () {
                  setState(() {
                    showInput = true;
                  });
                },
                onSend: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    showInput = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
