import 'package:flutter/material.dart';

class ElevatedButtonComponent extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? textColor;
  final double? fontSize;
  final double? elevation;
  final Clip? clipBehavior;
  final double? width;
  final double? height;
  final ButtonStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const ElevatedButtonComponent({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.textColor,
    this.fontSize,
    this.elevation,
    this.clipBehavior,
    this.height,
    this.width,
    this.style,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        clipBehavior: clipBehavior ?? Clip.none,
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 16.0,
              ),
            ),
            if (suffixIcon != null) ...[
              const SizedBox(width: 8),
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
