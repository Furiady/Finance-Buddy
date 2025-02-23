import 'package:flutter/material.dart';
import 'package:front_end/services/record-services/delete-record-services.dart';
import 'package:front_end/services/record-services/update-record-services.dart';

class HomeDetailViewModel {
  final UpdateRecordService updateRecordService = UpdateRecordService();
  final DeleteRecordService deleteRecordService = DeleteRecordService();
  late bool isLoadingDelete = false;
  late bool isLoadingUpdate = false;
  bool isExpense = true;
  bool editable = false;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final valueController = TextEditingController();
  final descriptionController = TextEditingController();
  final deductFromController = TextEditingController();
  final typeController = TextEditingController();
  final dateController = TextEditingController();
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



  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    valueController.dispose();
    descriptionController.dispose();
    deductFromController.dispose();
  }


}
