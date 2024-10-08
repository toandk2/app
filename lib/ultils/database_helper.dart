import 'dart:async';
import 'dart:io' as io;

import 'package:hkd/ultils/models.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "bsc.dkd.db");
    final theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS TB_User ( TaiKhoan TEXT,MatKhau TEXT,Loai integer,Cart TEXT);');
  }

  Future<int> saveUser(UserData user) async {
    var dbClient = await db;
     await dbClient.delete("TB_User");
    int res = await dbClient.insert("TB_User", user.toJson());
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("TB_User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("TB_User");
    return res.isNotEmpty ? true : false;
  }

  Future<UserData?> getUser() async {
    try {
      var dbClient = await db;
      var kq = await dbClient.query("TB_User");
      return UserData.fromJson(kq.first);
    } catch (e) {
      return null;
    }
  }
}
