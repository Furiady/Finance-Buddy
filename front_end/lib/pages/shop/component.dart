import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/pages/shop/view-model.dart';

class ListItem extends StatefulWidget {
  final String type;
  final String buyingPath;
  final String usedItem;
  final Future<void> Function() refreshProfile;

  const ListItem({
    super.key,
    required this.type,
    required this.buyingPath,
    required this.refreshProfile,
    required this.usedItem,
  });

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
        final shopItem = viewModel.shopItems[index];
        final isUsed = widget.usedItem == shopItem.path;
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
                    color: shopItem.status ? Colors.green : Colors.red,
                    child: Image.asset(
                      shopItem.path,
                      height: 90,
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  shopItem.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButtonComponent(
                    text: isUsed
                        ? "Used"
                        : shopItem.status
                        ? "Use"
                        : shopItem.price.toString(),
                    onPressed: isUsed
                        ? () {}
                        : () {
                      print(shopItem.status);
                      if (shopItem.status) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return PopUpChangeItem(
                              changingPath: shopItem.path,
                              refreshDataShopItems: () => fetchShopItems(type: widget.type),
                              refreshDataProfileData: () => widget.refreshProfile(),
                            );
                          },
                        );
                      }else{
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return PopUpBuyItem(
                              itemId: shopItem.id,
                              buyingPath: widget.buyingPath,
                              refreshDataShopItems: () =>
                                  fetchShopItems(
                                      type: widget.type),
                              refreshDataProfileData:
                                  () => widget.refreshProfile(),
                            );
                          },
                        );
                      }
                    },
                    suffixIcon: (isUsed || shopItem.status)
                        ? null
                        : const SizedBox(
                      width: 20,  // 👈 Set width
                      height: 20, // 👈 Set height
                      child: Icon(
                        CupertinoIcons.money_dollar_circle_fill,
                        color: Colors.yellowAccent,
                        size: 20, // 👈 You can also adjust the icon size itself
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all<Color>(
                          isUsed ? Colors.grey : Colors.blue),
                      shape:
                      WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                              color: isUsed ? Colors.grey : Colors.blue),
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

class PopUpBuyItem extends StatefulWidget {
  final String itemId;
  final String buyingPath;
  final Future<void> Function() refreshDataShopItems;
  final Future<void> Function() refreshDataProfileData;

  const PopUpBuyItem({
    super.key,
    required this.itemId,
    required this.buyingPath,
    required this.refreshDataShopItems,
    required this.refreshDataProfileData,
  });

  @override
  State<PopUpBuyItem> createState() => _PopUpBuyItemState();
}

class _PopUpBuyItemState extends State<PopUpBuyItem> {
  final ShopViewModel viewModel = ShopViewModel();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmation"),
      content: viewModel.isBuying
          ? const SizedBox(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Text(viewModel.popUpMessageBuyItem),
      actions: viewModel.isBuying
          ? []
          : () {
              switch (viewModel.popUpMessageBuyItem) {
                case "Are you sure you want to buy this item?":
                  return [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          viewModel.isBuying = true;
                        });
                        try {
                          await viewModel.shopService.buyShopItemByType(
                            type: widget.buyingPath,
                            itemId: widget.itemId,
                            context: context,
                          );
                          setState(() {
                            viewModel.popUpMessageBuyItem =
                                "Item purchased successfully";
                          });
                        } catch (e) {
                          setState(() {
                            viewModel.popUpMessageBuyItem = e.toString();
                          });
                        } finally {
                          setState(() {
                            viewModel.isBuying = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text("Yes",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ];
                default:
                  return [
                    TextButton(
                      onPressed: () async {
                        await widget.refreshDataShopItems();
                        await widget.refreshDataProfileData();
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ];
              }
            }(),
    );
  }
}

class PopUpChangeItem extends StatefulWidget {
  final String changingPath;
  final Future<void> Function() refreshDataShopItems;
  final Future<void> Function() refreshDataProfileData;

  const PopUpChangeItem({
    super.key,
    required this.changingPath,
    required this.refreshDataShopItems,
    required this.refreshDataProfileData,
  });

  @override
  State<PopUpChangeItem> createState() => _PopUpChangeItemState();
}

class _PopUpChangeItemState extends State<PopUpChangeItem> {
  final ShopViewModel viewModel = ShopViewModel();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmation"),
      content: viewModel.isChanging
          ? const SizedBox(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Text(viewModel.popUpMessageChangeItem),
      actions: viewModel.isChanging
          ? []
          : () {
        switch (viewModel.popUpMessageChangeItem) {
          case "Are you sure want to use this item?":
            return [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    viewModel.isChanging = true;
                  });
                  try {
                    await viewModel.profileService.updateUser(
                      item: widget.changingPath,
                      context: context,
                    );
                    setState(() {
                      viewModel.popUpMessageChangeItem = "Item changed successfully";
                    });
                  } catch (e) {
                    setState(() {
                      viewModel.popUpMessageChangeItem = e.toString();
                    });
                  } finally {
                    setState(() {
                      viewModel.isChanging = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Yes", style: TextStyle(color: Colors.white)),
              ),
            ];
          default:
            return [
              TextButton(
                onPressed: () async {
                  await widget.refreshDataShopItems();
                  await widget.refreshDataProfileData();
                  if (!mounted) return; // Ensure widget is still mounted.
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ];
        }
      }(),
    );
  }
}
