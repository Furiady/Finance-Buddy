import 'package:date_format_field/date_format_field.dart';
import 'package:flutter/material.dart';

class DatePickerComponent extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final dynamic Function(DateTime?) onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerComponent({
    super.key,
    this.controller,
    required this.onChanged,
    this.labelText,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return  DateFormatField(
      type: DateFormatType.type2,
      controller: controller,
      addCalendar: true,
      firstDate: firstDate,
      lastDate: lastDate,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        // border: InputBorder.none,
        labelText: labelText,
        hintText: "DD/MM/YYYY"
      ),
      onComplete: onChanged
    );
  }
}
