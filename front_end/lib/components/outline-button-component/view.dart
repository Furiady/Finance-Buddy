import 'package:flutter/material.dart';

class OutlinedButtonComponent extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? borderWidth;

  const OutlinedButtonComponent({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: color ?? Theme.of(context).primaryColor,
          width: borderWidth ?? 1.0,
        ),
        padding: padding,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Theme.of(context).primaryColor,
          fontSize: fontSize ?? 16.0,
        ),
      ),
    );
  }
}
