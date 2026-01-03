import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? textColor;

  const CustomButton({
    required this.label,
    required this.onPressed,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
