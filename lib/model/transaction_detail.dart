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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }

factory TransactionDetail.fromMap(Map<String, dynamic> map) {
    return TransactionDetail(
      id: map['id'],
      transactionId: map['transactionId'],
      productId: map['productId'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }
}
