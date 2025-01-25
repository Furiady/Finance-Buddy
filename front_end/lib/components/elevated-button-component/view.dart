import 'package:flutter/material.dart';

class ElevatedButtonComponent extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Clip? clipBehavior;
  final double? width;
  final double? height;
  final ButtonStyle? style;

  const ElevatedButtonComponent({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.fontSize,
    this.padding,
    this.elevation,
    this.clipBehavior,
    this.height,
    this.width,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        clipBehavior: clipBehavior,
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 16.0,
          ),
        ),
      ),
    );
  }
}

//
// class Create extends StatefulWidget {
//   const Create({super.key});
//
//   @override
//   State<Create> createState() => _CreateState();
// }
//
// class _CreateState extends State<Create> {
//   final CreateRecordViewModel viewModel = CreateRecordViewModel();
//   bool isExpense = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Add Transaction",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           backgroundColor: Colors.blue,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Expense/Income Toggle Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => setState(() => isExpense = true),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       width: MediaQuery.of(context).size.width * 0.45,
//                       decoration: BoxDecoration(
//                         color: isExpense ? Colors.red : Colors.white,
//                         border: Border.all(color: Colors.red),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Expense",
//                           style: TextStyle(
//                             fontSize: isExpense ? 18 : 16,
//                             color: isExpense ? Colors.white : Colors.red,
//                             fontWeight: isExpense ? FontWeight.bold : FontWeight.normal,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => setState(() => isExpense = false),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       width: MediaQuery.of(context).size.width * 0.45,
//                       decoration: BoxDecoration(
//                         color: isExpense ? Colors.white : Colors.green,
//                         border: Border.all(color: Colors.green),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Income",
//                           style: TextStyle(
//                             fontSize: isExpense ? 16 : 18,
//                             color: isExpense ? Colors.green : Colors.white,
//                             fontWeight: isExpense ? FontWeight.normal : FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               if (isExpense)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Scan Your Transaction Bill",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black87,
//                         letterSpacing: 0.1,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Card(
//                       elevation: 10,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       shadowColor: Colors.black26,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [Colors.white, Colors.blueGrey[50]!],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 24.0, horizontal: 20.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 width: double.infinity,
//                                 height: 220,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(
//                                     color: Colors.grey[300]!,
//                                     width: 2,
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.1),
//                                       blurRadius: 12,
//                                       offset: const Offset(0, 6),
//                                     ),
//                                   ],
//                                   gradient: LinearGradient(
//                                     colors: [Colors.white, Colors.grey[200]!],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(16),
//                                   child: ImagePickerComponent(
//                                     width: double.infinity,
//                                     height: 220,
//                                     selectedImage: viewModel.selectedImage,
//                                     onImageChanged: (newImage) {
//                                       setState(() => viewModel.selectedImage = newImage);
//                                       if (newImage != null) {
//                                         viewModel.ocrReaderTotalReceipt(
//                                             newImage,
//                                             viewModel.valueController,
//                                             context);
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               const Text(
//                                 "Upload your receipt to an easier way of recording transaction",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 16),
//                   FormComponent(
//                     controller: viewModel.titleController,
//                     labelText: "Title",
//                     hintText: "Title",
//                   ),
//                   const SizedBox(height: 16),
//                   DatePickerComponent(
//                     labelText: "Date",
//                     onChanged: (date) => setState(() => date = date),
//                   ),
//                   const SizedBox(height: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (!isExpense)
//                         AutocompleteComponent(
//                           labelText: "Category",
//                           controller: viewModel.categoryController,
//                           options: viewModel.optionsCategory,
//                           hintText: "Select or type",
//                         )
//                       else
//                         Row(
//                           children: [
//                             Expanded(
//                               child: AutocompleteComponent(
//                                 labelText: "Category",
//                                 controller: viewModel.categoryController,
//                                 options: viewModel.optionsCategory,
//                                 hintText: "Select or type",
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: AutocompleteComponent(
//                                 labelText: "Source of fund",
//                                 controller: viewModel.deductFromController,
//                                 options: viewModel.optionsCategory,
//                                 hintText: "Source of fund",
//                               ),
//                             ),
//                           ],
//                         ),
//                       const SizedBox(height: 16),
//                     ],
//                   ),
//                   FormComponent(
//                     controller: viewModel.valueController,
//                     labelText: "Amount",
//                     hintText: "Amount",
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 16),
//                   FormComponent(
//                     controller: viewModel.descriptionController,
//                     labelText: "Description",
//                     hintText: "Description",
//                     keyboardType: TextInputType.multiline,
//                     minLines: 3,
//                     maxLines: 6,
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//
//               // Save Button
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     viewModel.createRecord(context);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.blue.shade600, Colors.blue.shade900],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.blue.shade300.withOpacity(0.5),
//                           offset: const Offset(0, 6),
//                           blurRadius: 10,
//                         ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 15, horizontal: 80),
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.add,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           "Save Transaction",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
