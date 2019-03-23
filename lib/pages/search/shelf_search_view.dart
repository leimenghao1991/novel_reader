import 'package:flutter/material.dart';
import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/constants.dart';
import 'package:novel_reader/model/fromnet/search_view_bean.dart';
import 'package:novel_reader/pages/bookdetail/book_detail_bloc.dart';
import 'package:novel_reader/pages/search/shelf_search_bloc.dart';
import 'dart:developer';

import 'package:novel_reader/pages/bookdetail/book_detail_view.dart';

class SearchView extends StatefulWidget {
  @override
  SearchView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchViewState();
  }
}

class _SearchViewState extends State<SearchView> {
  SearchBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  ///点击搜索结果的某本书
  void _tapBook(BuildContext context, ShowSearchBookBean book) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider(
          child: BookDetailView(), bloc: BookDetailBloc(book.id));
    }));
  }

  Widget _buildAppBar(BuildContext context) {
    SearchBloc bloc = _getBloc(context);
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), onPressed: () => _pop(context)),
      title: TextField(
        controller: bloc.textEditController,
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
                borderSide: BorderSide(color: Colors.transparent))),
        onSubmitted: (input) => bloc.search(),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => bloc.search(),
        )
      ],
    );
  }

  ///热门搜索标签
  Widget _buildHotTagWidgets(List<String> tags, SearchBloc bloc) {
    if (tags == null || tags.isEmpty) {
      return Container();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      runAlignment: WrapAlignment.spaceEvenly,
      children: tags
          .map((tag) => FlatButton(
                color: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Text(
                  tag,
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      color: Color(0xFFB8B8B8),
                      style: BorderStyle.solid,
                      width: 1),
                ),
                onPressed: () => bloc.searchSpecified(tag),
              ))
          .toList(),
    );
  }

  ///无输入状态页面
  Widget _buildEmptyInputWidget(BuildContext context, SearchBloc bloc) {
    var tags = bloc.cache.hotTags;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(10, 24, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "热门搜索",
                      style: TextStyle(fontSize: 15, color: ICON_GRAY_COLOR),
                    ),
                    FlatButton.icon(
                        onPressed: () => bloc.refreshTags(),
                        icon: Icon(
                          Icons.refresh,
                          color: ICON_GRAY_COLOR,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.all(0),
                        label: Text("换一批",
                            style: TextStyle(
                                fontSize: 15, color: ICON_GRAY_COLOR))),
                  ])),
          new Container(
            child: _buildHotTagWidgets(tags, bloc),
            margin: EdgeInsets.all(4),
          )
        ],
      ),
    );
  }

  ///用户输入自动补齐状态页面，会显示自动补齐的建议词列表
  Widget _buildSuggestWordWidget(BuildContext context, SearchBloc bloc) {
    List<String> words = bloc.cache.suggestWords;
    return new Container(
        color: Colors.white,
        child: new ListView(
          itemExtent: 45,
          children: words
              .map((word) => new ListTile(
                    leading: Container(
                      child: Icon(Icons.search, color: ICON_GRAY_COLOR),
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    title: Container(
                      child: Text(
                        word,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      padding: EdgeInsets.all(0),
                    ),
                    onTap: () => bloc.searchSpecified(word),
                    dense: false,
                  ))
              .toList(),
        ));
  }

  /// 搜索结果页面
  Widget _buildSearchResultWidget(BuildContext context, SearchBloc bloc) {
    List<ShowSearchBookBean> results = bloc.cache.searchResult;
    if (results.isEmpty) {
      return _buildEmptySearchResult();
    }
    return _buildNoEmptySearchResult(context, results);
  }

  ///搜索结果为空
  Widget _buildEmptySearchResult() {
    return Container(
      alignment: Alignment.center,
      child: Image.asset("assets/images/ic_no_data.png"),
    );
  }

  ///搜索结果不为空
  Widget _buildNoEmptySearchResult(
      BuildContext context, List<ShowSearchBookBean> data) {
    return ListView.builder(
      itemBuilder: (context, position) {
        ShowSearchBookBean book = data[position];
        return ListTile(
          leading: Image.network(
            book.image,
            width: 45,
            height: 60,
          ),
          title: Text(
            book.title,
            maxLines: 1,
          ),
          subtitle: Container(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(book.subTitle)),
          contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          onTap: () => _tapBook(context, book),
        );
      },
      itemCount: data.length,
    );
  }

  Widget _buildPage(BuildContext context) {
    SearchBloc bloc = _getBloc(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder(
          initialData: bloc.cache,
          stream: bloc.data,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            SearchViewData data = bloc.cache;
            if (data == null) {
              return _buildEmptyInputWidget(context, bloc);
            }
            switch (data.viewStatus) {
              case SearchViewData.STATUS_EMPTY_INPUT:
                return _buildEmptyInputWidget(context, bloc);
              case SearchViewData.STATUS_SUGGEST_WORD:
                return _buildSuggestWordWidget(context, bloc);
              case SearchViewData.STATUS_SEARCH_RESULT:
                return _buildSearchResultWidget(context, bloc);
            }
            return _buildEmptyInputWidget(context, bloc);
          }),
    );
  }

  /// [inPage]:是否是页内返回，如：从搜索结果页->建议列表页，建议列表页->热门标签页
  void _pop(BuildContext context) {
    SearchBloc bloc = _getBloc(context);
    if (!bloc.backToInputPage()) {
      Navigator.of(context).pop();
      return;
    }
  }

  SearchBloc _getBloc(context) => _bloc;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _pop(
          context,
        );
      },
      child: _buildPage(context),
    );
  }
}
