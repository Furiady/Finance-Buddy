import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isPinEnabled = false;
  bool isSmartLoginEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
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
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CALVIN",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "calvinos@email.com",
                        style: TextStyle(
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
              value: isPinEnabled,
              onChanged: (bool value) {
                setState(() {
                  isPinEnabled = value;
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
              value: isSmartLoginEnabled,
              onChanged: (bool value) {
                setState(() {
                  isSmartLoginEnabled = value;
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
              style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 74, 74, 74)),
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
