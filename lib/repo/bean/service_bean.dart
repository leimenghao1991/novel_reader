class BaseBean {
  bool ok;

  BaseBean({this.ok});
}

class RecommendBooks extends BaseBean {
  List<BookBean> books;

  RecommendBooks({bool ok, this.books}) : super(ok: ok);

  static RecommendBooks fromJson(Map<String, dynamic> json) {
    var list = json["books"] as List;
    bool ok = json["ok"];

    List<BookBean> bookModels;
    if (ok) {
      bookModels = list.map((i) =>
          BookBean.fromJson(list[i])
      ).toList();
    }

    return RecommendBooks(ok: json["ok"], books: bookModels);
  }
}

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
class BookBean {
  String id;
  String title;
  String author;
  String shortIntro;
  String cover;
  bool hasCp;
  int latelyFollower;
  double retentionRation;

  ///最新更新日期
  String updated;

  ///最新阅读日期
  String lastRead;
  int chaptersCount;
  String lastChapter;

  BookBean({
    this.id,
    this.title,
    this.author,
    this.shortIntro,
    this.cover,
    this.hasCp,
    this.lastChapter,
    this.chaptersCount,
    this.retentionRation,
    this.updated
  });

  static BookBean fromJson(Map<String, dynamic> json) {
    return BookBean(
      id: json["_id"],
      title: json["title"],
      author: json["author"],
      shortIntro: json["shortIntro"],
      cover: json["cover"],
      hasCp: json["hasCp"],
      lastChapter: json["lastChapter"],
      chaptersCount: json["chaptersCount"],
      retentionRation: json["retentionRatio"],
      updated: json["updated"]
    );
  }

  @override
  String toString() {
    return "new book bean title:$title";
  }

  @override
  bool operator ==(other) {
    if (other is BookBean) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}

class BookChapterBean {
  BookChapterBean(
      {String id,
      String link,
      String title,
      String taskName, //所属的下载任务
      bool unreadble,
      String bookId, //所属数据id
      int start, //在书籍文件中的起始位置
      int end //在书籍文件中的结束位置
      });
}
