import 'package:novel_reader/constants.dart';

///全量的搜索结果：除了highlight字段为其它的都在了
///
/// {
///       "_id": "59b4b7ede631eec448f447c5",
///       "hasCp": true,
///       "title": "陪师姐修仙的日子",
///       "aliases": "",
///       "cat": "仙侠",
///       "author": "西瓜炒哈密瓜",
///       "site": "zhuishuvip",
///       "cover": "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F2147712%2F2147712_6c25670fb9a542c88b5d34bdd7c43bd6.jpg%2F",
///       "shortIntro": "一句胸不平何以平天下，林峰穿越了。　　据说上面有了六个师姐，一个比一个奇葩，典型天赋点歪了的类型。　　别人修真，天资聪颖。　　轮到我了，有点尴尬。　　别人修真，一日千里。　　轮到我了，千日半米。　　有时候我严重怀疑自己修了个假真。　　所以我决定，打得你们通通怀疑人生。",
///       "lastChapter": "正文卷 第一千一百五十七章 拍马屁也能成圣",
///       "retentionRatio": 59.33,
///       "banned": 0,
///       "allowMonthly": false,
///       "latelyFollower": 3935,
///       "wordCount": 3652598,
///       "contentType": "txt",
///       "superscript": "",
///       "sizetype": -1,
///       "highlight": {
///         "author": [
///           "哈"
///         ]
///       }
///     }
///
class SearchBookBean {
  String id;
  bool hasCp;
  String title;
  String aliases;
  String cat;
  String author;
  String site;
  String cover;
  String shortIntro;
  String lastChapter;
  double retentionRatio;
  int banned;
  bool allowMonthly;
  int latelyFollower;
  int wordCount;
  String contentType;
  String superScript;
  int sizeType;

  SearchBookBean({
    this.id,
    this.hasCp,
    this.title,
    this.aliases,
    this.cat,
    this.author,
    this.site,
    this.cover,
    this.shortIntro,
    this.lastChapter,
    this.retentionRatio,
    this.banned,
    this.allowMonthly,
    this.latelyFollower,
    this.wordCount,
    this.contentType,
    this.superScript,
    this.sizeType});

  static SearchBookBean fromJson(Map<String, dynamic> map) {
    return SearchBookBean(
      id: map["_id"],
      hasCp: map["hasCp"],
      title: map["title"],
      aliases: map["aliases"],
      cat: map["cat"],
      author: map["author"],
      site: map["site"],
      cover: "$IMG_BASE_URL${map["cover"]}",
      shortIntro: map["shortIntro"],
      lastChapter: map["lastChapter"],
      retentionRatio: map["retentionRatio"],
      banned: map["banned"],
      allowMonthly: map["allowMonthly"],
      latelyFollower: map["latelyFollower"],
      wordCount: map["wordCount"],
      contentType: map["contentType"],
      superScript: map["superscript"],
      sizeType: map["sizetype"]
    );
  }
}

class ShowSearchBookBean {
  String id;
  String title;
  String image;
  String subTitle;

  ShowSearchBookBean({
    this.id,
    this.title,
    this.image,
    this.subTitle
  });

  static ShowSearchBookBean fromJson(Map<String, dynamic> map) {
    String id = map["_id"];
    String title = map["title"];
    String image = "$IMG_BASE_URL${map["cover"]}";
    String subTitle = "${map["latelyFollower"]}人在追 | ${map["retentionRatio"]}读者留存 | ${map["author"]}著";
    return ShowSearchBookBean(id: id, title: title, image: image, subTitle: subTitle);
  }
}

///     {
///       "_id": "5c7167eaf1a4776d00717f55",
///       "rating": 4,
///       "author": {
///         "_id": "5728e1afd506f9f103af70df",
///         "avatar": "/avatar/54/0e/540e9d938043b8c3c11e51d95497cea6",
///         "nickname": "方圆百里",
///         "activityAvatar": "",
///         "type": "normal",
///         "lv": 10,
///         "gender": "female"
///       },
///       "helpful": {
///         "total": 2,
///         "yes": 3,
///         "no": 1
///       },
///       "likeCount": 0,
///       "state": "normal",
///       "updated": "2019-02-27T15:43:25.967Z",
///       "created": "2019-02-23T15:34:02.491Z",
///       "commentCount": 1,
///       "content": "前面一百二十多章完全大修重写了。\n安娜没了，毒点基本删除了 \n一年级作者试手的文章基本全部重写了。\n从二三年纪开始有趣起来，写的不错。\n这本小说看个人喜好，不喜欢同人的会看的一般吧。\n但是看这里盗版的，肯定很难受，因为没大修之前毒点太多了。所以留存率这么低。\n所以，为了赞赏作者的态度（宁可一百多章重写大修），跟后期的进步，可以打个4.5星。\n最后说一句，这是个女作者。。❤",
///       "title": "强烈建议大家去起点看前面的免费章节，大修过"
///     }
///
///
///
///
class CommentBean {
  String id;
  User author;
  int rating; //几星评价
  String title; //comment title
  String content; //comment content
  int likeCount;

  CommentBean({
    this.id,
    this.author,
    this.rating,
    this.title,
    this.content,
    this.likeCount
  });


  static CommentBean fromJson(Map json) {
    return CommentBean(
      id: json["_id"],
      author: User.fromJson(json["author"]),
      rating: json["rating"],
      title: json["title"],
      content: json["content"],
      likeCount: json["likeCount"]
    );
  }
}

class User {
  String id;
  String avatar;
  String nickName;
  int level;
  String gender;

  User({this.id, this.avatar, this.nickName, this.level, this.gender});

  static User fromJson(Map json) {
    return User(
      id: json["_id"],
      avatar: "$IMG_BASE_URL${json["avatar"]}",
      nickName: json["nickname"],
      level: json["lv"],
      gender: json["gender"]
    );
  }
}
