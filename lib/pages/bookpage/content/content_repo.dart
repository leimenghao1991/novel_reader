import 'dart:async';

import 'package:dio/dio.dart';
import 'dart:io';
import 'package:novel_reader/db/app_db.dart';
import 'package:novel_reader/db/provider/book_detail_provider.dart';
import 'package:novel_reader/db/provider/chapter_provider.dart';
import 'package:novel_reader/db/provider/book_mark_provider.dart';
import 'package:novel_reader/db/provider/db_bean.dart';
import 'package:novel_reader/service/book_service.dart';
import 'package:novel_reader/service/chater_bean.dart';

class ContentRepo {
  static const int _BUFFER_SIZE = 512 * 1024;
  static const List<String> _CHAPTER_PATTERNS = [
    "^(.{0,8})(\u7b2c)([0-9\u96f6\u4e00\u4e8c\u4e24\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e\u5343\u4e07\u58f9\u8d30\u53c1\u8086\u4f0d\u9646\u67d2\u634c\u7396\u62fe\u4f70\u4edf]{1,10})([\u7ae0\u8282\u56de\u96c6\u5377])(.{0,30})\$",
    "^(\\s{0,4})([\\(\u3010\u300a]?(\u5377)?)([0-9\u96f6\u4e00\u4e8c\u4e24\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u5341\u767e\u5343\u4e07\u58f9\u8d30\u53c1\u8086\u4f0d\u9646\u67d2\u634c\u7396\u62fe\u4f70\u4edf]{1,10})([\\.:\uff1a\u0020\f\t])(.{0,30})\$",
    "^(\\s{0,4})([\\(\uff08\u3010\u300a])(.{0,30})([\\)\uff09\u3011\u300b])(\\s{0,2})\$",
    "^(\\s{0,4})(\u6b63\u6587)(.{0,20})\$",
    "^(.{0,4})(Chapter|chapter)(\\s{0,4})([0-9]{1,4})(.{0,30})\$"
  ];

  BookMarkProvider _bookMarkProvider;
  ChapterProvider _chapterProvider;
  BookDetailProvider _bookDetailProvider;
  BookService _bookService;

  ContentRepo() {
    _bookMarkProvider = AppDatabase.get().getReadingInfoProvider();
    _chapterProvider = AppDatabase.get().getChapterProvider();
    _bookDetailProvider = AppDatabase.get().getBookDetailProvider();
    _bookService = BookService.get();
  }

  Future<DBBookBean> getBookDetail(String bookId) async {
    return _bookDetailProvider.queryBooksById(bookId);
  }

  Future<DBBookMark> getBookMark(String bookId) async {
    return _bookMarkProvider.queryReadingInfo(bookId);
  }

  Future<List<DBChapter>> getChapters(DBBookBean book) async {
    List<DBChapter> result =
        await _chapterProvider.queryChaptersByBookId(book.id);

    if (book.locale) {
      if (result.isNotEmpty) {
        return result;
      }
      return getChaptersFromLocal(book);
    }

    if (book.isUpdate || result.isEmpty) {
      return updateChaptersFromServer(result, book);
    }

    return result;
  }

  Future<List<DBChapter>> updateChaptersFromServer(
      List<DBChapter> oldChapters, DBBookBean book) async {
    Response response = await _bookService.getChapters(book.id);
    if (!isResponseSuccess(response)) {
      return [];
    }

    List chapterMaps = response.data["mixToc"]["chapters"] as List;
    List<DBChapter> chapters = [];
    for (int i = 0, count = chapterMaps.length; i < count; i++) {
      Map map = chapterMaps[i];
      String chapterTitle = map[ChapterKey.chapterTitle];
      String downloadUrl = map[ChapterKey.chapterLink];
      DBChapter oldChapter;
      if (i < oldChapters.length) {
        oldChapter = oldChapters[i];
      }
      bool download = oldChapter == null ? false : oldChapter.download;
      String localPath = oldChapter == null ? null : oldChapter.localPath;
      DBChapter dbChapter = new DBChapter(
          bookId: book.id,
          title: chapterTitle,
          index: i,
          download: download,
          url: downloadUrl,
          localPath: localPath);
      chapters.add(dbChapter);
    }
    _chapterProvider.insertChapters(chapters);
    return chapters;
  }

  ///设置书籍的更新标志为已读
  Future<void> updateUpdateMark(String bookId) async {
    _bookDetailProvider.updateUpdateMark(bookId);
  }

  ///解析书籍的目录
  Future<List<DBChapter>> getChaptersFromLocal(DBBookBean bean) async {
    List<DBChapter> chapters = [];
    File novelFile = new File(bean.path);
    RandomAccessFile openedFile = novelFile.openSync();
//    String.fromCharCode(charCode)

    return chapters;
  }

  Future<bool> _checkChapterType(RandomAccessFile file) async {
    List<int> buffer = new List(_BUFFER_SIZE ~/ 4);
    int length = await file.readInto(buffer, 0, buffer.length);
    for (String str in _CHAPTER_PATTERNS) {
//      Pattern pattern = Pattern();
      RegExp regExp = RegExp(str, multiLine: true);
      regExp.allMatches(new String.fromCharCodes(buffer)).forEach((element) {

      });
    }
  }
}
