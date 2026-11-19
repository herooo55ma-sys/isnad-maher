import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'isnad_maher.db');
    return openDatabase(path, version: 1, onCreate: (db, _) async {
      await db.execute('''
        CREATE TABLE records(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          costName TEXT NOT NULL,
          letterNumber TEXT NOT NULL,
          issuer TEXT,
          assignee TEXT,
          phone TEXT,
          status TEXT,
          statusDate TEXT
        )
      ''');
    });
  }

  Future<int> insertRecord(IsnadRecord r) async =>
      (await database).insert('records', r.toMap()..remove('id'));

  Future<List<IsnadRecord>> getAllRecords() async {
    final maps = await (await database).query('records', orderBy: 'id DESC');
    return maps.map(IsnadRecord.fromMap).toList();
  }

  Future<List<IsnadRecord>> search({
    String keyword = '',
    String status = '',
  }) async {
    final where = <String>[];
    final args = <String>[];
    if (keyword.isNotEmpty) {
      where.add('(costName LIKE ? OR letterNumber LIKE ? OR issuer LIKE ? OR assignee LIKE ? OR phone LIKE ?)');
      final k = '%$keyword%';
      args.addAll([k, k, k, k, k]);
    }
    if (status.isNotEmpty) {
      where.add('status LIKE ?');
      args.add('%$status%');
    }
    final maps = await (await database).query(
      'records',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'id DESC',
    );
    return maps.map(IsnadRecord.fromMap).toList();
  }

  Future<int> updateStatus(String letterNumber, String newStatus, String date) async =>
      (await database).update(
        'records',
        {'status': newStatus, 'statusDate': date},
        where: 'letterNumber = ?',
        whereArgs: [letterNumber],
      );

  Future<int> deleteRecord(int id) async =>
      (await database).delete('records', where: 'id = ?', whereArgs: [id]);
}
