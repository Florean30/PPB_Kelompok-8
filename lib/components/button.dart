import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  // ignore: prefer_typing_uninitialized_variables
  final width;
  final IconData icon;
  final bool withIcon;
  final Color iconColor;

  const Button(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.backgroundColor = const Color.fromRGBO(238, 136, 185, 1),
      this.textColor = Colors.white,
      this.fontSize = 16.0,
      this.width,
      this.icon = Icons.abc,
      this.withIcon = false,
      this.iconColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // Make the button take the full width of its parent
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (withIcon)
                Icon(
                  icon,
                  color: iconColor,
                ),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                ),
              ),
            ],
          )),
    );
  }
}
