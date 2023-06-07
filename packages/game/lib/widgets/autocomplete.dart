import 'package:flutter/material.dart';
import 'package:game/models/bank.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AutoComplete extends StatefulWidget {
  const AutoComplete(
      {Key? key,
      required this.listContent,
      required this.label,
      required this.hint,
      required this.controller,
      this.onChanged,
      this.errorMessage})
      : super(key: key);
  final List<BankItem> listContent;
  final String label;
  final String hint;
  final TextEditingController controller;
  final Function? onChanged;
  final String? errorMessage;

  @override
  State<AutoComplete> createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<BankItem>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<BankItem>.empty();
        }

        return widget.listContent
            .where((BankItem option) => option.bankName
                .toLowerCase()
                .startsWith(textEditingValue.text.toLowerCase()))
            .toList();
      },
      displayStringForOption: (BankItem option) => option.bankName,
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      color: Color(0xff979797),
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle:
                          TextStyle(color: gameLobbyLoginPlaceholderColor),
                      border: InputBorder.none,
                    ),
                    controller: fieldTextEditingController,
                    onChanged: (value) => {
                      widget.onChanged!(value),
                      widget.controller.text = value
                    },
                    focusNode: fieldFocusNode,
                    style: TextStyle(
                        color: gameLobbyPrimaryTextColor, fontSize: 14),
                    cursorColor: gameLobbyPrimaryTextColor,
                  ),
                ),
                Container(
                  width: 20,
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      fieldTextEditingController.clear();
                    },
                    child: Icon(
                      Icons.cancel,
                      color: gameLobbyIconColor,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              color: widget.errorMessage != null
                  ? Colors.red
                  : gameLobbyDividerColor,
            ),
            if (widget.errorMessage != null)
              SizedBox(
                width: double.infinity,
                child: Text(
                  widget.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
      onSelected: (BankItem selection) {
        logger.i('Selected: ${selection.bankName}');
        widget.controller.text = selection.bankName;
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<BankItem> onSelected,
          Iterable<BankItem> options) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: gameLobbyBgColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              width: 230,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SingleChildScrollView(
                  child: Column(
                    children: options.map((opt) {
                      return GestureDetector(
                        onTap: () {
                          onSelected(opt);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 22),
                          child: Text(
                            opt.bankName,
                            style: TextStyle(
                                color: gameLobbyPrimaryTextColor, fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
