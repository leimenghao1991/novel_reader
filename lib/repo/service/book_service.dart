import 'package:dio/dio.dart';

class BookService {
  static const String BASE_URL = "http://api.zhuishushenqi.com";
  static final _bookService = BookService._internal();

  static BookService get() {
    return _bookService;
  }

  Dio _dio;

  BookService._internal() {
    _dio = new Dio();
    _dio.options.baseUrl = BASE_URL;
  }

  ///获取书架推荐列表
  ///
  /// gender: "male" or "female"
  ///
  Future<Response> getRecommendBookPackage(String gender) async {
    Response response = await _dio.get(
      "/book/recommend",
      queryParameters: {"gender": gender},
    );
    return response;
//    _handleResponse(response, success: success, error: error, empty: empty, failed: failed);
  }

  ///搜索数据
  Future<Response> searchBook(String query, {Function success, Function error, Function empty, Function failed}) async {
    Response response = await _dio.get(
      "/book/fuzzy-search",
      queryParameters: {"query": query}
    );
    return response;
  }

  ///获取搜索热词
  Future<Response> getSearchHotWords() async {
    Response response = await _dio.get("/book/hot-word");
    return response;
  }

  ///用户输入自动补全
  Future<Response> getInputSuggest(String input) async {
    Response response = await _dio.get(
        "/book/auto-complete",
        queryParameters: {"query": input}
    );

    return response;
  }

  ///获取书籍详细信息
  void getBookDetail(String bookId, {Function success, Function error, Function empty, Function failed}) async {
    Response response = await _dio.get("/book/$bookId");

    _handleResponse(response, success: success, error: error, empty: empty, failed: failed);
  }

  ///获取书籍的热门评论
  void getBookHotComments(String bookId, int count,
      {Function success, Function error, Function empty, Function failed}) async {
    Response response = await _dio.get(
        "/post/review/best-by-book",
        queryParameters: {
          "book": bookId,
          "limit": count
        }
    );

    _handleResponse(response, success: success, error: error, empty: empty, failed: failed);
  }

  ///根据给定的bookId获取推荐书籍
  void getRecommendBooks(String bookId, int count, {Function success, Function error, Function empty, Function failed}) async {
    Response response = await _dio.get(
      "/book-list/$bookId/recommend",
      queryParameters: {"limit": count}
    );

    _handleResponse(response, success: success, error: error, empty: empty, failed: failed);
  }

  ///failed是对于success来说的，一个请求要么success要么failed
  ///success是请求成功了，并且返回了具体数据
  ///error是带有具体错误信息的failed
  ///empty是请求成功了，但是没有数据的failed，比如搜索一个人，前后台通信成功了，但是没有匹配到，后台返回了空或者空map
  void _handleResponse(Response response, {Function success, Function error, Function empty, Function failed}) {
    int code = response.statusCode;
    bool successCalled = false;
    if (code >= 200 && code <= 300) {
      Map<String, dynamic> data = response.data;
      if (data != null) {
        if (success != null) {
          successCalled = true;
          success(data);
        }
      } else {
        if (empty != null) {
          empty(data);
        }
      }
    } else {
      if (error != null) {
        error("请求失败：$code");
      }
    }
    if (failed != null && !successCalled) {
      failed();
    }
  }
}


bool isResponseSuccess(Response response) {
  return response != null && response.statusCode >= 200 &&
      response.statusCode < 300 && response.data != null;
}
