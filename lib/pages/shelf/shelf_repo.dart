import 'dart:async';

import 'package:dio/dio.dart';
import 'package:novel_reader/pages/shelf/shelf_view_beans.dart';
import 'package:novel_reader/db/provider/db_bean.dart';
import 'package:novel_reader/service/book_detail_bean.dart';
import 'package:novel_reader/service/book_service.dart';
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

    List<DBBookBean> localBooks = await _getShelfBooksFromLocal();

    ///如果本地数据库为空，那么需要从服务端拉取推荐的书籍
    if (localBooks.isEmpty) {
      List<DBBookBean> serverBooks = await _getShelfBooksFromServer(gender);

      ///insert locale data
      if (serverBooks.isNotEmpty) {
        await _provider.insertOrUpdateBooks(serverBooks);
      }
      serverBooks.forEach((book) => books.add(ShelfBook.fromBookBean(book)));
      return books;
    }

    _checkBookUpdates(localBooks);

    localBooks = await _getShelfBooksFromLocal();
    localBooks.forEach((e) {
      books.add(ShelfBook.fromBookBean(e));
    });
    return books;
  }

  ///检查书架上的书籍是否有更新，如果有更新就更新信息
  Future<void> _checkBookUpdates(List<DBBookBean> books) async {
    ///如果本地数据库不为空，那么需要选出网络书籍，然后进行信息更新处理
    List<Future<Response>> requests = [];
    books.forEach((book) {
      if (!book.locale) {
        _service.getBookDetail(book.id);
      }
    });
    List<Response> responses = await Future.wait(requests);
    List<DBBookBean> updatedBooks = [];
    for (int i = 0, count = responses.length; i < count; i++) {
      Response response = responses[i];
      if (!isResponseSuccess(response)) {
        continue;
      }
      DBBookBean oldBook = books[i];
      BookDetailInfo detail = BookDetailInfo.fromJson(response.data);
      DBBookBean updateBook = DBBookBean.fromBookDetail(detail);
      if (oldBook.lastChapter != updateBook.lastChapter) {
        updateBook.isUpdate = true;
      } else {
        updateBook.isUpdate = oldBook.isUpdate;
      }
      updatedBooks.add(updateBook);
    }
    _provider.insertOrUpdateBooks(updatedBooks);
  }

  Future<List<DBBookBean>> _getShelfBooksFromLocal() async {
    return _provider.queryAll();
  }

  Future<List<DBBookBean>> _getShelfBooksFromServer(String gender) async {
    Response response = await _service.getRecommendBookPackage(gender);
    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        response.data == null) {
      return [];
    }
    List maps = response.data["books"] as List;

    List<DBBookBean> books = [];
    for (Map map in maps) {
      books.add(DBBookBean.fromJson(map));
    }
    return books;
  }
}
