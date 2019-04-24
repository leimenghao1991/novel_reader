import 'dart:async';

import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/pages/shelf/shelf_view_beans.dart';
import 'package:novel_reader/pages/shelf/shelf_repo.dart';

class ShelfBloc implements BlocBase {
  StreamController<List<ShelfBook>> _booksController = StreamController<List<ShelfBook>>.broadcast();

  ///当widget重新build的时候，books stream可能不会再发送消息了，那么页面就没有数据。这时候可以
  ///使用cache数据
  List<ShelfBook> cache = [];

  BookRepo _repo = BookRepo();


  Stream<List<ShelfBook>> get books => _booksController.stream;

  ShelfBloc() {
      _loadBooks();
  }

  void _loadBooks() {
    _repo.getShelfBooks("male").then((List<ShelfBook> books) {
      cache.clear();
      cache.addAll(books);
      _booksController.sink.add(books);
    });
  }

  void refresh() {
    _loadBooks();
  }

  @override
  void dispose() {
    _booksController.close();
  }

}