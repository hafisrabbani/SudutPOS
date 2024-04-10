import 'package:sqflite/sqflite.dart';
import 'base_query.dart';

class AppSettings extends BaseQuery {
  AppSettings(Database database) : super(database);

  @override
  String get tableName => 'AppSetting';
}