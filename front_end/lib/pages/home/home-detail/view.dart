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
  bool editable = false;

  void showDeleteConfirmationDialog(
      {required BuildContext context, required String id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Delete Record"),
              content: viewModel.loading
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Deleting record..."),
                      ],
                    )
                  : const Text("Are you sure you want to delete this record?"),
              actions: [
                if (!viewModel.loading)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                TextButton(
                  onPressed: viewModel.loading
                      ? null
                      : () async {
                          setState(() {
                            viewModel.loading = true;
                          });
                          await viewModel.deleteRecordService
                              .deleteRecord(context: context, id: id);
                          setState(() {
                            viewModel.loading = false;
                          });
                        },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
              color: Colors.white,
              onPressed: () => showDeleteConfirmationDialog(
                  context: context, id: widget.record.id),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!editable)
                ElevatedButtonComponent(
                  text: "Edit Transaction",
                  prefixIcon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      editable = true;
                    });
                  },
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.green),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.green),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.green)))),
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                ),
              const SizedBox(height: 15),
              if (isExpense)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(editable)
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
                          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                          child: ImagePickerComponent(
                            width: double.infinity,
                            height: 220,
                            selectedImage: viewModel.selectedImage,
                            onImageChanged: (newImage) {
                              setState(() => viewModel.selectedImage = newImage);
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
                  FormComponent(
                    controller: viewModel.typeController,
                    labelText: "Type",
                    hintText: "Type",
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  FormComponent(
                    controller: viewModel.titleController,
                    labelText: "Title",
                    hintText: "Title",
                    readOnly: !editable,
                  ),
                  const SizedBox(height: 16),
                  DatePickerComponent(
                    labelText: "Date",
                    controller: viewModel.dateController,
                    onChanged: (date) => setState(() => date = date),
                    readOnly: !editable,
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
                          readOnly: !editable,
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
                                initialValue:
                                    viewModel.categoryController.value,
                                readOnly: !editable,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AutocompleteComponent(
                                labelText: "Source of fund",
                                hintText: "Source of fund",
                                controller: viewModel.deductFromController,
                                options: viewModel.optionsCategory,
                                initialValue:
                                    viewModel.deductFromController.value,
                                readOnly: !editable,
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
                    readOnly: !editable,
                  ),
                  const SizedBox(height: 16),
                  FormComponent(
                    controller: viewModel.descriptionController,
                    labelText: "Description",
                    hintText: "Description",
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                    readOnly: !editable,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              if (editable)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButtonComponent(
                      text: "Cancel",
                      onPressed: () {
                        setState(() {
                          editable = false;
                        });
                      },
                      width: MediaQuery.of(context).size.width/2.5,
                      height: 50,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.red),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 120),
                    ),
                    ElevatedButtonComponent(
                      text: "Save",
                      onPressed: () {
                        viewModel.updateRecord(context);
                      },
                      width: MediaQuery.of(context).size.width/2.5,
                      height: 50,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 120),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
