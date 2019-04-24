import 'package:novel_reader/constants.dart';
import 'package:novel_reader/db/provider/book_detail_provider.dart';
import 'package:novel_reader/db/provider/db_bean.dart';

class ShelfBook {
  String id;
  String image;
  String title;
  String content;
  bool isLocale;
  bool showHint; //是否显示小红点

  ShelfBook(
      {this.id,
      this.image,
      this.title,
      this.content,
      this.showHint,
      this.isLocale});

  static ShelfBook fromBookBean(DBBookBean book) {
    String id = book.id;
    String image = "$IMG_BASE_URL${book.cover}";
    String title = book.title;

    DateTime updateTime = DateTime.parse(book.updateTime);
    String properTime = generateProperData(updateTime);

    String content = "$properTime: ${book.lastChapter}";
    bool showHint = true;

    return ShelfBook(
        id: id,
        image: image,
        title: title,
        content: content,
        showHint: showHint,
        isLocale: false);
  }

  ///生成合适的时间信息， now - time < 24h那么返回xx小时前；如果 now - time > 24 && time < 昨天，那么就返回昨天，其它都返回yyyy-MM-dd
  static String generateProperData(DateTime time) {
    DateTime now = DateTime.now();
    Duration duration = now.difference(time);
    if (duration.inHours < 24) {
      return "${duration.inHours}小时前";
    }
    if (duration.inDays < 2) {
      return "昨天";
    }
    return "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
  }
}
