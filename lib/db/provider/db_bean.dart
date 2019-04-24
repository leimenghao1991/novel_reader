import 'package:novel_reader/service/book_detail_bean.dart';

///收藏的书籍
///
/// 例：<br>
/// {
///       "_id": "53ad795c75dfd5fa0d8ae982",
///       "title": "仙都",
///       "author": "陈猿",
///       "shortIntro": "“进山采药去了？”“没，俺爹不让去，说山里有狼，到夜里就叫唤。”",
///       "cover": "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F682770%2F682770_88d45e47e42f4177802c07613801cc41.jpg%2F",
///       "majorCate": "仙侠",
///       "contentType": "txt",
///       "allowMonthly": true,
///       "hasCp": true,
///       "latelyFollower": 34491,
///       "retentionRatio": 30.21,
///       "updated": "2019-03-20T14:06:14.842Z",
///       "chaptersCount": 1388,
///       "lastChapter": "第十八章 转战三万里，纵横五百年 第一百十五节 谋事在人"
///     }
class DBBookBean {
  String id;
  String title;
  String author;
  String shortIntro;
  String cover;
  double retentionRation;

  ///最新更新日期
  String updateTime;
  bool isUpdate;

  int chaptersCount;
  String lastChapter;
  bool locale;
  String path;

  DBBookBean(
      {this.id,
      this.title,
      this.author,
      this.shortIntro,
      this.cover,
      this.lastChapter,
      this.chaptersCount,
      this.retentionRation,
      this.updateTime,
      this.isUpdate = false,
      this.locale = false,
      this.path});

  static DBBookBean fromJson(Map<String, dynamic> json) {
    return DBBookBean(
        id: json["_id"],
        title: json["title"],
        author: json["author"],
        shortIntro: json["shortIntro"],
        cover: json["cover"],
        lastChapter: json["lastChapter"],
        chaptersCount: json["chaptersCount"],
        retentionRation: json["retentionRatio"],
        updateTime: json["updated"]);
  }

  @override
  String toString() {
    return "new book bean title:$title";
  }

  @override
  bool operator ==(other) {
    if (other is DBBookBean) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  static DBBookBean fromBookDetail(BookDetailInfo detail) {
    double retentionValue = 0;
    String retention = detail.retentionRadio;
    if (retention != null && retention.isNotEmpty) {
      retentionValue = double.parse(retention);
    }
    return new DBBookBean(
        id: detail.id,
        title: detail.title,
        author: detail.author,
        shortIntro: detail.brief,
        cover: detail.cover,
        lastChapter: detail.lastChapter,
        chaptersCount: detail.chapterCount,
        retentionRation: retentionValue,
        updateTime: detail.updateTime);
  }
}

class DBBookMark {
  String bookId;

  ///上次阅读的章节
  int chapterIndex;

  ///上次阅读的位置(以章节开始计算）
  int posInChapter;

  int posInBook;

  bool download;

  DBBookMark(
      {this.bookId,
      this.chapterIndex,
      this.posInChapter,
      this.posInBook,
      this.download = false});
}

class DBChapter {
  String bookId;
  String title;
  int index;
  int startPos; //章节文本字符串在全书中的开始位置
  int endPos; //章节文本字符串在全书中的结束位置
  bool download;
  String url;
  String localPath;

  DBChapter(
      {this.bookId,
      this.title,
      this.index,
      this.startPos,
      this.endPos,
      this.download,
      this.url,
      this.localPath});
}
