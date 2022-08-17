import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/styles.dart';

// class VDModals extends StatelessWidget {
//   const VDModals({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

Future<void> vdModals({
  required BuildContext context,
  String title = '',
  String content = '',
  VoidCallback? onTap,
  List<Widget>? actions,
}) async {
  return showDialog(
    context: context,
    builder: (_ctx) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        titlePadding: EdgeInsets.zero,
        title: null,
        contentPadding: EdgeInsets.zero,
        content: Container(
          height: 150,
          padding:
              const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                content,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 16,
              ),
              (actions == null || actions.isEmpty)
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (onTap != null) {
                          onTap();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: color1,
                        ),
                        child: const Text('確認'),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: actions,
                    ),
            ],
          ),
        ),
      );
    },
  );
}
