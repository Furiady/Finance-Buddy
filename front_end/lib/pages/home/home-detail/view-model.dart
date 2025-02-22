import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/services/record-services/delete-record-services.dart';
import 'package:front_end/services/record-services/update-record-services.dart';

class HomeDetailViewModel {
  final UpdateRecordService updateRecordService = UpdateRecordService();
  final DeleteRecordService deleteRecordService = DeleteRecordService();
  late bool loading = false;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final valueController = TextEditingController();
  final descriptionController = TextEditingController();
  final deductFromController = TextEditingController();
  final typeController = TextEditingController();
  final dateController = TextEditingController();
  late String selectedType = 'Expense';
  late DateTime date = DateTime.now();
  final String imageUrl="";
  final List<String> optionsCategory = [
    'Food',
    'Transportation',
    'Entertainment',
    'Shopping',
    'Health',
    'Others'
  ];
  final List<String> optionsDeductForm = [
    'Cash',
    'Credit Card',
    'Bank Transfer',
    'Wallet'
  ];

  Future<void> updateRecord(BuildContext context, String id) async {
    final record = RecordModel(
      type: selectedType,
      title: titleController.text,
      category: categoryController.text,
      value: int.parse(valueController.text),
      date: date,
      description: descriptionController.text,
      deductFrom: selectedType == 'expense' ? deductFromController.text : null,
      id: id,
    );
    await updateRecordService.updateRecord(record, context);
    formKey.currentState!.reset();
    selectedType = 'Expense';
    date = DateTime.now();
  }



  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    valueController.dispose();
    descriptionController.dispose();
    deductFromController.dispose();
  }


}
