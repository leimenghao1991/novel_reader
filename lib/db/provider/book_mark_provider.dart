import 'dart:async';

import 'package:novel_reader/db/app_db.dart';
import 'package:novel_reader/db/provider/db_bean.dart';
import 'package:sqflite/sqflite.dart';

class BookMarkProvider {
  static final String tableName = "book_read_info";
  static final String columnBookId = "book_id";
  static final String columnChapterIndex = "last_read_chapter";
  static final String columnPosInChapter = "position_in_chapter";
  static final String columnPos = "position_in_book";

  AppDatabase _appDatabase;

  BookMarkProvider(AppDatabase appDatabase) {
    assert(appDatabase != null);
    _appDatabase = appDatabase;
  }

  Future<Database> _getDb() async {
    return _appDatabase.getDb();
  }

  void init(Database db) {
    db.execute("""
      create table if not exists $tableName(
            $columnBookId text primary key,
            $columnChapterIndex integer,
            $columnPosInChapter integer,
            $columnPos integer)
    """);
  }

  Map _toMap(DBBookMark mark) => {
        columnBookId: mark.bookId,
        columnChapterIndex: mark.chapterIndex,
        columnPosInChapter: mark.posInChapter,
        columnPos: mark.posInBook
      };

  DBBookMark _fromMap(Map map) => new DBBookMark(
      bookId: map[columnBookId],
      chapterIndex: map[columnChapterIndex],
      posInChapter: map[columnPosInChapter],
      posInBook: map[columnPos]);

  Future<DBBookMark> queryReadingInfo(String bookId) async {
    var db = await _getDb();
    var result = await db
        .query(tableName, where: '$columnBookId = ?', whereArgs: [bookId]);
    if (result == null || result.length == 0) {
      return null;
    }
    Map firstMap = result[0];
    return _fromMap(firstMap);
  }

  Future<void> insertReadingInfo(DBBookMark readingInfo) async {
    var db = await _getDb();
    db.insert(tableName, _toMap(readingInfo));
  }

  Future<void> insertReadingInfos(List<DBBookMark> readingInfos) async {
    var db = await _getDb();
    Batch batch = db.batch();
    for (DBBookMark readingInfo in readingInfos) {
      batch.rawInsert('INSERT OR REPLACE INTO '
          '$tableName($columnBookId,$columnChapterIndex,$columnPosInChapter,$columnPos)'
          ' VALUES("${readingInfo.bookId}", ${readingInfo.chapterIndex}, ${readingInfo.posInChapter}, ${readingInfo.posInBook})');
    }
    batch.commit(noResult: true);
  }
}
