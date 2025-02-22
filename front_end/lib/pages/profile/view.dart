import 'package:flutter/material.dart';
import 'package:front_end/components/elevated-button-component/view.dart';
import 'package:front_end/components/text-button-component/view.dart';
import 'package:front_end/pages/profile/view-model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileViewModel viewModel = ProfileViewModel();

  Future<void> fetchProfileData() async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.profileData = await viewModel.profileService.getUser(context: context);
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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: viewModel.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.orange,
                          child:
                              Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.profileData?.username ?? "-",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              viewModel.profileData?.email ?? "-",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 10),
            SwitchListTile(
              value: viewModel.isPinEnabled,
              onChanged: (bool value) {
                setState(() {
                  viewModel.isPinEnabled = value;
                });
              },
              title: const Text(
                "PIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Use Passcode Lock to Open the App",
                style: TextStyle(color: Colors.grey),
              ),
              secondary: const Icon(Icons.lock),
            ),
            SwitchListTile(
              value: viewModel.isSmartLoginEnabled,
              onChanged: (bool value) {
                setState(() {
                  viewModel.isSmartLoginEnabled = value;
                });
              },
              title: const Text(
                "Smart Login",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Use Fingerprint Auth to Open the App",
                style: TextStyle(color: Colors.grey),
              ),
              secondary: const Icon(Icons.fingerprint),
            ),
            const Divider(),
            const Text(
              "More",
              style:
                  TextStyle(fontSize: 18, color: Color.fromARGB(255, 74, 74, 74)),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text(
                "Change PIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Change Passcode Lock to Open the App",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                "Log Out",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Log Account Out from the App",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure want to log out?"),
          actions: [
            TextButtonComponent(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: "Cancel",
              textColor: Colors.red,
            ),
            ElevatedButtonComponent(
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.logout(context);
              },
              text: "Yes",
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
