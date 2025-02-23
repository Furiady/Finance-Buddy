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
  bool isExpense = true;
  bool isLoading= false;
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

  Future<void> ocrReaderTotalReceipt(File image, TextEditingController valueController, BuildContext context) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String text = recognizedText.text.toLowerCase();

      // Ensure we only process numbers AFTER the first occurrence of "total"
      int totalIndex = text.indexOf("total");
      if (totalIndex == -1) {
        _showErrorAlert(context, "Keyword 'total' not found in the receipt.");
        return;
      }

      // Extract only the relevant portion of text after "total"
      String relevantText = text.substring(totalIndex);

      // Extract all numeric values (supports formats like Rp 8.000, 1,500,000, 500.00)
      RegExp regex = RegExp(r'(\d[\d,.]*)');
      Iterable<Match> matches = regex.allMatches(relevantText);

      List<int> extractedNumbers = [];

      for (Match match in matches) {
        String rawNumber = match.group(0) ?? '';

        // Remove non-numeric characters (except numbers)
        String cleanedNumber = rawNumber.replaceAll(RegExp(r'[^0-9]'), '');

        // Ignore numbers with more than 10 digits
        if (cleanedNumber.length > 10) {
          continue;
        }

        if (cleanedNumber.isNotEmpty) {
          extractedNumbers.add(int.parse(cleanedNumber));
        }
      }

      if (extractedNumbers.isEmpty) {
        _showErrorAlert(context, "No valid monetary values found after 'total'.");
        return;
      }

      // Sort in descending order
      extractedNumbers.sort((b, a) => a.compareTo(b));

      // Get the two highest values
      int highest = extractedNumbers[0];
      int secondHighest = extractedNumbers.length > 1 ? extractedNumbers[1] : 0;

      // Determine total based on logic
      int totalValue;
      if (extractedNumbers.contains(highest - secondHighest)) {
        totalValue = secondHighest;
      } else {
        totalValue = highest;
      }

      // Update UI with detected total
      valueController.text = totalValue.toString();
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
