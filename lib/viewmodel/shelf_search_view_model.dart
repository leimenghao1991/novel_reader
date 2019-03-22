import 'dart:async';

import 'package:novel_reader/model/search_view_bean.dart';
import 'package:novel_reader/repo/service/book_service.dart';
import 'dart:developer';

class ShelfSearchViewModel {
  BookService _service;

  List<String> hotSearchTags; //热门搜索标签

  static const int TAG_LIMIT = 8;
  int _tagStartIndex = 0; //请求热门tag时，后台一次性返回所有tag，因此这里做一个本地的截取处理。该变量表示开始截取的index。

  StreamController<ViewData> _viewStreamCtrl;

  ViewData _viewEvent;

  ShelfSearchViewModel() {
    _service = new BookService();
    hotSearchTags = new List();
    _viewStreamCtrl = new StreamController();
    _viewEvent = new ViewData();
  }

  Stream<ViewData> viewStatusStream() => _viewStreamCtrl.stream;

  ///当前视图类型  0-无输入字符串状态；1-输入字符串，提示关键字状态；2-搜索结果状态
  void triggerViewStatusChange(int changeTo) {
    _viewStreamCtrl.add(_viewEvent._ofStatus(changeTo));
  }

  ///触发热门搜索词刷新
  void triggerRefreshTag() {
    if (hotSearchTags.isNotEmpty) {
      _triggerRefreshTagLocal();
      return;
    }

    _service.getSearchHotWords(success: (Map<String, dynamic> data) {
        hotSearchTags.clear();
        hotSearchTags.addAll(List.from(data["hotWords"]));
        _triggerRefreshTagLocal();
    });
  }

  /// 触发用户关键词补全 这里做个优化，在NovelReader 的app中，如果没有匹配到，那么界面就会回到热词推荐界面。
  ///
  /// 这里就不回到热词推荐界面了，如果没有匹配到最新的结果，那么就显示上一次匹配的结果
  void triggerInputSuggest(String input) {
    if (input == null || input.isEmpty) {
      resetViewStatus();
      return;
    }

    Function response = (Map<String, dynamic> data) {
      List<String> suggestWords = List.from(data["keywords"]);
      _viewEvent._ofSuggestWords(suggestWords);
      _viewStreamCtrl.add(_viewEvent);
    };
    _service.getInputSuggest(input, success: response, empty: response);
  }

  ///触发搜索
  void triggerSearch(String input) {
    if (input == null || input.isEmpty) {
      return;
    }
    Function response = (Map<String, dynamic> data) {
      List<ShowSearchBookBean> suggestWords = List.from(data["books"]).map((json) => ShowSearchBookBean.fromJson(json)).toList();
      _viewEvent._ofSearchResult(suggestWords);
      _viewStreamCtrl.add(_viewEvent);
    };
    _service.searchBook(input, success: response, empty: response);
  }

  //重新回到热词推荐状态界面
  void resetViewStatus() {
    _viewStreamCtrl.add(_viewEvent._reset());
  }

  bool viewInOriginStatus() {
    return _viewEvent.viewStatus == ViewData.STATUS_EMPTY_INPUT;
  }

  void _triggerRefreshTagLocal() {
    if (hotSearchTags.isEmpty) {
      return;
    }

    int endIndex = _tagStartIndex + TAG_LIMIT;
    if (endIndex >= hotSearchTags.length) {
      _tagStartIndex = 0;
      endIndex = TAG_LIMIT;
    }

    _viewStreamCtrl.add(_viewEvent._ofHotTags(hotSearchTags.sublist(_tagStartIndex, endIndex)));
    _tagStartIndex = endIndex;
  }

  void dispose() {
    _viewStreamCtrl.close();
  }

}

class ViewData {
  static const int STATUS_EMPTY_INPUT = 0;
  static const int STATUS_SUGGEST_WORD = 1;
  static const int STATUS_SEARCH_RESULT = 2;

  List<String> hotTags; //热门搜索标签
  List<String> suggestWords; //建议搜索词
  List<ShowSearchBookBean> searchResult; //搜索结果

  int viewStatus;

  ViewData() {
    hotTags = new List();
    suggestWords = new List();
    searchResult = new List();
    viewStatus = STATUS_EMPTY_INPUT;
  }

  ViewData _ofStatus(int status) {
    viewStatus = status;
    return this;
  }

  ViewData _reset() {
    viewStatus = STATUS_EMPTY_INPUT;
    suggestWords.clear();
    searchResult.clear();
    return this;
  }

  ViewData _ofHotTags(List<String> tags) {
    hotTags.clear();
    hotTags.addAll(tags);
    return this;
  }

  ViewData _ofSuggestWords(List<String> words) {
    if (words == null || words.isEmpty) {
      return this;
    }
    suggestWords.clear();
    suggestWords.addAll(words);
    viewStatus = STATUS_SUGGEST_WORD;
    return this;
  }

  ViewData _ofSearchResult(List<ShowSearchBookBean> result) {
    viewStatus = STATUS_SEARCH_RESULT;
    if (result == null || result.isEmpty) {
      searchResult.clear();
      return this;
    }
    searchResult.clear();
    searchResult.addAll(result);
    return this;
  }
}