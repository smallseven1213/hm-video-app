import 'package:flutter/material.dart';
import 'auth_text_field_suffixicon.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String placeholderText;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final bool obscureText;
  final void Function(String)? onChanged;

  const AuthTextField({
    Key? key,
    required this.label,
    required this.placeholderText,
    required this.validator,
    required this.controller,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 38,
              padding: const EdgeInsets.only(top: 2),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Container(
              height: 60,
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    key: key,
                    obscureText: obscureText,
                    validator: validator,
                    controller: controller,
                    onChanged: onChanged,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: placeholderText,
                      hintStyle: TextStyle(
                          color: const Color(0xFFFFFF).withOpacity(0.3)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xFF21AFFF), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xFF21AFFF), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xFF21AFFF), width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xFFFF0000), width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                            color: Color(0xFFFF0000), width: 1),
                      ),
                      errorStyle: const TextStyle(color: Color(0xFFFF0000)),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: AuthTextFieldSuffixIcon(
                          controller: controller,
                        ),
                      ),
                      suffixIconConstraints:
                          const BoxConstraints(minHeight: 15, minWidth: 15),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }
}
