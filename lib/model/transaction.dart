enum DiscType { percent, value }

class TransactionRecord
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

  TransactionRecord({
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

  factory TransactionRecord.fromMap(Map<String, dynamic> json) => TransactionRecord(
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

