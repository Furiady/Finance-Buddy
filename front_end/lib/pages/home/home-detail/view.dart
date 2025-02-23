import 'package:flutter/material.dart';
import 'package:front_end/components/autocomplete-component/view.dart';
import 'package:front_end/components/date-picker-component/view.dart';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/components/form-component/view.dart';
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

  Future<void> updateRecord(BuildContext context, String id) async {
    setState(() {
      viewModel.isLoadingUpdate = true;
    });
    final DateFormat formatter = DateFormat('yyyyMMdd');
    final record = RecordModel(
      type: viewModel.selectedType,
      title: viewModel.titleController.text,
      category: viewModel.categoryController.text,
      value: int.parse(viewModel.valueController.text),
      date: viewModel.date,
      description: viewModel.descriptionController.text,
      deductFrom: viewModel.isExpense ? viewModel.deductFromController.text : null,
      id: id,
    );
    await viewModel.updateRecordService.updateRecord(record, context);
    setState(() {
      viewModel.isLoadingUpdate = false;
    });
  }


  void showDeleteConfirmationDialog(
      {required BuildContext context, required String id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Delete Record"),
              content: viewModel.isLoadingDelete
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
                if (!viewModel.isLoadingDelete)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                TextButton(
                  onPressed: viewModel.isLoadingDelete
                      ? null
                      : () async {
                          setState(() {
                            viewModel.isLoadingDelete = true;
                          });
                          await viewModel.deleteRecordService
                              .deleteRecord(context: context, id: id);
                          setState(() {
                            viewModel.isLoadingDelete = false;
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
    viewModel.isExpense = widget.record.type == "Expense";
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
              if (!viewModel.editable)
                ElevatedButtonComponent(
                  text: "Edit Transaction",
                  prefixIcon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      viewModel.editable = true;
                    });
                  },
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                      foregroundColor: WidgetStateProperty.all<Color>(Colors.green),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.green)))),
                  textColor: Colors.white,
                ),
              const SizedBox(height: 15),
              if (viewModel.isExpense && widget.record.url != null)
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
                        vertical: 24.0,
                        horizontal: 20.0,
                      ),
                      child: Image.network(
                        widget.record.url!, // Load image from URL
                        fit: BoxFit.cover, // Ensures proper scaling
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 50, color: Colors.red);
                        },
                      ),
                    ),
                  ),
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
                    readOnly: !viewModel.editable,
                  ),
                  const SizedBox(height: 16),
                  DatePickerComponent(
                    labelText: "Date",
                    controller: viewModel.dateController,
                    onChanged: (date) => setState(() => date = date),
                    readOnly: !viewModel.editable,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!viewModel.isExpense)
                        AutocompleteComponent(
                          labelText: "Category",
                          hintText: "Select or type",
                          controller: viewModel.categoryController,
                          options: viewModel.optionsCategory,
                          initialValue: viewModel.categoryController.value,
                          readOnly: !viewModel.editable,
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
                                readOnly: !viewModel.editable,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AutocompleteComponent(
                                labelText: "Source of fund",
                                hintText: "Source of fund",
                                controller: viewModel.deductFromController,
                                options: viewModel.optionsDeductForm,
                                initialValue:
                                    viewModel.deductFromController.value,
                                readOnly: !viewModel.editable,
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
                    readOnly: !viewModel.editable,
                  ),
                  const SizedBox(height: 16),
                  FormComponent(
                    controller: viewModel.descriptionController,
                    labelText: "Description",
                    hintText: "Description",
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                    readOnly: !viewModel.editable,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              if (viewModel.editable)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButtonComponent(
                      text: "Cancel",
                      onPressed: () {
                        setState(() {
                          viewModel.editable = false;
                        });
                      },
                      width: MediaQuery.of(context).size.width / 2.5,
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
                    ),
                    ElevatedButtonComponent(
                      text: "Save",
                      isLoading: viewModel.isLoadingUpdate,
                      onPressed: () {
                        updateRecord(context, widget.record.id);
                      },
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 50,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.blue),
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.blue),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                      textColor: Colors.white,
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
