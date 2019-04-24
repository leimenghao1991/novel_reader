import 'dart:async';

import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/db/provider/db_bean.dart';
import 'package:novel_reader/pages/bookpage/content/content_repo.dart';

class ContentBloc extends BlocBase {
  String _bookId;
  ContentData cache = new ContentData();
  ContentRepo _repo;

  StreamController<ContentData> _dataController = StreamController();

  Stream<ContentData> get dataStream => _dataController.stream;

  ContentBloc(String bookId) {
    _bookId = bookId;
    _repo = new ContentRepo();
  }

  void init() {
    getChapters();
    updateUpdateMark();
  }

  void getChapters() {
    _repo.getBookDetail(_bookId).then((book) {
      cache.book = book;
      return _repo.getChapters(book);
    }).then((chapters) {
      cache.chapters.clear();
      cache.chapters.addAll(chapters);
      _dataController.sink.add(cache);
    });
  }

  void updateUpdateMark() {
    _repo.updateUpdateMark(_bookId);
  }

  @override
  void dispose() {
    _dataController.close();
  }
}

class ContentData {
  DBBookBean book;
  List<DBChapter> chapters = [];
}
