import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final TextEditingController inputController;
  final String placeholderText;

  const AuthTextField({
    Key? key,
    required this.label,
    required this.inputController,
    required this.placeholderText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          Expanded(
            child: TextField(
              controller: inputController,
              style: const TextStyle(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: placeholderText,
                hintStyle:
                    TextStyle(color: const Color(0xFFFFFF).withOpacity(0.3)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide:
                      const BorderSide(color: Color(0xFF21AFFF), width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
