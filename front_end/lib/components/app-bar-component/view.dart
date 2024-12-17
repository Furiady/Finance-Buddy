import 'package:flutter/material.dart';

class AppBarComponent extends StatefulWidget {
  const AppBarComponent({super.key});

  @override
  State<AppBarComponent> createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spread the items
      children: [
        // User info card
        Card(
          elevation: 4, // Optional for shadow effect
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.02, // 2% of screen width
              vertical: screenSize.height * 0.01, // 1% of screen height
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/images/gojo.png", // Example image URL
                    width: screenSize.width * 0.1, // 10% of screen width
                    height: screenSize.width * 0.1, // Keep it circular
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: screenSize.width * 0.02), // Spacer between icon and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "username",
                      style: TextStyle(fontSize: screenSize.width * 0.04),
                    ),
                    Text(
                      "email",
                      style: TextStyle(fontSize: screenSize.width * 0.035),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Points card
        Card(
          elevation: 4, // Optional for shadow effect
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.02, // 2% of screen width
              vertical: screenSize.height * 0.01, // 1% of screen height
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/images/gojo.png", // Example image URL
                    width: screenSize.width * 0.05,// 10% of screen width
                    height: screenSize.width * 0.05, // Keep it circular
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "120",
                  style: TextStyle(fontSize: screenSize.width * 0.04),
                ),
              ],
            ),
          ),
        ),
        // Settings icon
        IconButton(
          icon: const Icon(Icons.settings),
          iconSize: screenSize.width * 0.08, // 8% of screen width
          onPressed: () {
            // Your action for the settings button
          },
        ),
      ],
    );
  }
}
