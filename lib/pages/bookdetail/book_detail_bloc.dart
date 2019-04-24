import 'dart:async';

import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/service/book_detail_bean.dart';
import 'package:novel_reader/service/search_view_bean.dart';
import 'package:novel_reader/pages/bookdetail/book_detail_repo.dart';

class BookDetailBloc extends BlocBase {
  BookDetailViewData _cache;

  String bookId;

  BookDetailRepo _repo = new BookDetailRepo();

  BookDetailViewData get cache => _cache;

  StreamController<BookDetailViewData> _dataController = StreamController();

  Stream<BookDetailViewData> get data => _dataController.stream;

  BookDetailBloc(this.bookId) {
    _cache = BookDetailViewData._internal();
    _loadData();
  }

  bool isDataValid() {
    return _cache.book != null;
  }

  void _loadData() {
    Future.wait([
      _repo.getBookDetail(bookId),
      _repo.getHotComments(bookId),
      _repo.getRecommends(bookId)
    ]).then((List response) {
      _cache.book = response[0];

      _cache.comments.clear();
      _cache.comments.addAll(response[1]);

      _cache.recommends.clear();
      _cache.recommends.addAll(response[2]);

      _dataController.sink.add(_cache);
    });
  }

  @override
  void dispose() {
    _dataController.close();
  }
}

class BookDetailViewData {
  BookDetailInfo book;
  List<CommentBean> comments;
  List<RecommendBookBean> recommends;

  BookDetailViewData._internal() {
    comments = [];
    recommends = [];
  }
}
