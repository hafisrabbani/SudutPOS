enum DiscType { percent, value }

class Transaction
{
  int? id;
  String? customerName;
  double nominalPayment;
  double total;
  int tableNumber;
  double change;
  String cashiers;
  DiscType discType;
  double discValue;
  String createdTime;

  Transaction({
    this.id,
    this.customerName,
    required this.nominalPayment,
    required this.total,
    required this.tableNumber,
    required this.change,
    required this.cashiers,
    required this.discType,
    required this.discValue,
    required this.createdTime,
  });

  factory Transaction.fromMap(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    customerName: json["customerName"],
    nominalPayment: json["nominalPayment"],
    total: json["total"],
    tableNumber: json["tableNumber"],
    change: json["change"],
    cashiers: json["cashiers"],
    discType: json["discType"],
    discValue: json["discValue"],
    createdTime: json["createdTime"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "customerName": customerName,
    "nominalPayment": nominalPayment,
    "total": total,
    "tableNumber": tableNumber,
    "change": change,
    "cashiers": cashiers,
    "discType": discType,
    "discValue": discValue,
    "createdTime": createdTime,
  };
}

