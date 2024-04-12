class TransactionDetail {
  int? id;
  int transactionId;
  int productId;
  int quantity;
  double price;

  TransactionDetail({
    this.id,
    required this.transactionId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) => TransactionDetail(
    id: json['id'],
    transactionId: json['transactionId'],
    productId: json['productId'],
    quantity: json['quantity'],
    price: json['price'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'transactionId': transactionId,
    'productId': productId,
    'quantity': quantity,
    'price': price,
  };
}
