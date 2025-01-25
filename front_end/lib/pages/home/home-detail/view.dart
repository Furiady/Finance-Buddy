import 'package:flutter/material.dart';
import 'package:front_end/components/autocomplete-component/view.dart';
import 'package:front_end/components/date-picker-component/view.dart';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/components/form-component/view.dart';
import 'package:front_end/components/image-picker-component/view.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/pages/home/home-detail/view-model.dart';
import 'package:intl/intl.dart';

class HomeDetail extends StatefulWidget {
  final RecordModel record;
  const HomeDetail({super.key, required this.record});

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  final HomeDetailViewModel viewModel = HomeDetailViewModel();
  bool isExpense = true;
  @override
  void initState() {
    super.initState();
    viewModel.categoryController.text = widget.record.category;
    viewModel.deductFromController.text = widget.record.deductFrom ?? '';
    viewModel.descriptionController.text = widget.record.description ?? '';
    viewModel.titleController.text = widget.record.title;
    viewModel.valueController.text = widget.record.value.toString();
    viewModel.typeController.text = widget.record.type;
    viewModel.dateController.text = DateFormat('dd/MM/yyyy').format(widget.record.date);
    isExpense = widget.record.type == "Expense";

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Transaction Record Detail",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.white, // Red color for the delete icon
              onPressed: () {
                // Handle the delete action
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isExpense)
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 220,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.grey[200]!],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: ImagePickerComponent(
                                    width: double.infinity,
                                    height: 220,
                                    selectedImage: viewModel.selectedImage,
                                    onImageChanged: (newImage) {
                                      setState(() =>
                                      viewModel.selectedImage = newImage);
                                      if (newImage != null) {
                                        viewModel.ocrReaderTotalReceipt(
                                            newImage,
                                            viewModel.valueController,
                                            context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Upload your receipt to an easier way of recording transaction",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
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
                  FormComponent(
                    controller : viewModel.typeController,
                    labelText: "Type",
                    hintText: "Type",
                  ),
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
                      if (!isExpense)
                        AutocompleteComponent(
                          labelText: "Category",
                          hintText: "Select or type",
                          controller: viewModel.categoryController,
                          options: viewModel.optionsCategory,
                          initialValue: viewModel.categoryController.value,
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: AutocompleteComponent(
                                labelText: "Category",
                                hintText: "Select or type",
                                controller: viewModel.categoryController,
                                options: viewModel.optionsCategory,
                                initialValue: viewModel.categoryController.value,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AutocompleteComponent(
                                labelText: "Source of fund",
                                hintText: "Source of fund",
                                controller: viewModel.deductFromController,
                                options: viewModel.optionsCategory,
                                initialValue: viewModel.deductFromController.value,
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
                text: "Save Transaction",
                onPressed: () {
                  viewModel.createRecord(context);
                },
                width: MediaQuery.of(context).size.width,
                height: 50,
                style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                    WidgetStateProperty.all<Color>(Colors.blue),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.blue)))),
                color: Colors.blue,
                textColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
