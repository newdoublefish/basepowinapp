import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/beans/project.dart';
import 'pagenate_repository.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/data/apis.dart';
import 'dart:async';
import 'object_repository.dart';

class FlowModalsObjectRepository extends ObjectRepository<Procedure> {
  FlowModalsObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc,
        @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory FlowModalsObjectRepository.init() {
    return FlowModalsObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.flowModalPath),
      objectFromJsonFunc: (value) {
        return Procedure.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}

class FlowModalsRepository {
  List<Procedure> modals = [];
  PageNateRepository _repository = PageNateRepository();

  bool isMax() {
    return _repository.hasReachedMax;
  }

  clear() {
    modals.clear();
    _repository.reset();
  }

  Future<ReqResponse<List<Procedure>>> getModals(
      {Map<String, dynamic> queryParams = const {}}) async {
    try {
      if (_repository.hasReachedMax == false) {
        Response response;
//        response= await _repository.request(
//            url: ImmpApi.getApiPath(ImmpApi.flowModalPath),
//            queryParams: queryParams);
        if (response != null) {
          for (var result in response.data['results']) {
            modals.add(Procedure.fromJson(result));
          }
        }
      }
      return ReqResponse(isSuccess: true, t: modals);
    } catch (e) {
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Future<bool> create({Procedure procedure}) async {
    try {
      Response response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowModalPath),
          data: procedure.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> put({Procedure procedure}) async {
    try {
      print(procedure);
      Response response = await HttpHelper().getDio().put(
          ImmpApi.getApiPath(ImmpApi.flowModalPath + "${procedure.id}/"),
          data: procedure.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> delete({Procedure procedure}) async {
    try {
      print(procedure);
      Response response = await HttpHelper().getDio().delete(
            ImmpApi.getApiPath(ImmpApi.flowModalPath + "${procedure.id}/"),
          );
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
