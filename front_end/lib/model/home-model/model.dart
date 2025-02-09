// Model class for income and expense
class IncomeExpenseModel {
  final int income;
  final int expense;

  IncomeExpenseModel({required this.income, required this.expense});

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'income': income,
      'expense': expense,
    };
  }
}
