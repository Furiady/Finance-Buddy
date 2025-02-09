import 'package:flutter/material.dart';

class AutocompleteComponent extends StatelessWidget {
  final TextEditingController controller;
  final List<String> options;
  final String hintText;
  final String labelText;
  final bool readOnly;
  final TextEditingValue? initialValue;

  const AutocompleteComponent({
    required this.controller,
    required this.options,
    required this.hintText,
    required this.labelText,
    this.readOnly = false,
    this.initialValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      initialValue: initialValue,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          readOnly: readOnly,
          onChanged: (value) => controller.text = value,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
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
            suffixIcon: GestureDetector(
              onTap: () {
                focusNode.requestFocus(); // Refocus the field
              },
              child: const Icon(Icons.arrow_drop_down),
            ),
          ),
        );
      },
    );
  }
}
