import 'dart:async';

import 'package:dio/dio.dart';
import 'package:novel_reader/model/shelf_view_beans.dart';
import 'package:novel_reader/repo/bean/service_bean.dart';
import 'package:novel_reader/repo/service/book_service.dart';
import 'package:novel_reader/db/app_db.dart';
import 'package:novel_reader/db/provider/book_detail_provider.dart';

class BookRepo {
  BookService _service;
  BookDetailProvider _provider;

  BookRepo() {
    _service = BookService.get();
    _provider = AppDatabase.get().getBookDetailProvider();

  }

  Future<List<ShelfBook>> getShelfBooks(String gender) async {
    if (_provider == null) {
      return [];
    }
    List<ShelfBook> books = [];

    List<BookBean> serverBooks = await _getShelfBooksFromServer(gender);

    ///update locale data from server
    if (serverBooks != null && serverBooks.isNotEmpty) {
      await _provider.insertOrUpdateBooks(serverBooks);
    }

    List<Map> localBooks = await _getShelfBooksFromLocal();

    if (localBooks != null && localBooks.isNotEmpty) {
      localBooks.forEach((e) {
        books.add(ShelfBook.fromJson(e));
      });
    }

    return books;
  }

  Future<List<Map>> _getShelfBooksFromLocal() async {
    return _provider.queryAllMaps();
  }

  Future<List<BookBean>> _getShelfBooksFromServer(String gender) async {
    Response response = await _service.getRecommendBookPackage(gender);
    if (response.statusCode < 200 || response.statusCode >= 300 || response.data == null) {
      return [];
    }
    List maps = response.data["books"] as List;

    List<BookBean> books = [];
    for (Map map in maps) {
      books.add(BookBean.fromJson(map));
    }
    return books;
  }
}
