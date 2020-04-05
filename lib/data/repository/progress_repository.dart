import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/progress.dart';

class ProgressRepository{
  Future<Progress> getDetailProgress({int detailId}) async{
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.detailPath+"$detailId/progress/"),);
      print(response);
      return Progress.fromJson(response.data['data']);
    } catch (e) {
      print(e);
    }
    return null;
  }

}