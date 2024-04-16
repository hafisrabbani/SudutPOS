class TransactionRecord
{
  int? id;
  double nominalPayment;
  double total;
  int tableNumber;
  double change;
  int discType;
  double discValue;
  String createdTime;

  TransactionRecord({
    this.id,
    required this.nominalPayment,
    required this.total,
    required this.tableNumber,
    required this.change,
    required this.discType,
    required this.discValue,
    required this.createdTime,
  });

  factory TransactionRecord.fromMap(Map<String, dynamic> json) => TransactionRecord(
    id: json["id"],
    nominalPayment: json["nominalPayment"],
    total: json["total"],
    tableNumber: json["tableNumber"],
    change: json["change"],
    discType: json["discType"],
    discValue: json["discValue"],
    createdTime: json["createdTime"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nominalPayment": nominalPayment,
    "total": total,
    "tableNumber": tableNumber,
    "change": change,
    "discType": discType,
    "discValue": discValue,
    "createdTime": createdTime,
  };
}

