import 'package:sqflite/sqflite.dart';
import 'base_query.dart';

class ProductQuery extends BaseQuery {
  ProductQuery(Database database) : super(database);

  @override
  String get tableName => 'Product';
}