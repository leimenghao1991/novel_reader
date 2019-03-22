import 'package:novel_reader/constants.dart';

/// url: http://api.zhuishushenqi.com/book/5a997704b01a78b173e3d03a
/// get method
///
/// 完整的请求结果：
/// {
///   "_id": "5a997704b01a78b173e3d03a",
///   "title": "哈利波特之学霸无敌",
///   "author": "桐棠",
///   "longIntro": "人人都怕神秘人，救世主哈利有逆天运气，艾伦·哈里斯有学霸无敌系统，看学霸在巫师世界翻云覆雨，创造传奇！",
///   "cover": "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F2248358%2F2248358_a4438c61391c493cb0962fd98eb5e54e.jpg%2F",
///   "majorCate": "奇幻",
///   "minorCate": "西方奇幻",
///   "majorCateV2": "奇幻",
///   "minorCateV2": "西方奇幻",
///   "safelevel": 0,
///   "allowFree": false,
///   "originalAuthor": "",
///   "anchors": [],
///   "authorDesc": "",
///   "rating": {
///     "count": 112,
///     "score": 6.676,
///     "isEffect": true
///   },
///   "hasCopyright": true,
///   "buytype": 0,
///   "sizetype": -1,
///   "superscript": "",
///   "currency": 0,
///   "contentType": "txt",
///   "_le": false,
///   "allowMonthly": false,
///   "allowVoucher": true,
///   "allowBeanVoucher": true,
///   "hasCp": true,
///   "banned": 0,
///   "postCount": 72,
///   "latelyFollower": 1396,
///   "followerCount": 0,
///   "wordCount": 1328227,
///   "serializeWordCount": 2573,
///   "retentionRatio": "50.58",
///   "updated": "2019-02-26T16:05:48.747Z",
///   "isSerial": true,
///   "chaptersCount": 580,
///   "lastChapter": "正文卷 第五百六十六章 凤凰社（诚挚感谢盟主雨痕思）（求章说）",
///   "gender": [
///     "male"
///   ],
///   "tags": [],
///   "advertRead": true,
///   "cat": "西方奇幻",
///   "donate": false,
///   "copyright": "阅文集团正版授权",
///   "_gg": false,
///   "isForbidForFreeApp": true,
///   "isAllowNetSearch": true,
///   "limit": false,
///   "discount": null
/// }
///
///
class BookDetailInfo {
  String id;
  String title;
  String author;
  String cover;
  String brief;
  String cate;
  int wordCount;
  int postCount;
  String updateTime;
  int follwerCount; //追书人数
  String retentionRadio; //读者留存
  int serializeWordCount; //日更字数

  BookDetailInfo({this.id,
    this.title,
    this.author,
    this.cover,
    this.brief,
    this.cate,
    this.wordCount,
    this.postCount,
    this.updateTime,
    this.follwerCount,
    this.retentionRadio,
    this.serializeWordCount});

  static BookDetailInfo fromJson(Map<String, dynamic> json) {
    return BookDetailInfo(
      id: json["_id"],
      title: json["title"],
      author: json["author"],
      cover: "$IMG_BASE_URL${json["cover"]}",
      brief: json["longIntro"],
      cate: json["majorCate"],
      wordCount: json["wordCount"],
      postCount: json["postCount"],
      updateTime: json["updated"],
      follwerCount: json["followerCount"],
      retentionRadio: json["retentionRatio"],
      serializeWordCount: json["serializeWordCount"]
    );
  }
}

/// url: http://api.zhuishushenqi.com/book-list/5a997704b01a78b173e3d03a/recommend?limit=3
/// bean的完整结果：
///   {
///      "id": "56d73a45360a5c7128544211",
///      "title": "[老书虫看书]内带一点评论",
///      "author": "浮生",
///      "desc": "本人看小说从初一到现在 都是十一年了   从刚开始随手抓一本就能看几天，到现在越来越难找。 每天更新  想到啥说啥",
///      "bookCount": 22,
///      "cover": "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F60970%2F60970_4a17eed1135e41138a728d4b296f769c.jpg%2F",
///      "collectorCount": 533,
///      "covers": [
///        "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F60970%2F60970_4a17eed1135e41138a728d4b296f769c.jpg%2F",
///        "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F1149712%2F_1149712_530108.jpg%2F",
///        "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F46978%2F_46978_001736.jpg%2F"
///      ]
///    }
///
class RecommendBookBean {
  String id;
  String cover;
  String title;
  String author;
  String desc;
  int bookCount;
  int collectorCount;

  RecommendBookBean({
    this.id,
    this.cover,
    this.title,
    this.author,
    this.desc,
    this.bookCount,
    this.collectorCount
  });

  static RecommendBookBean fromJson(Map<String, dynamic> json) {
    return RecommendBookBean(
        id: json["id"],
        cover:  "$IMG_BASE_URL${json["cover"]}",
        title: json["title"],
        author: json["author"],
        desc: json["desc"],
        bookCount: json["bookCount"],
        collectorCount: json["collectorCount"]
    );
  }
}
