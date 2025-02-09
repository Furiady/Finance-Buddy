import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormComponent extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? labelText;
  final bool expands;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const FormComponent(
      {super.key,
      this.controller,
      this.hintText,
      this.keyboardType,
      this.obscureText = false,
      this.prefixIcon,
      this.suffixIcon,
      this.onChanged,
      this.labelText,
      this.inputFormatters,
      this.expands = false,
      this.maxLines,
      this.minLines,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: obscureText,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      expands: expands,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: readOnly ? Colors.grey[200] : null,
        filled: readOnly,
        focusedBorder: readOnly
            ? OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        )
            : Theme.of(context).inputDecorationTheme.focusedBorder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
