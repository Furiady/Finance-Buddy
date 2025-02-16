import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/pages/shop/view-model.dart';

class ListItem extends StatefulWidget {
  final String type;

  const ListItem({super.key, required this.type});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  ShopViewModel viewModel = ShopViewModel();

  Future<void> fetchShopItems({required String type}) async {
    try {
      setState(() {
        viewModel.isLoading = true;
      });
      viewModel.shopItems = await viewModel.shopService
          .getShopItemsByType(context: context, type: type);
    } catch (e) {
      setState(() {
        viewModel.errorMessage = e.toString();
      });
    } finally {
      setState(() {
        viewModel.isLoading = false;
      });
    }
  }

  void buyItem(String itemId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: viewModel.isBuying
                  ? const SizedBox(
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const Text("Are you sure you want to buy this item?"),
              actions: [
                TextButton(
                  onPressed: viewModel.isBuying
                      ? null
                      : () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: viewModel.isBuying
                      ? null
                      : () async {
                          setState(() {
                            viewModel.isBuying = true;
                          });

                          await viewModel.shopService.buyShopItemByType(
                            type: widget.type,
                            itemId: itemId,
                            context: context,
                          );

                          setState(() {
                            viewModel.isBuying = false;
                          });

                          if (mounted) {
                            Navigator.of(context).pop(); // Close dialog
                          }
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.white),
                  ),
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
    fetchShopItems(type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return viewModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: viewModel.shopItems.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: viewModel.shopItems[index].status
                              ? Colors.green
                              : Colors.red,
                          child: Image.asset(
                            viewModel.shopItems[index].path,
                            height: 120,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        viewModel.shopItems[index].name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ElevatedButtonComponent(
                          text: viewModel.shopItems[index].status
                              ? "Use"
                              : viewModel.shopItems[index].price.toString(),
                          onPressed: () {
                            if (!viewModel.shopItems[index].status) {
                              buyItem(viewModel.shopItems[index].id);
                            }
                          },
                          suffixIcon: viewModel.shopItems[index].status
                              ? null
                              : const Icon(
                                  CupertinoIcons.money_dollar_circle_fill,
                                  color: Colors.yellowAccent,
                                ),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.blue),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
