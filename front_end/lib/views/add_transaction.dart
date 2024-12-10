import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AddTransactionPage extends StatefulWidget {
  final List<String> kategoriList;

  const AddTransactionPage({super.key, required this.kategoriList});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate = DateTime.now(); // Default tanggal adalah hari ini

  // Date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Save transaction
  void _saveTransaction(String type) {
    final double? amount = double.tryParse(_amountController.text.replaceAll(',', ''));
    if (amount != null && _selectedCategory != null && _selectedDate != null) {
      Navigator.pop(context, {
        'tipe': type,
        'jumlah': amount,
        'kategori': _selectedCategory,
        'note': _noteController.text,
        'waktu': _selectedDate!,
        'warna': type == 'Income' ? Colors.green : Colors.red,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Widget _buildRow({required String icon, required String label, required Widget child}) {
    return Row(
      children: [
        Image.asset(icon, height: 40, width: 40), // Ikon besar
        const SizedBox(width: 15), // Jarak antara ikon dan elemen input
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              child,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // Kotak putih
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Transaction Date Picker with Icon
                      _buildRow(
                        icon: 'assets/calendar (1).png',
                        label: 'Pick transaction Date',
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat.yMMMd().format(_selectedDate!),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const Divider(),

                      // Category Dropdown with Icon
                      _buildRow(
                        icon: 'assets/categories (1).png',
                        label: 'Select a Category',
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration.collapsed(hintText: ''),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          },
                          items: widget.kategoriList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 16)),
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(),

                      // Amount Input with Icon
                      _buildRow(
                        icon: 'assets/money.png',
                        label: 'Input Amount',
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration.collapsed(hintText: ''),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(fontSize: 16),
                          inputFormatters: [ThousandsSeparatorFormatter()], // Apply formatter here
                        ),
                      ),
                      const Divider(),

                      // Note Input with Icon
                      _buildRow(
                        icon: 'assets/notepad.png',
                        label: 'Input Notes',
                        child: TextField(
                          controller: _noteController,
                          decoration: const InputDecoration.collapsed(hintText: ''),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Save Income and Expense Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                      ),
                      onPressed: () => _saveTransaction('Income'),
                      child: const Text('INCOME'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                      ),
                      onPressed: () => _saveTransaction('Expense'),
                      child: const Text('EXPENSE'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Add Photo Button
          Positioned(
            bottom: keyboardHeight > 0 ? keyboardHeight + -200 : 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Handle photo addition
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add_a_photo, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom TextInputFormatter for thousands separator
class ThousandsSeparatorFormatter extends TextInputFormatter {
  final _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the number with commas
    if (newText.isEmpty) {
      return TextEditingValue(text: '', selection: newValue.selection);
    }

    // Parse the number and format it
    final formattedText = _formatter.format(int.parse(newText));

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
