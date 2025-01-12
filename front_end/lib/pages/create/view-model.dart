import 'package:flutter/material.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:front_end/services/create-record-services/create-record-services.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

class CreateRecordViewModel {
  final CreateRecordService recordService = CreateRecordService();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final valueController = TextEditingController();
  final descriptionController = TextEditingController();
  final deductFromController = TextEditingController();
  late String selectedType = 'Expense';
  late DateTime date = DateTime.now();
  File? selectedImage;
  final List<String> optionsCategory = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'Pineapple',
    'Watermelon',
  ];
  final List<String> optionsDeductForm = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'Pineapple',
    'Watermelon',
  ];

  Future<void> createRecord(BuildContext context) async {
    final record = RecordModel(
      type: selectedType,
      title: titleController.text,
      category: categoryController.text,
      value: int.parse(valueController.text),
      date: _formatDate(date),
      description: descriptionController.text,
      deductFrom: selectedType == 'expense' ? deductFromController.text : null,
    );

    await recordService.createRecord(record, context);
    formKey.currentState!.reset();
    selectedType = 'Expense';
    date = DateTime.now();
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyyMMdd');
    return formatter.format(date);
  }

  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    valueController.dispose();
    descriptionController.dispose();
    deductFromController.dispose();
  }

  Future<void> ocrReaderTotalReceipt(File image, TextEditingController valueController, BuildContext context) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extractedValue = '';

      final String text = recognizedText.text.toLowerCase();
      if (text.contains("total")) {
        final startIndex = text.indexOf("total") + "total".length;

        String totalString = "";
        for (int i = startIndex; i < text.length; i++) {
          if (text.substring(i, i + 3) == ",00" || text[i] == '\n') {
            break;
          }
          totalString += text[i];
        }

        String totalStringOnlyDigits = "";
        for (int i = 0; i < totalString.length; i++) {
          if (totalString[i].contains(RegExp(r'[0-9]'))) {
            totalStringOnlyDigits += totalString[i];
          }
        }

        int totalInt = int.tryParse(totalStringOnlyDigits) ?? 0;

        if (totalInt != 0) {
          valueController.text = totalInt.toString();
        } else {
          _showErrorAlert(context, "Error reading the total.");
        }
      }

      if (extractedValue.isEmpty) {
        _showErrorAlert(context, "No total value found in the image.");
      }
    } catch (e) {
      _showErrorAlert(context, "Error processing image for OCR: $e");
    } finally {
      textRecognizer.close();
    }
  }

  void _showErrorAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error", style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}