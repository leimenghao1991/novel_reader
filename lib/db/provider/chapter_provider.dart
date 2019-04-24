import 'dart:async';

import 'package:novel_reader/db/app_db.dart';
import 'package:novel_reader/db/provider/db_bean.dart';
import 'package:sqflite/sqflite.dart';

class ChapterProvider extends ProviderBase {
  static final String tableName = "chapters";
  static final String columnBookId = "book_id";
  static final String columnTitle = "chapter_title";
  static final String columnIndex = "chapter_index";
  static final String columnStartPos = "start_pos";
  static final String columnEndPos = "end_pos";
  static final String columnDownload = "download";
  static final String columnLocalPath = "localPath";
  static final String columnUrl = "url";

  ChapterProvider(AppDatabase appDatabase) : super(appDatabase);

  @override
  void init(Database db) {
    db.execute("""
      create table if not exists $tableName(
            $columnBookId text not null,
            $columnTitle text not null,
            $columnIndex integer,
            $columnStartPos integer,
            $columnEndPos integer,
            $columnDownload integer,
            $columnUrl text,
            $columnLocalPath text
      )
    """);
  }

  DBChapter _fromMap(Map<String, dynamic> map) => new DBChapter(
      bookId: map[columnBookId],
      title: map[columnTitle],
      index: map[columnIndex],
      startPos: map[columnStartPos],
      endPos: map[columnEndPos],
      download: map[columnDownload] == 1,
      localPath: map[columnLocalPath],
      url: map[columnUrl]);

  Map<String, dynamic> _toMap(DBChapter chapter) => {
        columnBookId: chapter.bookId,
        columnTitle: chapter.title,
        columnIndex: chapter.index,
        columnStartPos: chapter.startPos,
        columnEndPos: chapter.endPos,
        columnDownload: chapter.download ? 1 : 0,
        columnLocalPath: chapter.localPath,
        columnUrl: chapter.url
      };

  Future<List<DBChapter>> queryChaptersByBookId(String bookId) async {
    Database db = await getDb();
    var result =
        await db.query(tableName, where: '$columnBookId = ?', whereArgs: [bookId]);
    if (result == null || result.isEmpty) {
      return [];
    }

    List<DBChapter> chapters = [];
    for (Map map in result) {
      chapters.add(_fromMap(map));
    }

    return chapters;
  }

  Future<void> insertChapters(List<DBChapter> chapters) async {
    Database db = await getDb();
    Batch batch = db.batch();
    for (DBChapter chapter in chapters) {
      batch.rawInsert('INSERT OR REPLACE INTO '
          '$tableName($columnBookId,$columnTitle,$columnIndex,$columnStartPos,'
          '$columnEndPos,$columnDownload,$columnLocalPath,$columnUrl)'
          ' VALUES("${chapter.bookId}", "${chapter.title}", ${chapter.index}, ${chapter.startPos},'
          '${chapter.endPos},${chapter.download ? 1 : 0}, "${chapter.localPath}", "${chapter.url}")');
    }
    batch.commit(noResult: true);
  }

  Future<void> insertChapter(DBChapter chapter) async {
    Database db = await getDb();
    db.insert(tableName, _toMap(chapter));
  }
}
