import 'dart:async';

import 'package:novel_reader/db/provider/chapter_provider.dart';
import 'package:novel_reader/db/provider/book_mark_provider.dart';
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
     _bookDetailProvider = new BookDetailProvider(this);
     _chapterProvider = new ChapterProvider(this);
     _bookMarkProvider = new BookMarkProvider(this);
  }

  Database _database;

  static AppDatabase get() => _appDatabase;

  bool didInit = false;

  BookDetailProvider _bookDetailProvider;
  ChapterProvider _chapterProvider;
  BookMarkProvider _bookMarkProvider;

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
      _chapterProvider.init(db);
      _bookMarkProvider.init(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {

    });
    didInit = true;
  }

  BookDetailProvider getBookDetailProvider() => _bookDetailProvider;

  ChapterProvider getChapterProvider() => _chapterProvider;

  BookMarkProvider getReadingInfoProvider() => _bookMarkProvider;
}

abstract class ProviderBase {
  AppDatabase _appDatabase;

  ProviderBase(AppDatabase appDatabase) {
    assert (appDatabase != null);
    _appDatabase = appDatabase;
  }

  Future<Database> getDb() => _appDatabase.getDb();

  void init(Database db);
}