import 'dart:async';

import 'package:async/async.dart';
import 'package:novel_reader/model/book_detail_bean.dart';
import 'package:novel_reader/model/search_view_bean.dart';
import 'package:novel_reader/repo/service/book_service.dart';

class BookDetailViewModel {
  BookService _service;
  String bookId;

  StreamController<BookDetailInfo> _bookInfoCtrl;
  StreamController<List<CommentBean>> _hotCommentsCtrl;
  StreamController<List<RecommendBookBean>> _recommendsCtrl;

  BookDetailViewModel(this.bookId) {
    _service = BookService.get();
    _bookInfoCtrl = StreamController.broadcast();
    _hotCommentsCtrl = StreamController.broadcast();
    _recommendsCtrl = StreamController.broadcast();
  }

  Stream<BookDetailInfo> bookInfoStream() => _bookInfoCtrl.stream;

  Stream<List<CommentBean>> hotCommentStream() => _hotCommentsCtrl.stream;

  Stream<List<RecommendBookBean>> recommendStream() => _recommendsCtrl.stream;

  Stream isEmpty(){
    return StreamZip([bookInfoStream(), hotCommentStream(), recommendStream()]);
  }

  void triggerFetch() {
    _triggerFetchBookInfo();
    _triggerFetchHotComments();
    _triggerFetchRecommends();
  }

  void dispose() {
    _bookInfoCtrl.close();
    _hotCommentsCtrl.close();
    _recommendsCtrl.close();
  }

  void _triggerFetchBookInfo() {
    _service.getBookDetail(bookId, success: (Map<String, dynamic> map) {
      _bookInfoCtrl.add(BookDetailInfo.fromJson(map));
    }, failed: () {
      _bookInfoCtrl.add(null);
    });
  }

  void _triggerFetchHotComments() {
    _service.getBookHotComments(bookId, 3, success: (Map<String, dynamic> map) {
      List<dynamic> commentJsons = map["reviews"] as List;
      var comments = commentJsons.map((map)=> CommentBean.fromJson(map)).toList();
      _hotCommentsCtrl.add(comments);
    });
  }

  void _triggerFetchRecommends() {
    _service.getRecommendBooks(bookId, 3, success: (Map<String, dynamic> map) {
      List<dynamic> recommendJsons = map["booklists"] as List;
      var recommends = recommendJsons.map((map) => RecommendBookBean.fromJson(map)).toList();
      _recommendsCtrl.add(recommends);
    });
  }
}

class DetailViewHelper {
  ///num >= 100000 返回num / 10000 万字，否自返回num字
  static String convertNum(int number) {
    return number >= 100000 ? "${number ~/ 10000}万字" : "$number字";
  }

  ///转换时间戳
  /// * 如果timeStamp表示的时间在今天，那么就显示x小时前
  /// * 如果timeStamp表示的时间为昨天，那么就显示昨天
  /// * 否则显示为yyyy-MM-dd
  static String convertTime(String timeStamp) {
    DateTime time = DateTime.parse(timeStamp);

    DateTime now = DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day); //今天 00：00
    DateTime yesterday = new DateTime(now.year, now.month, now.day - 1); //昨天00：00

    Duration duration = now.difference(time);
    if (time.isAfter(today) && now.isAfter(time)) {
      return "${duration.inHours}小时前";
    }
    if (time.isAfter(yesterday) && today.isAfter(time)) {
      return "昨天";
    }
    return "${time.year}-${time.month.toString().padLeft(2, "0")}-${time.day.toString().padLeft(2, "0")}";
  }
}
