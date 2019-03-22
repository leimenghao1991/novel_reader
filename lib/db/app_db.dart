import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:developer';
import 'package:novel_reader/db/provider/book_detail_provider.dart';

///db version
const VERSION = 1;

class AppDatabase {
  static final AppDatabase _appDatabase = AppDatabase._internal();

  AppDatabase._internal() {
//     debugger(when: true);
     _bookDetailProvider = new BookDetailProvider(this);
  }

  Database _database;

  static AppDatabase get() => _appDatabase;

  bool didInit = false;

  BookDetailProvider _bookDetailProvider;

  Future<Database> getDb() async {
    if (!didInit) {
      await _init();
    }
    return _database;
  }

  Future _init() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, "database.db");
    _database = await openDatabase(
        path, version: VERSION, onCreate: (Database db, int version) async {
      _bookDetailProvider.init(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {

    });
    didInit = true;
  }

  BookDetailProvider getBookDetailProvider() => _bookDetailProvider;
}