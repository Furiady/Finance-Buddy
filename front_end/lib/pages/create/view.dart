import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front_end/components/autocomplete-component/view.dart';
import 'package:front_end/components/date-picker-component/view.dart';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/components/form-component/view.dart';
import 'package:front_end/components/image-picker-component/view.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  File? _selectedImage;
  TextEditingController _typeController = TextEditingController();
  DateTime? _date;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _deductFormController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final List<String> _optionsCategory = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'Pineapple',
    'Watermelon',
  ];
  final List<String> _optionsDeductForm = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'Pineapple',
    'Watermelon',
  ];
  bool isDigit(String char) {
    return int.tryParse(char) != null;
  }

  Future<void> ocrReaderTotalReceipt(File image, TextEditingController _amountController) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
      String extractedAmount = '';

      final String text = recognizedText.text.toString().toLowerCase();
      if (text.contains("total")) {
        // Find the start index after "total"
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

        int totalInt = int.parse(totalStringOnlyDigits);

        if (totalInt != 0) {
          try {
            _amountController.text = totalInt.toString();
          } catch (e) {
            showErrorAlert("Error read the total");
          }
        }
      }
      if (extractedAmount.isEmpty) {
        showErrorAlert("No total amount found in the image.");
      }
    } catch (e) {
      showErrorAlert("Error processing image for OCR: $e");
    } finally {
      textRecognizer.close();
    }
  }

  void showErrorAlert(String message) {
    showDialog(
      context: navigatorKey.currentContext!,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          // Close the keyboard when tapping outside of input fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Add some padding for better UX
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButtonComponent(
                    text: "Expanses",
                    onPressed: () {
                      _typeController.text = "expanses";
                    },
                  ),
                  ElevatedButtonComponent(
                    text: "Income",
                    onPressed: () {
                      _typeController.text = "income";
                    },
                  )
                ],
              ),
              SizedBox(height: 16),
              ImagePickerComponent(
                width: 300,
                height: 300,
                selectedImage: _selectedImage,
                onImageChanged: (newImage) {
                  setState(() {
                    _selectedImage = newImage;
                  });

                  if (newImage != null) {
                    ocrReaderTotalReceipt(newImage, _amountController);
                  }
                },
              ),
              SizedBox(height: 16),
              DatePickerComponent(
                onChanged: (date) {
                  setState(() {
                    _date = date;
                  });
                },
              ),
              SizedBox(height: 16),
              FormComponent(
                controller: _titleController,
                labelText: "Title",
              ),
              SizedBox(height: 16),
              AutocompleteComponent(
                label: 'Category',
                controller: _categoryController,
                options: _optionsCategory,
                hintText: 'Type to search fruits',
              ),
              SizedBox(height: 16),
              AutocompleteComponent(
                label: 'Deduct Form',
                controller: _deductFormController,
                options: _optionsDeductForm,
                hintText: 'Type to search fruits',
              ),
              SizedBox(height: 16),
              FormComponent(
                controller: _amountController,
                labelText: "Amount",
              ),
              SizedBox(height: 16),
              FormComponent(
                controller: _descriptionController,
                labelText: "Description",
              ),
              SizedBox(height: 16),
              ElevatedButtonComponent(
                text: "Create",
                onPressed: () {
                  // Add your create logic here
                },
              ),
            ],
          ),
        ),
      );
  }
}