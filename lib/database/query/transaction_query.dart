import 'package:sqflite/sqflite.dart';
import 'base_query.dart';

class Transaction extends BaseQuery {
  Transaction(Database database) : super(database);

  @override
  String get tableName => 'Transaction';

}