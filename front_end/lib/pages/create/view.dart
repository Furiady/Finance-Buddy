import 'dart:io';
import 'package:flutter/material.dart';
import 'package:front_end/components/autocomplete-component/view.dart';
import 'package:front_end/components/date-picker-component/view.dart';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/components/form-component/view.dart';
import 'package:front_end/components/image-picker-component/view.dart';
import 'package:front_end/pages/create/view-model.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final CreateRecordViewModel viewModel = CreateRecordViewModel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close the keyboard when tapping outside of input fields
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: viewModel.formKey,
              child: Row(
                children: [
                  ElevatedButtonComponent(
                    text: "Expense",
                    onPressed: () {
                      viewModel.selectedType = "Expense";
                    },
                  ),
                  ElevatedButtonComponent(
                    text: "Income",
                    onPressed: () {
                      viewModel.selectedType = "Income";
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            ImagePickerComponent(
              width: 300,
              height: 300,
              selectedImage: viewModel.selectedImage,
              onImageChanged: (newImage) {
                setState(() {
                  viewModel.selectedImage = newImage;
                });

                if (newImage != null) {
                  viewModel.ocrReaderTotalReceipt(newImage, viewModel.valueController, context);
                }
              },
            ),
            SizedBox(height: 16),
            DatePickerComponent(
              onChanged: (date) {
                setState(() {
                  date = date;
                });
              },
            ),
            SizedBox(height: 16),
            FormComponent(
              controller: viewModel.titleController,
              labelText: "Title",
            ),
            SizedBox(height: 16),
            AutocompleteComponent(
              label: 'Category',
              controller: viewModel.categoryController,
              options: viewModel.optionsCategory,
              hintText: 'Type to search fruits',
            ),
            SizedBox(height: 16),
            AutocompleteComponent(
              label: 'Deduct Form',
              controller: viewModel.deductFromController,
              options: viewModel.optionsDeductForm,
              hintText: 'Type to search fruits',
            ),
            SizedBox(height: 16),
            FormComponent(
              controller: viewModel.valueController,
              labelText: "Value",
            ),
            SizedBox(height: 16),
            FormComponent(
              controller: viewModel.descriptionController,
              labelText: "Description",
            ),
            SizedBox(height: 16),
            ElevatedButtonComponent(
              text: "Create",
              onPressed: () {
                viewModel.createRecord(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
