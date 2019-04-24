
import 'package:dio/dio.dart';
import 'package:novel_reader/service/book_detail_bean.dart';
import 'package:novel_reader/service/search_view_bean.dart';
import 'package:novel_reader/service/book_service.dart';

class BookDetailRepo {
  BookService _service = BookService.get();

  Future<BookDetailInfo> getBookDetail(String bookId) async {
    Response  response = await _service.getBookDetail(bookId);
    if (!isResponseSuccess(response)) {
      return null;
    }

    return BookDetailInfo.fromJson(response.data);
  }

  Future<List<CommentBean>> getHotComments(String bookId) async {
    Response response = await _service.getBookHotComments(bookId, 3);
    if (!isResponseSuccess(response)) {
      return [];
    }
    List<dynamic> commentJsons = response.data["reviews"] as List;
    var comments = commentJsons.map((map)=> CommentBean.fromJson(map)).toList();
    return comments;
  }

  Future<List<RecommendBookBean>> getRecommends(String bookId) async {
    Response response = await _service.getRecommendBooks(bookId, 3);
    if (!isResponseSuccess(response)) {
      return [];
    }

    List<dynamic> recommendJson = response.data["booklists"] as List;
    var recommends = recommendJson.map((map) => RecommendBookBean.fromJson(map)).toList();
    return recommends;
  }
}