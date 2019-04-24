import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/service/search_view_bean.dart';
import 'package:novel_reader/pages/search/shelf_repo.dart';

class SearchBloc extends BlocBase {
  SearchViewData _cache = SearchViewData._internal();
  TagsCreator _tagsCreator = TagsCreator();

  TextEditingController _textEditController = new TextEditingController();

  SearchRepo _repo = SearchRepo();

  StreamController<SearchViewData> _viewDataController = StreamController<SearchViewData>();

  Stream<SearchViewData> get data => _viewDataController.stream;

  SearchViewData get cache => _cache;
  
  TextEditingController get textEditController => _textEditController;

  SearchBloc() {
    refreshTags();
    _initTextController();
  }

  ///初始化输入框控制器，用于监听输入变化
  void _initTextController() => textEditController.addListener((){
//    debugger(when: true);
    String oldInput = _cache.input;
    String newInput = textEditController.text;

    if (oldInput == newInput) {
      return;
    }

    _inputChanged(newInput);
  });

  void _updatePage() {
    _viewDataController.sink.add(_cache);
  }

  ///用户输入发生了变化
  void _inputChanged(String changedInput) {
    _cache._input = changedInput;

    if (changedInput == null || changedInput.isEmpty) {
      _viewDataController.add(_cache._reset());
      return;
    }
    _repo.getSuggestWords(changedInput).then((words) {
      _cache._ofSuggestWords(words);
      _updatePage();
    });
  }

  ///搜索某个标签、热门词、建议词
  void searchSpecified(String tag) {
    ///先赋值input这样在textController中就不会引起_inputChange()方法的回调
    _cache._input = tag;
    textEditController.text = tag;
    search();
  }

  ///刷新Tags
  void refreshTags() {
    if (_refreshTagsByLocal()) {
      return;
    }

    _repo.getTags().then((tagsFromServer) {
      _tagsCreator.allTags.clear();
      _tagsCreator.allTags.addAll(tagsFromServer);
      _refreshTagsByLocal();
    });
  }

  bool _refreshTagsByLocal() {
    List<String> tags = _tagsCreator.newTags();
    if (tags.isNotEmpty) {
      _cache._ofHotTags(tags);
      _updatePage();
      return true;
    }
    return false;
  }

  ///用户触发了搜索
  void search() {
    if (!_cache._checkInput()) {
      return;
    }
    _repo.getSearchResult(_cache.input).then((books){
      _cache._ofSearchResult(books);
      _updatePage();
    });
  }

  ///用户点击了返回
  bool backToInputPage() {
    if (_cache._isInOriginStatus()) {
      return false;
    }
    textEditController.text = "";
    _viewDataController.add(_cache._reset());
    return true;
  }

  @override
  void dispose() {
    _viewDataController.close();
  }
}

class SearchViewData {
  static const int STATUS_EMPTY_INPUT = 0;
  static const int STATUS_SUGGEST_WORD = 1;
  static const int STATUS_SEARCH_RESULT = 2;

  List<String> _hotTags; //热门搜索标签
  List<String> _suggestWords; //建议搜索词
  List<ShowSearchBookBean> _searchResult; //搜索结果

  String _input; //用户输入

  int _viewStatus;

  List<String> get hotTags => List.unmodifiable(_hotTags);

  List<String> get suggestWords => List.unmodifiable(_suggestWords);

  List<ShowSearchBookBean> get searchResult => List.unmodifiable(_searchResult);

  int get viewStatus => _viewStatus;

  String get input => _input;

  SearchViewData._internal() {
    _input = "";
    _hotTags = [];
    _suggestWords = [];
    _searchResult = [];
    _viewStatus = STATUS_EMPTY_INPUT;
  }

  bool _checkInput() {
    return _input != null && _input.isNotEmpty;
  }

  bool _isInOriginStatus() {
    return _viewStatus == SearchViewData.STATUS_EMPTY_INPUT;
  }

  SearchViewData _ofStatus(int status) {
    _viewStatus = status;
    return this;
  }

  SearchViewData _reset() {
    _viewStatus = STATUS_EMPTY_INPUT;
    _input = "";
    _suggestWords.clear();
    _searchResult.clear();
    return this;
  }

  SearchViewData _ofHotTags(List<String> tags) {
    _hotTags.clear();
    _hotTags.addAll(tags);
    return this;
  }

  SearchViewData _ofSuggestWords(List<String> words) {
    if (words == null || words.isEmpty) {
      return this;
    }
    _suggestWords.clear();
    _suggestWords.addAll(words);
    _viewStatus = STATUS_SUGGEST_WORD;
    return this;
  }

  SearchViewData _ofSearchResult(List<ShowSearchBookBean> result) {
    _viewStatus = STATUS_SEARCH_RESULT;
    if (result == null || result.isEmpty) {
      _searchResult.clear();
      return this;
    }
    _searchResult.clear();
    _searchResult.addAll(result);
    return this;
  }
}

class TagsCreator {
  List<String> allTags = [];

  static const int TAG_LIMIT = 8;
  int tagStartIndex = 0; //请求热门tag时，后台一次性返回所有tag，因此这里做一个本地的截取处理。该变量表示开始截取的index。

  List<String> newTags() {
    if (allTags.isEmpty) {
      return [];
    }

    int endIndex = tagStartIndex + TAG_LIMIT;
    if (endIndex >= allTags.length) {
      tagStartIndex = 0;
      endIndex = TAG_LIMIT;
    }

    List result = allTags.sublist(tagStartIndex, endIndex);
    tagStartIndex = endIndex;
    return result;
  }
}
