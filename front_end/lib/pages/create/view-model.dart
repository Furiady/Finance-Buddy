import 'package:flutter/material.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:front_end/services/record-services/create-record-services.dart';
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

  Future<void> ocrReaderTotalReceipt(File image,
      TextEditingController valueController, BuildContext context) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String extractedValue = '';

      final String text = recognizedText.text.toLowerCase();

      if (text.contains("total")) {
        for (TextBlock block in recognizedText.blocks) {
          final String blockText = block.text.toLowerCase();

          if (blockText.contains("total")) {
            final startIndex = blockText.indexOf("total") + "total".length;

            String totalString = "";
            for (int i = startIndex; i < blockText.length; i++) {
              if (i + 3 <= blockText.length &&
                  blockText.substring(i, i + 3) == ",00") {
                break;
              }
              if (blockText[i] == '\n') {
                break;
              }
              totalString += blockText[i];
            }

            String totalStringOnlyDigits = "";
            for (int i = 0; i < totalString.length; i++) {
              if (RegExp(r'[0-9]').hasMatch(totalString[i])) {
                totalStringOnlyDigits += totalString[i];
              }
            }

            if (totalStringOnlyDigits.isNotEmpty) {
              extractedValue = totalStringOnlyDigits;
              break; // Stop after finding the first match
            }
          }
        }

        int totalInt = int.tryParse(extractedValue) ?? 0;

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
