import 'package:flutter/material.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:front_end/services/create-record-services/create-record-services.dart';

class CreateRecordViewModel {
  final CreateRecordService recordService = CreateRecordService();

  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final deductFromController = TextEditingController();

  String selectedType = 'expense'; // Default type

  Future<void> createRecord(BuildContext context) async {
    final record = RecordModel(
      type: selectedType,
      title: titleController.text,
      category: categoryController.text,
      amount: double.parse(amountController.text),
      date: _formatDate(dateController.text),
      description: descriptionController.text,
      deductFrom: selectedType == 'expense' ? deductFromController.text : null,
    );

    await recordService.createRecord(record, context);
  }

  String _formatDate(String dateString) {
    // Assuming dateString is in the format "yyyy-MM-dd" from the DatePicker
    return dateString.replaceAll("-", "");
  }

  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    amountController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    deductFromController.dispose();
  }
}