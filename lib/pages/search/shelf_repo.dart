
import 'package:dio/dio.dart';
import 'package:novel_reader/model/search_view_bean.dart';
import 'package:novel_reader/repo/service/book_service.dart';

class SearchRepo {
  BookService _service;

  SearchRepo() {
    _service = BookService.get();
  }

  Future<List<String>> getTags() async{
    Response response = await _service.getSearchHotWords();
    if (!isResponseSuccess(response)) {
      return [];
    }

    var tagsJson = response.data["hotWords"];
    if (tagsJson == null) {
      return [];
    }

    return List.from(tagsJson);
  }

  Future<List<String>> getSuggestWords(String input) async {
    Response response = await _service.getInputSuggest(input);
    if (!isResponseSuccess(response)) {
      return [];
    }

    var suggestsJson = response.data["keywords"];
    if (suggestsJson == null) {
      return [];
    }

    return List.from(suggestsJson);
  }

  Future<List<ShowSearchBookBean>> getSearchResult(String input) async {
    Response response = await _service.searchBook(input);
    if (!isResponseSuccess(response)) {
      return [];
    }

    return List.from(response.data["books"]).map((json) => ShowSearchBookBean.fromJson(json)).toList();
  }

}