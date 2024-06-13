import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final inputType;
  final String hintText;
  final bool obsecureText;
  final double fontSize;
  final String label;
  final int maxLines;
  final bool enabled;

  const InputText({
    super.key,
    required this.controller,
    required this.hintText,
    this.obsecureText = false,
    this.fontSize = 12,
    this.label = "",
    this.maxLines = 1,
    this.inputType = TextInputType.none,
    this.enabled = true
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) // Check if label is not null and not empty
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              label,
              style: TextStyle(fontSize: fontSize.toDouble()),
            ),
          ),
        TextField (
          enabled: enabled,
          controller: controller,
          obscureText: obsecureText,
          style: TextStyle(fontSize: fontSize),
          keyboardType: inputType,
          maxLines: maxLines,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 230, 230, 230)),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(249, 184, 215, 1)),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 230, 230, 230)),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            hintText: hintText,
            hoverColor: const Color.fromRGBO(249, 184, 215, 0.4),
            fillColor: enabled ? Colors.white :Colors.grey[100],
            filled: true,
          )
        )
      ],
    );
  }
}