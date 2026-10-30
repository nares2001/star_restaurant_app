import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pointycastle/export.dart';

class LocalDbService {
  static final LocalDbService instance = LocalDbService._init();
  static Database? _database;

  LocalDbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('starsystem_cache.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {},
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS configSystem (
        pass TEXT,
        themeConfig TEXT,
        logoPrin TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> saveConfigSystem(
    String pass,
    String themeConfig,
    String logoPrin,
  ) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.delete('configSystem');
      await txn.insert('configSystem', {
        'pass': pass,
        'themeConfig': themeConfig,
        'logoPrin': logoPrin,
      });
    });
  }

  Future<Map<String, dynamic>?> getConfigSystem() async {
    final db = await instance.database;
    final result = await db.query('configSystem', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> updateConfigSystem(
    int id,
    String pass,
    String themeConfig,
    String logoPrin,
  ) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.update(
        'configSystem',
        {'pass': pass, 'themeConfig': themeConfig, 'logoPrin': logoPrin},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<List<Map<String, dynamic>>> obtenerTodosServicios() async {
    final db = await database;
    final maps = await db.query('servicios');

    final List<Map<String, dynamic>> resultado = [];
    for (final map in maps) {
      final row = Map<String, dynamic>.from(map);
      final encryptedPass = row['pass'] as String;
      final decryptedPass = await SecureKeyProvider.decryptData(encryptedPass);

      row['pass'] = decryptedPass;
      resultado.add(row);
    }
    return resultado;
  }

  // --- LIMPIEZA DE DATOS (SESIÓN EXPIRADA O LOGOUT) ---
  Future<void> limpiarDatos() async {
    final db = await instance.database;
    await db.transaction((txn) async {});
  }
}
