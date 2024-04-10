import 'package:sqflite/sqflite.dart';
abstract class BaseQuery{
  final Database _database;
  BaseQuery(this._database);
  String get tableName;

  Future<int> insert(Map<String, dynamic> data) async {
    return await _database.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> selectAll() async {
    return await _database.query(tableName);
  }

  Future<int> update(Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
    return await _database.update(tableName, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String where, List<dynamic> whereArgs) async {
    return await _database.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> selectWhere(String where, List<dynamic> whereArgs) async {
    return await _database.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<Map<String, dynamic>> selectById(int id) async {
    final List<Map<String, dynamic>> result = await _database.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.first;
  }

  Future<Map<String, dynamic>> belongsTo(String tableName, String foreignKey, int id) async {
    final List<Map<String, dynamic>> result = await _database.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.first;
  }

  Future<List<Map<String, dynamic>>> hasMany(String tableName, String foreignKey, int id) async {
    return await _database.query(tableName, where: '$foreignKey = ?', whereArgs: [id]);
  }
}