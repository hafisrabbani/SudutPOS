import 'package:sqflite/sqflite.dart';
import 'base_query.dart';

class TransactionDetail extends BaseQuery {
  TransactionDetail(Database database) : super(database);

  @override
  String get tableName => 'TransactionDetail';
}