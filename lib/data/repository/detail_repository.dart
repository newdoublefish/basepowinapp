import 'package:manufacture/beans/project.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/req_response.dart';
import 'pagenate_repository.dart';

import 'object_repository.dart';
import 'dart:async';

class DetailObjectRepository extends ObjectRepository<Detail> {
  DetailObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory DetailObjectRepository.init() {
    return DetailObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.detailPath),
      objectFromJsonFunc: (value) {
        return Detail.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}

class DetailRepository{
  List<Detail> details = [];
  PageNateRepository _repository = PageNateRepository();

  bool isMax() {
    return _repository.hasReachedMax;
  }

  clear() {
    details.clear();
    _repository.reset();
  }

  Future<ReqResponse<List<Detail>>> getDetails(
      {Map<String, dynamic> queryParams = const {}}) async {
    try {
      if (_repository.hasReachedMax == false) {
        Response response;
//        response= await _repository.request(
//            url: ImmpApi.getApiPath(ImmpApi.detailPath),
//            queryParams: queryParams);
        if (response != null) {
          for (var result in response.data['results']) {
            details.add(Detail.fromJson(result));
          }
        }
      }
      return ReqResponse(isSuccess: true, t: details);
    } catch (e) {
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Future<bool> create({Detail detail}) async{
    try{
      Response response = await HttpHelper().getDio().post(ImmpApi.getApiPath(ImmpApi.detailPath),data: detail.toJson());
      return true;
    }catch(e){
      print(e);
    }
    return false;
  }

  Future<bool> put({Detail detail}) async{
    try{
      Response response = await HttpHelper().getDio().put(ImmpApi.getApiPath(ImmpApi.detailPath+"${detail.id}/"),data: detail.toJson());
      return true;
    }catch(e){
      print(e);
    }
    return false;
  }

  Future<bool> delete({Detail detail}) async{
    try{
      Response response = await HttpHelper().getDio().delete(ImmpApi.getApiPath(ImmpApi.detailPath+"${detail.id}/"),);
      return true;
    }catch(e){
      print(e);
    }
    return false;
  }
}