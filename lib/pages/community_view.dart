import 'package:flutter/material.dart';

class CommunityView extends StatelessWidget {
  final List<ItemModel> _items = [
    new ItemModel(
      "综合讨论区",
      "assets/images/ic_section_comment.png",
      "ramble",
    ),
    new ItemModel(
      "书评区",
      "assets/images/ic_section_discuss.png",
      "",
    ),
    new ItemModel(
      "书荒帮助区",
      "assets/images/ic_section_help.png",
      "",
    ),
    new ItemModel(
      "女生区",
      "assets/images/ic_section_girl.png",
      "girl",
    ),
    new ItemModel(
      "原创区",
      "assets/images/ic_section_compose.png",
      "original",
    )
  ];

  CommunityView({Key key}) : super(key: key);

  List<Widget> _buildList(BuildContext context) {
    Iterable<Widget> listTiles = _items.map<Widget>((ItemModel model) =>
        Ink(color: Colors.white, child: ListTile(
          dense: false,
          title: Text(
            model.name, style: TextStyle(fontSize: 18),),
          leading: Image.asset(model.image, scale: 3.0,),
          trailing: Icon(Icons.keyboard_arrow_right),
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
