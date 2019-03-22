import 'package:flutter/material.dart';

class FindView extends StatelessWidget {
  final List<ItemModel> _items = [
    new ItemModel(
      "排行榜",
      "assets/images/ic_section_top.png",
      "TOP",
    ),
    new ItemModel(
      "主题书单",
      "assets/images/ic_section_topic.png",
      "TOPIC",
    ),
    new ItemModel(
      "分类",
      "assets/images/ic_section_sort.png",
      "SORT",
    ),
    new ItemModel(
      "有声小说",
      "assets/images/ic_section_listen.png",
      "LISTEN",
    ),
  ];

  FindView({Key key}) : super(key: key);

  List<Widget> _buildList(BuildContext context) {
    Iterable<Widget> listTiles = _items.map<Widget>((ItemModel model) =>
        Ink(color: Colors.white, child: ListTile(
          dense: false,
          title: Text(
            model.name, style: TextStyle(fontSize: 18),),
          leading: Image.asset(model.image, scale: 3.0,),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            print("${model.name} taped");
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        )));
    return ListTile.divideTiles(context: context, tiles: listTiles).toList();
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = _buildList(context);
    return new Scaffold(
      body: Scrollbar(
          child: new ListView(
            children: widgets,
          )
      ),
    );
  }
}

class ItemModel {
  String image;
  String tag;
  String name;

  ItemModel(this.name, this.image, this.tag);
}