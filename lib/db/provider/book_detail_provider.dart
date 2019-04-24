import 'dart:async';

import 'package:novel_reader/db/provider/db_bean.dart';
import 'package:sqflite/sqflite.dart';
import 'package:novel_reader/db/app_db.dart';

class BookDetailProvider {
  static final tableName = "book_detail";
  static final columnId = "book_id";
  static final columnTitle = "title";
  static final columnAuthor = "author";
  static final columnShortIntro = "intro";
  static final columnCover = "cover";
  static final columnRetention = "retation";
  static final columnChapterCount = "chapter_count";
  static final columnLastChapter = "last_chapter";
  static final columnUpdateTime = "update_time";
  static final columnUpdate = "isUpdate";
  static final columnLocale = "locale";
  static final columnPath = "path";

  AppDatabase _appDatabase;

  BookDetailProvider(AppDatabase appDatabase) {
    _appDatabase = appDatabase;
  }

  Future<Database> _getDb() async {
    return _appDatabase.getDb();
  }

  void init(Database db) {
    db.execute("""
          create table if not exists $tableName(
            $columnId text primary key,
            $columnTitle text not null,
            $columnAuthor text,
            $columnShortIntro text,
            $columnCover text,
            $columnRetention double,
            $columnChapterCount integer,
            $columnLastChapter text,
            $columnUpdateTime text,
            $columnLocale integer,
            $columnUpdate integer,
            $columnPath text
          )
          """);
  }

  Map<String, dynamic> _toMap(DBBookBean book) => {
        columnId: book.id,
        columnTitle: book.title,
        columnAuthor: book.author,
        columnShortIntro: book.shortIntro,
        columnCover: book.cover,
        columnRetention: book.retentionRation,
        columnChapterCount: book.chaptersCount,
        columnLastChapter: book.lastChapter,
        columnUpdateTime: book.updateTime,
        columnLocale: book.locale ? 1 : 0,
        columnUpdate: book.isUpdate ? 1 : 0,
        columnPath: book.path
      };

  DBBookBean _fromMap(Map<String, dynamic> map) => DBBookBean(
      id: map[columnId],
      title: map[columnTitle],
      author: map[columnAuthor],
      shortIntro: map[columnShortIntro],
      cover: map[columnCover],
      retentionRation: map[columnRetention],
      chaptersCount: map[columnChapterCount],
      lastChapter: map[columnLastChapter],
      locale: map[columnLocale] == 1,
      updateTime: map[columnUpdateTime],
      isUpdate: map[columnUpdate] == 1,
      path: map[columnPath]);

  Future insertByMap(DBBookBean book) async {
    var db = await _getDb();
    return db.insert(tableName, _toMap(book));
  }

  Future<List<DBBookBean>> queryAll() async {
    var db = await _getDb();
    var result = await db.query(tableName);
    if (result == null || result.length == 0) {
      return [];
    }
    List<DBBookBean> books = [];
    for (Map map in result) {
      books.add(_fromMap(map));
    }
    return books;
  }

  Future<List<Map>> queryAllMaps() async {
    var db = await _getDb();
    var result = await db.query(tableName);
    if (result == null || result.length == 0) {
      return [];
    }
    return result;
  }

  Future<DBBookBean> queryBooksById(String id) async {
    var db = await _getDb();
    var result =
        await db.query(tableName, where: '$columnId = ?', whereArgs: [id]);
    if (result == null || result.length == 0) {
      return null;
    }
    Map firstMap = result[0];
    return _fromMap(firstMap);
  }

  Future update(DBBookBean book) async {
    var db = await _getDb();
    await db.update(tableName, _toMap(book));
  }

  Future updateUpdateMark(String bookId) async {
    var db = await _getDb();
    await db.update(tableName, {columnUpdate: 0}, where: '$columnId = ?', whereArgs: [bookId]);
  }

  Future deleteById(String id) async {
    var db = await _getDb();
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future deleteByBook(DBBookBean book) async {
    return deleteById(book.id);
  }

  Future insertOrUpdateBooks(List<DBBookBean> books) async {
    var db = await _getDb();
    Batch batch = db.batch();
    for (DBBookBean book in books) {
      batch.rawInsert('INSERT OR REPLACE INTO '
          '$tableName($columnId,$columnTitle,$columnAuthor,$columnShortIntro,'
          '$columnCover,$columnLocale,$columnRetention,$columnChapterCount,'
          '$columnLastChapter,$columnUpdateTime,$columnUpdate,$columnPath)'
          ' VALUES("${book.id}", "${book.title}", "${book.author}", "${book.shortIntro}", "${book.cover}", ${book.locale ? 1 : 0}, '
          '${book.retentionRation}, ${book.chaptersCount}, "${book.lastChapter}","${book.updateTime}", ${book.isUpdate ? 1 : 0},'
          '"${book.path}")');
    }
    batch.commit(noResult: true);
  }
}
