class ShopModel {
  final String name;
  final int price;
  final String path;
  final String id;
  final bool status;

  ShopModel(
      {required this.name,
      required this.price,
      required this.path,
      required this.id,
      required this.status});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'path': path,
      'id': id,
      'status': status
    };
  }

  // Create a RecordModel from JSON data
  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
        name: json['name'],
        price: json['price'],
        path: json['path'],
        id: json['id'],
        status: json['status']);
  }
}
