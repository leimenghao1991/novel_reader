

import 'package:novel_reader/constants.dart';
import 'package:novel_reader/db/provider/book_detail_provider.dart';

class ShelfBook {
  String id;
  String image;
  String title;
  String content;
  bool showHint; //是否显示小红点

  ShelfBook(this.id, this.image, this.title, this.content, this.showHint);

 static ShelfBook fromJson(Map<String, dynamic> map) {
   String id = map["$columnId"];
   String image = "$IMG_BASE_URL${map["$columnCover"]}";
   String title = map["$columnTitle"];

   DateTime updateTime = DateTime.parse(map["$columnUpdate"]);
   String properTime = generateProperData(updateTime);

   String content = "$properTime: ${map["$columnLastChapter"]}";
   bool showHint = true;

   return ShelfBook(id, image, title, content, showHint);
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
   return "${time.year}-${time.month.toString().padLeft(2,'0')}-${time.day.toString().padLeft(2,'0')}";
 }
}
