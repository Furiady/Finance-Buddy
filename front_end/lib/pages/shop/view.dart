import 'package:flutter/material.dart';
import 'package:front_end/components/tab-bar-component/view.dart';
import 'package:front_end/pages/shop/component.dart';
import 'package:front_end/pages/shop/view-model.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  ShopViewModel viewModel = ShopViewModel();

  Future<void> fetchProfileData() async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.profileData = await viewModel.profileService.getUser(context: context);
      viewModel.parseGamification();
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
    // TODO: implement initState
    super.initState();
    fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(color: Colors.white),
        title: const Text(
          'Shop',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage('assets/images/gamification/${viewModel.profileData?.gamification}.gif'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Positioned(
                            left: 10,
                            top: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                color: Colors.blueAccent,
                                height: 40,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Icon(
                                        Icons.monetization_on,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: Text(
                                        (viewModel.profileData?.coin
                                                .toString() ??
                                            "-"),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: TabBarComponent(
                        tabTitles: const [
                          "Pet",
                          "Accessory",
                          "Theme",
                        ],
                        tabPages: [
                          ListItem(
                            type: "/pets",
                            buyingPath: '/pet',
                            refreshProfile: fetchProfileData,
                            usedItem: viewModel.gamificationData["pet"] ?? "",
                          ),
                          ListItem(
                            type: "/accessories",
                            buyingPath: "accessory",
                            refreshProfile: fetchProfileData,
                            usedItem: viewModel.gamificationData["accessory"] ?? "",
                          ),
                          ListItem(
                            type: "/themes",
                            buyingPath: "/theme",
                            refreshProfile: fetchProfileData,
                            usedItem: viewModel.gamificationData["theme"] ?? "",
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
    );
  }
}
