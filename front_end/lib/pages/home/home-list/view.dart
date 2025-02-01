import 'package:flutter/material.dart';
import 'package:front_end/pages/home/home-detail/view.dart';
import 'package:front_end/pages/home/home-list/view-model.dart';
import 'package:front_end/utils/format-currency/format-currency.dart';
import 'package:intl/intl.dart';

class HomeListComponent extends StatefulWidget {
  final String? type;
  final String? category;
  final String headerTitle;

  const HomeListComponent({super.key, this.type, this.category, required this.headerTitle});

  @override
  State<HomeListComponent> createState() => _HomeListComponentState();
}

class _HomeListComponentState extends State<HomeListComponent> {
  final HomeListViewModel viewModel = HomeListViewModel();
  final ScrollController _scrollController = ScrollController();
  DateTime currentDate = DateTime.now();
  int currentPage = 1;
  final int pageSize = 10;
  bool isLoadingMore = false;

  Future<void> fetchRecordsData({
    required DateTime date,
    required int page,
    required int limit,
    bool isPagination = false,
  }) async {
    try {
      if (!isPagination) {
        setState(() {
          viewModel.errorMessage = null;
          viewModel.isLoading = true;
        });
      } else {
        setState(() {
          isLoadingMore = true;
        });
      }

      final newRecords = await viewModel.recordService.getRecords(
        date: date,
        page: page,
        limit: limit,
        type: widget.type,
        category: widget.category,
      );

      setState(() {
        if (isPagination) {
          viewModel.recordsData.addAll(newRecords);
        } else {
          viewModel.recordsData = newRecords;
        }
      });
    } catch (e) {
      setState(() {
        viewModel.errorMessage = e.toString();
      });
    } finally {
      setState(() {
        viewModel.isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore &&
        !viewModel.isLoading) {
      currentPage++;
      fetchRecordsData(
          date: currentDate,
          page: currentPage,
          limit: pageSize,
          isPagination: true);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRecordsData(date: currentDate, page: currentPage, limit: pageSize);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecords =
        viewModel.filterRecordsByMonth(viewModel.recordsData, currentDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.headerTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: viewModel.isLoading && viewModel.recordsData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: filteredRecords.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredRecords.length) {
                  return isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }
                final record = filteredRecords[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0 ||
                        (index > 0 &&
                            DateFormat('MMMM yyyy')
                                    .format(filteredRecords[index].date) !=
                                DateFormat('MMMM yyyy')
                                    .format(filteredRecords[index - 1].date)))
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          DateFormat('MMMM yyyy').format(record.date),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HomeDetail(record: record),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          child: Icon(
                            Icons.fastfood,
                            color: record.type == "Expense"
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        title: Text(record.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(record.category),
                            Text(
                                DateFormat('dd MMMM yyyy').format(record.date)),
                          ],
                        ),
                        trailing: Text(
                          formatCurrency(record.value),
                          style: TextStyle(
                            color: record.type == "Expense"
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
    );
  }
}
