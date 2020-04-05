import 'package:manufacture/beans/project.dart';
import 'object_repository.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/req_response.dart';

class ProjectObjectRepository extends ObjectRepository<Project> {
  static ProjectObjectRepository _projectObjectRepository;
  ProjectObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory ProjectObjectRepository.init() {
    if(_projectObjectRepository==null)
    {
      _projectObjectRepository = ProjectObjectRepository(
        url: ImmpApi.getApiPath(ImmpApi.projectPath),
        objectFromJsonFunc: (value) {
          return Project.fromJson(value);
        },
        objectToJsonFunc: (value) {
          return value.toJson();
        },
      );
    }
    return _projectObjectRepository;
  }
}


class ProjectRepository {
  List<Project> projectList = [];
  Map<int, List<Product>> detailProductMap = new Map();
  Map<int, List<FlowInstance>> detailFlowInstanceMap = new Map();
  String preUrl;
  String nextUrl;
  bool hasReachedMax = false;

  Future<ReqResponse<Project>> create({@required Project project}) async{
    try{
      Response response = await HttpHelper().getDio().post(ImmpApi.getApiPath(ImmpApi.projectPath),data: project.toJson());
      print(response);
      return ReqResponse(isSuccess: true);
    }catch(e){
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Future<ReqResponse<Project>> update({@required Project project}) async{
    try{
      Response response = await HttpHelper().getDio().put(ImmpApi.getApiPath(ImmpApi.projectPath+"${project.id}/"),data: project.toJson());
      print(response);
      return ReqResponse(isSuccess: true);
    }catch(e){
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Future<bool> delete({@required Project project}) async{
    try{
      Response response = await HttpHelper().getDio().delete(ImmpApi.getApiPath(ImmpApi.projectPath+"${project.id}/"));
      return true;
    }catch(e){
      print(e);
    }
    return false;
  }

  void clearProjectList() {
    if (projectList.length > 0) {
      projectList.clear();
    }
    hasReachedMax = false;
    preUrl = null;
    nextUrl = null;
  }

  Future<String> loadMoreProjectList(
      {String url,
      List<Project> projectList,
      Map<String, dynamic> queryParams}) async {
    try {
      Response response;
      response =
          await HttpHelper().getDio().get(url, queryParameters: queryParams);
      if (response.data['count'] >= 1) {
        for (var result in response.data['results']) {
          projectList.add(Project.fromJson(result));
        }
      }
      return response.data['next'];
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Project>> loadProjectList(
      {Map<String,dynamic> queryParams=const {}}) async {

    if (preUrl == null && nextUrl == null) {
      preUrl =
          ImmpApi.getApiPath(ImmpApi.projectPath); //ImmpApi.productPath;
      nextUrl = await loadMoreProjectList(
          url: preUrl, projectList: projectList, queryParams: queryParams);
      print(nextUrl);
      if(nextUrl==null){
        hasReachedMax = true;
      }
    } else {
      if (nextUrl != null) {
        if ((nextUrl = await loadMoreProjectList(
            url: nextUrl, projectList: projectList)) !=
            null) {
          preUrl = nextUrl;
        } else {
          hasReachedMax = true;
        }
      }
    }
    return projectList;
  }

  Future<List<Project>> fetchProjectList() async {
    try {
      Response response;
      response = await HttpHelper().getDio().get(
            ImmpApi.getApiPath(ImmpApi.projectPath),
          );
      if (response.data['count'] >= 1) {
        for (var result in response.data['results']) {
          projectList.add(Project.fromJson(result));
        }
      }
    } catch (e) {
      print(e);
    }
    return projectList;
  }

  Future<List<Detail>> fetchProjectListDetail(int id) async {
    try {
      Response response;
      response = await HttpHelper().getDio().get(
            ImmpApi.getApiPath(ImmpApi.projectPath + "$id/details/"),
          );
      if ("success".compareTo(response.data['status']) == 0) {
        List<Detail> detailList = [];
        for (var result in response.data['data']) {
          print(result);
          detailList.add(Detail.fromJson(result));
        }
        return detailList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Product> fetchProduct(int id) async {
    try {
      Response response;
      response = await HttpHelper().getDio().get(
            ImmpApi.getApiPath(ImmpApi.productPath + "$id"),
          );
      return Product.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Product> fetchProductByCode({String code}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().get(
        ImmpApi.getApiPath(ImmpApi.productPath),
        queryParameters: {"code": code},
      );
      print(response);
      if (response.data['count'] >= 1) {
        return Product.fromJson(response.data['results'][0]);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

//  Future<String> getProductList(String url, int id, List<Product> list) async {
//    try {
//      Response response;
//      response = await HttpHelper()
//          .getDio()
//          .get(url, queryParameters: {"project_detail": id});
//      print(response);
//      if (response.data['count'] >= 1) {
//        for (var result in response.data['results']) {
//          list.add(Product.fromJson(result));
//        }
//      }
//      return response.data['next'];
//    } catch (e) {
//      print(e);
//    }
//    return null;
//  }
//
//  //ImmpApi.productPath
//  void clearProductList(int id) {
//    if (detailProductMap[id] == null) {
//      detailProductMap[id] = [];
//    } else {
//      detailProductMap[id].clear();
//    }
//    preUrl = null;
//    nextUrl = null;
//  }

  Future<String> getFlowInstanceList(
      {String url,
      List<FlowInstance> list,
      Map<String, dynamic> queryParams}) async {
    try {
      Response response;
      response =
          await HttpHelper().getDio().get(url, queryParameters: queryParams);
      print(response);
      if (response.data['count'] >= 1) {
        for (var result in response.data['results']) {
          list.add(FlowInstance.fromJson(result));
        }
      }
      return response.data['next'];
    } catch (e) {
      print(e);
    }
    return null;
  }

  //ImmpApi.productPath
  void clearFlowInstanceList(int id) {
    if (detailFlowInstanceMap[id] == null) {
      detailFlowInstanceMap[id] = [];
    } else {
      detailFlowInstanceMap[id].clear();
    }
    preUrl = null;
    nextUrl = null;
  }

  Future<List<FlowInstance>> fetchFlowInstanceList(
      {int detailId, String status}) async {
    if (detailFlowInstanceMap[detailId] == null) {
      detailFlowInstanceMap[detailId] = [];
    }

    if (preUrl == null && nextUrl == null) {
      preUrl =
          ImmpApi.getApiPath(ImmpApi.flowInstancePath); //ImmpApi.productPath;
      Map<String, dynamic> map = {};
      if (status != null) {
        if (status.compareTo("进行中") == 0) {
          map['status'] = 1;
        } else if (status.compareTo("已结束") == 0) {
          map['status'] = 2;
        } else if (status.compareTo("未开始") == 0) {
          map['status'] = 0;
        }
      }

      if (detailId != null) {
        map['product_detail'] = detailId;
      }

      nextUrl = await getFlowInstanceList(
          url: preUrl, list: detailFlowInstanceMap[detailId], queryParams: map);
    } else {
      if (nextUrl != null) {
        if ((nextUrl = await getFlowInstanceList(
                url: nextUrl, list: detailFlowInstanceMap[detailId])) !=
            null) {
          preUrl = nextUrl;
        } else {
          hasReachedMax = true;
        }
      }
    }
    return detailFlowInstanceMap[detailId];
  }

//  Future<List<Product>> fetchProductList(int id) async {
//    if (detailProductMap[id] == null) {
//      detailProductMap[id] = [];
//    }
//
//    if (preUrl == null && nextUrl == null) {
//      preUrl = ImmpApi.getApiPath(ImmpApi.productPath); //ImmpApi.productPath;
//      nextUrl = preUrl;
//    }
//
//    if (nextUrl != null) {
//      if ((nextUrl = await getProductList(nextUrl, id, detailProductMap[id])) !=
//          null) {
//        preUrl = nextUrl;
//      } else {
//        hasReachedMax = true;
//      }
//    }
//    return detailProductMap[id];
//  }

  Future<List<FlowHistory>> fetchFlowHistoryList(int id) async {
    List<FlowHistory> _list = [];
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.flowHistoryPath + "$id/history/"),
          queryParameters: {"project_detail": id});
      for (var result in response.data) {
        _list.add(FlowHistory.fromJson(result));
      }
      return _list;
    } catch (e) {
      print(e);
    }
    return _list;
  }
}
