import 'package:flutter/material.dart';
import 'package:front_end/components/autocomplete-component/view.dart';
import 'package:front_end/components/date-picker-component/view.dart';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/components/form-component/view.dart';
import 'package:front_end/components/image-picker-component/view.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:front_end/pages/create/view-model.dart';
import 'package:intl/intl.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final CreateRecordViewModel viewModel = CreateRecordViewModel();

  Future<void> createRecord(BuildContext context) async {
    setState(() {
      viewModel.isLoading = true;
    });
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final String formattedDate = formatter.format(DateTime.parse(viewModel.dateController.text));

    final record = RecordModel(
        type: viewModel.selectedType,
        title: viewModel.titleController.text,
        category: viewModel.categoryController.text,
        value: int.parse(viewModel.valueController.text),
        date: formattedDate,
        description: viewModel.descriptionController.text,
        deductFrom: viewModel.isExpense ? viewModel.deductFromController.text : null,
        image: viewModel.selectedImage
    );
    await viewModel.recordService.createRecord(record, context);
    setState(() {
      viewModel.isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButtonComponent(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 50,
                    text: "Expense",
                    onPressed: () => setState(() => viewModel.isExpense = true),
                    textColor: viewModel.isExpense ? Colors.white : Colors.red,
                    fontSize: viewModel.isExpense ? 18 : 16,
                    style: ButtonStyle(
                        foregroundColor: viewModel.isExpense
                            ? WidgetStateProperty.all<Color>(Colors.white)
                            : WidgetStateProperty.all<Color>(Colors.red),
                        backgroundColor: viewModel.isExpense
                            ? WidgetStateProperty.all<Color>(Colors.red)
                            : WidgetStateProperty.all<Color>(Colors.white),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.red)))),
                  ),
                  ElevatedButtonComponent(
                    text: "Income",
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 50,
                    onPressed: () => setState(() {viewModel.selectedType = "Income"; viewModel.isExpense = false;}),
                    textColor: viewModel.isExpense ? Colors.green : Colors.white,
                    fontSize: viewModel.isExpense ? 16 : 18,
                    style: ButtonStyle(
                        foregroundColor: viewModel.isExpense
                            ? WidgetStateProperty.all<Color>(Colors.green)
                            : WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor: viewModel.isExpense
                            ? WidgetStateProperty.all<Color>(Colors.white)
                            : WidgetStateProperty.all<Color>(Colors.green),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.green)))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (viewModel.isExpense)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Scan Your Transaction Bill",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      shadowColor: Colors.black26,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blueGrey[50]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24.0, horizontal: 20.0),
                          child: ImagePickerComponent(
                            width: double.infinity,
                            height: 220,
                            selectedImage: viewModel.selectedImage,
                            onImageChanged: (newImage) {
                              setState(
                                  () => viewModel.selectedImage = newImage);
                              if (newImage != null) {
                                viewModel.ocrReaderTotalReceipt(newImage,
                                    viewModel.valueController, context);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  FormComponent(
                    controller: viewModel.titleController,
                    labelText: "Title",
                    hintText: "Title",
                  ),
                  const SizedBox(height: 16),
                  DatePickerComponent(
                    labelText: "Date",
                    controller: viewModel.dateController,
                    onChanged: (date) => setState(() => date = date),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!viewModel.isExpense)
                        AutocompleteComponent(
                          labelText: "Category",
                          controller: viewModel.categoryController,
                          options: viewModel.optionsCategory,
                          hintText: "Select or type",
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: AutocompleteComponent(
                                labelText: "Category",
                                controller: viewModel.categoryController,
                                options: viewModel.optionsCategory,
                                hintText: "Select or type",
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AutocompleteComponent(
                                labelText: "Source of fund",
                                controller: viewModel.deductFromController,
                                options: viewModel.optionsDeductForm,
                                hintText: "Source of fund",
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  FormComponent(
                    controller: viewModel.valueController,
                    labelText: "Amount",
                    hintText: "Amount",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  FormComponent(
                    controller: viewModel.descriptionController,
                    labelText: "Description",
                    hintText: "Description",
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              ElevatedButtonComponent(
                isLoading: viewModel.isLoading,
                text: "Save Transaction",
                onPressed: viewModel.isLoading ? null:() {
                  createRecord(context);
                },
                width: MediaQuery.of(context).size.width,
                height: 50,
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.blue)))),
                textColor: Colors.white,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
