import 'package:flutter/material.dart';
import 'package:novel_reader/constants.dart';
import 'package:novel_reader/model/search_view_bean.dart';
import 'package:novel_reader/viewmodel/shelf_search_view_model.dart';
import 'dart:developer';

import 'package:novel_reader/pages/book_detail_view.dart';

class SearchView extends StatefulWidget {
  @override
  SearchView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchViewState();
  }
}

class _SearchViewState extends State<SearchView> {

  final TextEditingController _controller = new TextEditingController();
  ShelfSearchViewModel _viewModel;

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  void initState() {
    super.initState();
    _viewModel = new ShelfSearchViewModel();
    _viewModel.triggerRefreshTag();
  }

  ///搜索
  void _search(String input) {
    if (_controller.text != input) {
      _controller.text = input;
    }
    _viewModel.triggerSearch(input);
  }

  ///输入内容发生改变
  void _onInputChange(String input) {
    _viewModel.triggerInputSuggest(input);
  }

  ///刷新标签
  void _refreshHotSearchTag() {
    _viewModel.triggerRefreshTag();
  }

  ///点击搜索结果的某本书
  void _tapBook(ShowSearchBookBean book) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return new BookDetailView(bookId: book.id);
    }));
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => _pop(context)),
      title: TextField(
        controller: _controller,
        cursorColor: Colors.red,
        cursorWidth: 0.5,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          hintText: "请输入书名|作者名",
          hintStyle: TextStyle(color: ICON_GRAY_COLOR),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Colors.transparent)
          )
        ),
        onChanged: (input) => _onInputChange(input),
        onSubmitted: (input) => _search(input),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _search(_controller.text),
        )
      ],
    );
  }

  ///热门搜索标签
  Widget _buildHotTagWidgets(List<String> tags) {
    if (tags == null || tags.isEmpty) {
      return Container();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      runAlignment: WrapAlignment.spaceEvenly,
      children: tags.map((tag) =>
          FlatButton(
            color: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(tag, style: TextStyle(color: Colors.black, fontSize: 13),),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                  color: Color(0xFFB8B8B8),
                  style: BorderStyle.solid,
                  width: 1
              ),
            ),
            onPressed: () => _search(tag),
          )
      ).toList(),);
  }

  ///无输入状态页面
  Widget _buildEmptyInputWidget(BuildContext context, ViewData data) {
    var tags = data == null ? null : data.hotTags;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(10, 24, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("热门搜索",
                      style: TextStyle(
                          fontSize: 15, color: ICON_GRAY_COLOR),),

                    FlatButton.icon(
                        onPressed: () => _refreshHotSearchTag(),
                        icon: Icon(Icons.refresh, color: ICON_GRAY_COLOR,),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(0),
                        label: Text("换一批",
                            style: TextStyle(
                                fontSize: 15, color: ICON_GRAY_COLOR))),
                  ])),
          new Container(child: _buildHotTagWidgets(tags), margin: EdgeInsets.all(4),)
        ],
      ),
    );
  }

  ///用户输入自动补齐状态页面，会显示自动补齐的建议词列表
  Widget _buildSuggestWordWidget(BuildContext context, ViewData data) {
    List<String> words = data.suggestWords;
    return new Container(
        color: Colors.white,
        child: new ListView(
        itemExtent: 45,
        children: words.map((word) => new ListTile(
          leading: Container(
            child: Icon(Icons.search, color: ICON_GRAY_COLOR),
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          ),
          title: Container(
            child: Text(word, style: TextStyle(fontSize: 14, color: Colors.black),),
            padding: EdgeInsets.all(0),
          ),
          onTap: () => _search(word),
          dense: false,
        )).toList(),
    ));
  }

  /// 搜索结果页面
  Widget _buildSearchResultWidget(BuildContext context, ViewData data) {
    List<ShowSearchBookBean> results = data.searchResult;
    if (results.isEmpty) {
      return _buildEmptySearchResult();
    }
    return _buildNoEmptySearchResult(results);
  }

  ///搜索结果为空
  Widget _buildEmptySearchResult() {
    return Container(
      alignment: Alignment.center,
      child: Image.asset("assets/images/ic_no_data.png"),
    );
  }

  ///搜索结果不为空
  Widget _buildNoEmptySearchResult(List<ShowSearchBookBean> data) {
    return ListView.builder(
        itemBuilder: (context, position) {
          ShowSearchBookBean book = data[position];
          return ListTile(
            leading: Image.network(book.image, width: 45, height: 60,),
            title: Text(book.title, maxLines: 1,),
            subtitle: Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child:Text(book.subTitle)
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
            onTap: () => _tapBook(book),
          );
        },
        itemCount: data.length,
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder(
          stream: _viewModel.viewStatusStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            ViewData data = snapshot.data;
            if (data == null) {
              return _buildEmptyInputWidget(context, data);
            }
            switch (data.viewStatus) {
              case ViewData.STATUS_EMPTY_INPUT:
                return _buildEmptyInputWidget(context, data);
              case ViewData.STATUS_SUGGEST_WORD:
                return _buildSuggestWordWidget(context, data);
              case ViewData.STATUS_SEARCH_RESULT:
                return _buildSearchResultWidget(context, data);
            }
            return _buildEmptyInputWidget(context, data);
          }),
    );
  }

  void _pop(BuildContext context) {
    if (_viewModel == null || _viewModel.viewInOriginStatus()) {
      Navigator.of(context).pop();
      return;
    }

    _controller.clear();
    _viewModel.resetViewStatus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _pop(context);
      },
      child: _buildPage(context),
    );
  }

}

