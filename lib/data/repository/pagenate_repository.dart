import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/data/http.dart';

class PageNateRepository {
  int count = 0;
  String preUrl;
  String nextUrl;
  bool hasReachedMax = false;

  void reset() {
    preUrl = null;
    nextUrl = null;
    hasReachedMax = false;
    count = 0;
  }

  Future<ReqResponse> request(
      {String url, Map<String, dynamic> queryParams}) async {
    ReqResponse response;
    if (preUrl == null && nextUrl == null) {
      response = await HttpHelper().get(url: url, queryParams: queryParams);
      if (response.isSuccess) {
        preUrl = url;
        nextUrl = response.t['next'];
        count = response.t['count'];
        if (nextUrl == null) {
          hasReachedMax = true;
        }
      }
    } else {
      if (nextUrl != null) {
        response =
            await HttpHelper().get(url: nextUrl, queryParams: queryParams);
        if (response.isSuccess) {
          nextUrl = response.t['next'];
          if (nextUrl != null) {
            preUrl = nextUrl;
          } else {
            hasReachedMax = true;
          }
        }
      }
    }
    return response;
  }
}
