import 'package:sudut_pos/database/main_database.dart';

abstract class BaseQuery {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  String get tableName;

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await _databaseHelper.database;
    return await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> selectAll() async {
    final db = await _databaseHelper.database;
    return await db.query(tableName);
  }

  Future<int> update(Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
    final db = await _databaseHelper.database;
    return await db.update(tableName, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> selectWhere(String where, List<dynamic> whereArgs) async {
    final db = await _databaseHelper.database;
    return await db.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<Map<String, dynamic>> selectById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.first;
  }

  Future<Map<String, dynamic>> belongsTo(String tableName, String foreignKey, int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.first;
  }

  Future<List<Map<String, dynamic>>> hasMany(String tableName, String foreignKey, int id) async {
    final db = await _databaseHelper.database;
    return await db.query(tableName, where: '$foreignKey = ?', whereArgs: [id]);
  }
}
