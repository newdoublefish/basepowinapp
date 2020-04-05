import 'package:manufacture/beans/project.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/http_response.dart';
import 'pagenate_repository.dart';
import 'package:manufacture/beans/req_response.dart';
import 'object_repository.dart';

class FlowInstanceObjectRepository extends ObjectRepository<FlowInstance> {
  FlowInstanceObjectRepository(
      {@required String url,
      @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory FlowInstanceObjectRepository.init() {
    return FlowInstanceObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.flowInstancePath),
      objectFromJsonFunc: (value) {
        return FlowInstance.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }

  Future<ReqResponse> join(
      {String flowCode, String nodeCode, String workCode}) async {
      ReqResponse response;
      response = await HttpHelper().post(url+"join/", data: {
        "flow_code": flowCode,
        "node_code": nodeCode,
        "work_code": workCode
      });
      return response;
  }

  Future<ReqResponse> resetNodes({FlowInstance flow, Node node}) async {
      ReqResponse response = await HttpHelper().post(
          url+ "${flow.id}/reset/",
          data: {"node_id": node.id});
      return response;
  }

//  Future<bool> resetNodes({FlowInstance flow, Node node}) async {
//    try {
//      Response response;
//      response = await HttpHelper().getDio().post(
//          url+ "${flow.id}/reset/",
//          data: {"node_id": node.id});
////      print(response);
//      return "success".compareTo(response.data['status']) == 0 ? true : false;
//    } catch (e) {
//      print(e);
//    }
//    return false;
//  }

  Future<ReqResponse> resetSingleNode({FlowInstance flow, Node node}) async {
      ReqResponse response = await HttpHelper().post(
          url+ "${flow.id}/reset_node/",
          data: {"node_id": node.id});
      return response;
  }

//  Future<bool> resetSingleNode({FlowInstance flow, Node node}) async {
//    try {
//      ReqResponse response = await HttpHelper().post(
//          url+ "${flow.id}/reset_node/",
//          data: {"node_id": node.id});
//      return response.isSuccess;
//    } catch (e) {
//      print(e);
//    }
//    return false;
//  }

  Future<bool> skip({FlowInstance instance, Node node}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          url + "${instance.id}/skip_node/",
          data: {"node": node.id});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> verify({FlowInstance instance, Node node}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          url+"${instance.id}/verify/",
          data: {"node": node.id});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

//  Future<bool> bind({String flow, String product}) async {
//    try {
//      Response response;
//      response = await HttpHelper().getDio().post(
//          url+"bind/",
//          data: {"flow": flow, "product": product});
//      print(response);
//      return "success".compareTo(response.data['status']) == 0 ? true : false;
//    } catch (e) {
//      print(e);
//    }
//    return false;
//  }

  Future<ReqResponse> bind({String flow, String product}) async {
      ReqResponse response;
      response = await HttpHelper().post(
          url+"bind/",
          data: {"flow": flow, "product": product});
      return response;
  }

  Future<ReqResponse> unbind({FlowInstance instance}) async {
      ReqResponse response = await HttpHelper().get(
        url:url + '${instance.id}/unbind/',
      );
      return response;
  }

//  Future<bool> unbind({FlowInstance instance}) async {
//    try {
//      Response response;
//      response = await HttpHelper().getDio().get(
//        url + '${instance.id}/unbind/',
//      );
//      print(response);
//      return "success".compareTo(response.data['status']) == 0 ? true : false;
//    } catch (e) {
//      print(e);
//    }
//    return false;
//  }


}

class FlowRepository {
  List<FlowInstance> flowInstances = [];
  PageNateRepository _repository = PageNateRepository();

  bool isMax() {
    return _repository.hasReachedMax;
  }

  clear() {
    flowInstances.clear();
    _repository.reset();
  }

  Future<ReqResponse<List<FlowInstance>>> getList(
      {Map<String, dynamic> queryParams = const {}}) async {
    try {
      if (_repository.hasReachedMax == false) {
        Response response;
//        response= await _repository.request(
//            url: ImmpApi.getApiPath(ImmpApi.flowInstancePath),
//            queryParams: queryParams);
        if (response != null) {
          for (var result in response.data['results']) {
            flowInstances.add(FlowInstance.fromJson(result));
          }
        }
      }
      return ReqResponse(isSuccess: true, t: flowInstances);
    } catch (e) {
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Future<bool> create({FlowInstance instance}) async {
    try {
      Response response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowInstancePath),
          data: instance.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> put({FlowInstance instance}) async {
    try {
      Response response = await HttpHelper().getDio().put(
          ImmpApi.getApiPath(ImmpApi.flowInstancePath + "${instance.id}/"),
          data: instance.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> delete({FlowInstance instance}) async {
    try {
      Response response = await HttpHelper().getDio().delete(
            ImmpApi.getApiPath(ImmpApi.flowInstancePath + "${instance.id}/"),
          );
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<FlowInstance> fetchFlowInstance(String code) async {
    FlowInstance instance;
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.flowInstancePath),
          queryParameters: {"code": code});
      if (response.data['count'] >= 1) {
        instance = FlowInstance.fromJson(response.data['results'][0]);
      }
      return instance;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<FlowInstance> fetchFlowInstanceByProductCode(String code) async {
    FlowInstance instance;
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.flowInstancePath),
          queryParameters: {"product__code": code});
      if (response.data['count'] >= 1) {
        instance = FlowInstance.fromJson(response.data['results'][0]);
      }
      return instance;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Node> getNode(int nodeId) async {
    Node node;
    try {
      Response response;
      response = await HttpHelper()
          .getDio()
          .get(ImmpApi.getApiPath(ImmpApi.flowNodePath + "$nodeId/"));
      print(response.data);
      node = Node.fromJson(response.data);
      return node;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Node>> getModalNodes(int modalId) async {
    List<Node> nodes = [];
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.flowNodePath),
          queryParameters: {"modal": modalId});
      print(response.data);
      for (var result in response.data['results']) {
        nodes.add(Node.fromJson(result));
      }
      return nodes;
    } catch (e) {
      print(e);
    }
    return nodes;
  }

  Future<Procedure> fetchFlowModal(int id) async {
    Procedure procedure;
    try {
      Response response;
      response = await HttpHelper()
          .getDio()
          .get(ImmpApi.getApiPath(ImmpApi.flowModalPath + "$id/"));
      print(response.data);
      procedure = Procedure.fromJson(response.data);
      return procedure;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<FlowHistory>> fetchFlowHistoryList(int id) async {
    List<FlowHistory> _list = [];
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.flowHistoryPath + "$id/history/"),
          queryParameters: {"project_detail": id});
      print(response.data);
      for (var result in response.data) {
        _list.add(FlowHistory.fromJson(result));
      }
      return _list;
    } catch (e) {
      print(e);
    }
    return _list;
  }

  Future<bool> commit({String flow, String node}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowCommit),
          data: {"flow_code": flow, "node_code": node});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> bind({String flow, String product}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowBind),
          data: {"flow": flow, "product": product});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> skip({String flow, String node}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowSkip),
          data: {"flow_code": flow, "node_code": node});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> unbind({FlowInstance instance}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().get(
            ImmpApi.getApiPath(
                ImmpApi.flowInstancePath + '${instance.id}/unbind/'),
          );
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> confirm({String flowCode, String nodeCode}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowConfirm),
          data: {"flow_code": flowCode, "node_code": nodeCode});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<HttpResponse> join(
      {String flowCode, String nodeCode, String workCode}) async {
    try {
      Response response;
      response = await HttpHelper()
          .getDio()
          .post(ImmpApi.getApiPath(ImmpApi.flowJoin), data: {
        "flow_code": flowCode,
        "node_code": nodeCode,
        "work_code": workCode
      });
      return HttpResponse.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return HttpResponse.error();
  }

  Future<bool> reset({FlowInstance flow, Node node}) async {
    try {
      Response response;
      print(flow.id);
      print(node.id);
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowInstancePath + "${flow.id}/reset/"),
          data: {"node_id": node.id});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> resetSingleNode({FlowInstance flow, Node node}) async {
    try {
      Response response;
      print(flow.id);
      print(node.id);
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(
              ImmpApi.flowInstancePath + "${flow.id}/reset_node/"),
          data: {"node_id": node.id});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
