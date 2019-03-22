import 'package:flutter/material.dart';
import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/model/shelf_view_beans.dart';
import 'package:novel_reader/pages/shelf/shelf_bloc.dart';
import 'dart:developer';

class ShelfView extends StatelessWidget {
  @override
  ShelfView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShelfBloc _bloc = BlocProvider.of(context);
    return new StreamBuilder(
        initialData: _bloc.cache,
        stream: _bloc.books,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildBookLists(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildBookLists(List<ShelfBook> books) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        child: ListView.separated(
            itemBuilder: (context, position) {
              return _buildListData(context, books[position]);
            },
            separatorBuilder: (context, position) => Container(
                  height: 1,
                  color: Color(0xFFFAFAFA),
                ),
            itemCount: books.length),
      ),
    );
  }

  void _showLongPressDialog(BuildContext context, ShelfBook book) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: new Text(book.title),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("置顶"),
                onPressed: () {},
              ),
              SimpleDialogOption(
                child: Text("缓存"),
                onPressed: () {},
              ),
              SimpleDialogOption(
                child: Text("删除"),
                onPressed: () {},
              ),
              SimpleDialogOption(
                child: Text("批量管理"),
                onPressed: () {},
              )
            ],
          );
        });
  }

  Widget _buildListData(BuildContext context, ShelfBook book) {
    var item = book;
    print("${item.title} images is ${item.image}");
    return new ListTile(
      dense: false,
      isThreeLine: false,
      leading: Image.network(
        (item.image),
        width: 45,
        height: 60,
      ),
      title: Text(
        item.title,
        maxLines: 1,
      ),
      subtitle: Text(
        item.content,
        maxLines: 1,
      ),
      trailing: item.showHint
          ? Image.asset(
              "assets/images/notif_red_dot.png",
              width: 9,
              height: 9,
            )
          : null,
      contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      onLongPress: () {
        _showLongPressDialog(context, book);
      },
    );
  }
}