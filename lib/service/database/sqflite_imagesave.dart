import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ImageSaverOffline {
  static Database? _database;

  static Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'photos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE photos (id TEXT PRIMARY KEY, path TEXT)');
      },
    );
  }

  static Future<void> savePhotoOffline(String id, String path) async {
    final database = await db;
    await database.insert(
      'photos',
      {'id': id, 'path': path},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Photo Saved");
  }

  static Future<void> editPhotoOffline(String id, String path) async {
    final database = await db;
    await database.update(
      'photos',
      {'path': path},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<Map<String, dynamic>?> getPhotoByUserId(String id) async {
    final database = await db;
    final result = await database.query(
      'photos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

}
