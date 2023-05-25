import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:logger/logger.dart';


final logger = Logger();

class ModalDropDown extends StatefulWidget {
  final List? items;
  final Function? onChanged;
  final BoxDecoration? decoration;
  final bool isLast;
  final String title;
  Function onChange;

  ModalDropDown({
    super.key,
    this.items,
    this.onChanged,
    this.decoration,
    this.title = '',
    this.isLast = false,
    required this.onChange,
  });

  @override
  _ModalDropDownState createState() => _ModalDropDownState();
}

class _ModalDropDownState extends State<ModalDropDown> {
  String _selected = '';
  List _items = [];

  @override
  void initState() {
    super.initState();
    _items = widget.items ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color:
                    widget.isLast ? Colors.transparent : gameLobbyDividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: _selected != '' ? _selected : widget.title,
                  style: TextStyle(
                    color: _selected != ''
                        ? gamePrimaryButtonColor
                        : gameRecordLabelTextColor,
                    fontSize: 14,
                  ),
                ),
                WidgetSpan(
                  child: Icon(
                    _selected != ''
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 16,
                    color: _selected != ''
                        ? gamePrimaryButtonColor
                        : gameRecordLabelTextColor,
                  ),
                ),
              ],
            ),
          )

          // Text(
          //   _selected != '' ? _selected : widget.title,
          //   style: TextStyle(
          //     color: _selected != '' ? const Color(0xffebfe69) : Colors.white,
          //     fontSize: 14,
          //   ),
          //   textDirection: TextDirection.ltr,
          // ),
          ),
      onTap: () => showModal(context),
      // Text('Selected item: $_selected')
    );
  }

  void showModal(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.0),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 20,
          ),
          height: 250,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: gameItemMainColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    top: -10,
                    right: -15,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xff979797),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // onClose!();
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: gameLobbyPrimaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: _items
                        .map((item) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: const BoxDecoration(
                                  // color: Colors.white12,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.white12,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['label'],
                                      style: TextStyle(
                                        color: gameLobbyPrimaryTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (_selected == item['label'])
                                      // return
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xff3de965),
                                      ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                widget.onChange(item['value']);
                                setState(() {
                                  _selected = item['label'];
                                });
                                Navigator.of(context).pop();
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      logger.i('Hey there, I\'m calling after hide bottomSheet');
    });
  }
}
