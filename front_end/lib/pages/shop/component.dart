import 'package:flutter/material.dart';
import 'dart:math';

class ListItem extends StatefulWidget {
  const ListItem({Key? key}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final List<Map<String, dynamic>> items = [
    {"title": "Minotaurus", "price": 50, "imagePath": "assets/minotaurus.png"},
    {"title": "Troll", "price": 50, "imagePath": "assets/troll.png"},
    {"title": "Ogre", "price": 50, "imagePath": "assets/ogre.png"},
  ];

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item List"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            decoration: BoxDecoration(
              color: getRandomColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  item["imagePath"],
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Text(
                  item["title"],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Purchased ${item["title"]}!")),
                    );
                  },
                  icon: Image.asset(
                    "assets/coin.png",
                    height: 20,
                    width: 20,
                  ),
                  label: Text(
                    "${item["price"]}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
