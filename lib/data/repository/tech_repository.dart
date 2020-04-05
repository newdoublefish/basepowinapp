import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/technology.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';

import 'object_repository.dart';

class TechnologyModalRepository extends ObjectRepository<TechnologyModal> {
  TechnologyModalRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory TechnologyModalRepository.init() {
    return TechnologyModalRepository(
      url: ImmpApi.getApiPath(ImmpApi.techModalPath),
      objectFromJsonFunc: (value) {
        return TechnologyModal.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}

class TechObjectRepository extends ObjectRepository<Tech> {
  TechObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory TechObjectRepository.init() {
    return TechObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.techPath),
      objectFromJsonFunc: (value) {
        return Tech.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }

  Future<TechnologyModal> getModal({int id}) async{
    try {
      Response response;
      response = await HttpHelper().getDio().get(
        ImmpApi.getApiPath(ImmpApi.techModalPath+"$id/"),);
      print(response);
      TechnologyModal modal = TechnologyModal.fromJson(response.data);
      return modal;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class TechRepository{
  Future<bool> create({
    Tech tech,
  }) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.techCreateInflow),
          data: tech.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<Tech> getTechDetail({
    int id
  }) async {
    try {
      Response response;

      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.techPath+"$id/"),);
      print(response);
//      for(var result in response.data['detail'])
//      {
//         list.add(TechDetail.fromJson(result));
//      }
      print(Tech.fromJson(response.data));
      return Tech.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> commit({
    FlowInstance instance,
    Node node
  }) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowCommit),
          data: {
            "flow_code": instance.code,
            "node_code": node.code
          });
      print(response);
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<TechnologyModal> getModal({int id}) async{
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.techModalPath+"$id/"),);
      print(response);
      TechnologyModal modal = TechnologyModal.fromJson(response.data);
      return modal;
    } catch (e) {
      print(e);
    }
    return null;
  }
}