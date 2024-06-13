import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  final IconData iconData; // The icon to display
  final double size; // Size of the icon (optional)
  final Color backgroundColor; // Color of the icon (optional)
  final VoidCallback onPressed; // Function to execute on press
  final double width, height;

  const ButtonIcon(
      {Key? key,
      required this.iconData,
      this.size = 24.0, // Default size
      this.backgroundColor =
          Colors.white, // Default color is inherited from theme
      required this.onPressed,
      this.width = 48,
      this.height = 48})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(0)
        ),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: Icon(
            iconData,
            size: size,
          ),
        ),
      ),
    );
  }
}
