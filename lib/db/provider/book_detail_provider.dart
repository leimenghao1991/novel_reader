import 'package:novel_reader/db/provider/db_book_detail_bean.dart';
import 'package:sqflite/sqflite.dart';
import 'package:novel_reader/db/app_db.dart';

final tableName = "book_detail";
final columnId = "book_id";
final columnTitle = "title";
final columnAuthor = "author";
final columnShortIntro = "intro";
final columnCover = "cover";
final columnHasCp = "has_cp";
final columnRetention = "retation";
final columnChapterCount = "chapter_count";
final columnLastChapter = "last_chapter";
final columnUpdate = "update_time";

class BookDetailProvider {
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
            $columnHasCp integer,
            $columnRetention double,
            $columnChapterCount integer,
            $columnLastChapter text,
            $columnUpdate text
          )
          """);
  }

  Map<String, dynamic> _toMap(BookBean book) => {
      columnId: book.id,
      columnTitle: book.title,
      columnAuthor: book.author,
      columnShortIntro: book.shortIntro,
      columnCover: book.cover,
      columnHasCp: book.hasCp ? 1 : 0,
      columnRetention: book.retentionRation,
      columnChapterCount: book.chaptersCount,
      columnLastChapter: book.lastChapter
  };

  BookBean _fromMap(Map<String, dynamic> map) => BookBean(
    id: map[columnId],
    title: map[columnTitle],
    author: map[columnAuthor],
    shortIntro: map[columnShortIntro],
    cover: map[columnCover],
    hasCp: map[columnHasCp] == 1,
    retentionRation: map[columnRetention],
    chaptersCount: map[columnChapterCount],
    lastChapter: map[columnLastChapter]
  );

  Future insertByMap(BookBean book) async{
    var db = await _getDb();
    return db.insert(tableName, _toMap(book));
  }

  Future<List<BookBean>> queryAll() async {
    var db = await _getDb();
    var result = await db.query(tableName);
    if (result == null || result.length == 0) {
      return [];
    }
    List<BookBean> books = [];
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

  Future<BookBean> queryBooksById(String id) async {
    var db = await _getDb();
    var result = await db.query(tableName, where: '$columnId = ?', whereArgs: [id]);
    if (result == null || result.length == 0) {
      return null;
    }
    Map firstMap = result[0];
    return _fromMap(firstMap);
  }

  Future update(BookBean book) async {
    var db = await _getDb();
    await db.update(tableName, _toMap(book));
  }

  Future deleteById(String id) async {
    var db = await _getDb();
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future deleteByBook(BookBean book) async {
    return deleteById(book.id);
  }

  Future insertOrUpdateBooks(List<BookBean> books) async {
    var db = await _getDb();
    Batch batch = db.batch();
    for (BookBean book in books) {
      batch.rawInsert('INSERT OR REPLACE INTO '
          '$tableName($columnId,$columnTitle,$columnAuthor,$columnShortIntro,'
          '$columnCover,$columnHasCp,$columnRetention,$columnChapterCount,$columnLastChapter,$columnUpdate)'
          ' VALUES("${book.id}", "${book.title}", "${book.author}", "${book.shortIntro}", "${book.cover}", ${book.hasCp ? 1 : 0}, '
          '${book.retentionRation}, ${book.chaptersCount}, "${book.lastChapter}","${book.updated}")');
    }
    batch.commit(noResult: true);
  }
}
