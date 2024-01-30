import 'package:app_wl_cn1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import '../../widgets/auth_text_field_suffixicon.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String placeholderText;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final bool obscureText;
  final void Function(String)? onChanged;

  const AuthTextField({
    Key? key,
    required this.label,
    required this.placeholderText,
    this.validator,
    required this.controller,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);

  @override
  AuthTextFieldState createState() => AuthTextFieldState();
}

class AuthTextFieldState extends State<AuthTextField> {
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          child: TextFormField(
            key: widget.key,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            obscureText: widget.obscureText,
            validator: widget.validator,
            controller: widget.controller,
            onChanged: widget.onChanged,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.colors[ColorKeys.textPrimary],
            ),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xff3f4253),
              isDense: true,
              hintText: widget.placeholderText,
              hintStyle: TextStyle(
                color: AppColors.colors[ColorKeys.textPlaceholder],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              errorStyle: const TextStyle(color: Color(0xFFFF0000)),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: AuthTextFieldSuffixIcon(
                  controller: widget.controller,
                ),
              ),
              suffixIconConstraints:
                  const BoxConstraints(minHeight: 15, minWidth: 15),
            ),
          ),
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              setState(() {
                _autoValidate = true;
              });
            }
          },
        ),
      ],
    );
  }
}
