class Product{
  int? id;
  String name;
  double price;
  String createdTime;
  String updatedTime;
  int stock;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.createdTime,
    required this.updatedTime,
    required this.stock,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    createdTime: json["createdTime"],
    updatedTime: json["updatedTime"],
    stock: json["stock"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "price": price,
    "createdTime": createdTime,
    "updatedTime": updatedTime,
    "stock": stock,
  };
}