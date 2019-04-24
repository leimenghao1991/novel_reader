import 'dart:async';

import 'package:dio/dio.dart';

class BookService {
  static const String BASE_URL = "http://api.zhuishushenqi.com";
  static final _bookService = BookService._internal();

  static BookService get() {
    return _bookService;
  }

  Dio _dio;

  BookService._internal() {
    _dio = new Dio();
    _dio.options.baseUrl = BASE_URL;
  }

  ///获取书架推荐列表
  ///
  /// gender: "male" or "female"
  ///http://api.zhuishushenqi.com/book/recommend?gender=male
  Future<Response> getRecommendBookPackage(String gender) {
    return _dio.get(
      "/book/recommend",
      queryParameters: {"gender": gender},
    );
  }

  ///搜索数据
  Future<Response> searchBook(String query) {
    return _dio.get("/book/fuzzy-search", queryParameters: {"query": query});
  }

  ///获取搜索热词
  Future<Response> getSearchHotWords() {
    return _dio.get("/book/hot-word");
  }

  ///用户输入自动补全
  Future<Response> getInputSuggest(String input) {
    return _dio.get("/book/auto-complete", queryParameters: {"query": input});
  }

  ///获取书籍详细信息
  Future<Response> getBookDetail(String bookId) {
    return _dio.get("/book/$bookId");
  }

  ///获取书籍的热门评论
  Future<Response> getBookHotComments(String bookId, int count) {
    return _dio.get("/post/review/best-by-book",
        queryParameters: {"book": bookId, "limit": count});
  }

  ///根据给定的bookId获取推荐书籍
  Future<Response> getRecommendBooks(String bookId, int count) {
    return _dio
        .get("/book-list/$bookId/recommend", queryParameters: {"limit": count});
  }

  //    http://api.zhuishushenqi.com/mix-atoc/5a997704b01a78b173e3d03a?view=view
  Future<Response> getChapters(String bookId) {
    return _dio.get("/mix-atoc/$bookId?view=view");
  }
}

bool isResponseSuccess(Response response) {
  return response != null &&
      response.statusCode >= 200 &&
      response.statusCode < 300 &&
      response.data != null;
}
