import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/req_response.dart';

import 'object_repository.dart';

class FlowNodeObjectRepository extends ObjectRepository<Node> {
  FlowNodeObjectRepository(
      {@required String url,
        @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory FlowNodeObjectRepository.init() {
    return FlowNodeObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.flowNodePath),
      objectFromJsonFunc: (value) {
        return Node.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }

  Node _getNextNode(List<Node> nodes, Node node) {
    for (Node current in nodes) {
      if (node == null) {
        if (current.is_first == true) {
          return current;
        }
      } else {
        if (node.next != null) {
          if (node.next == current.id) {
            return current;
          }
        }
      }
    }
    return null;
  }

  List<Node> _buildOrderedNodes(List<Node> orderedNodes, List<Node> nodes) {
    Node node;
    while (true) {
      node = _getNextNode(nodes, node);
      if (node != null)
        orderedNodes.add(node);
      else
        break;
      if (node.is_end == true) {
        break;
      }
      if (orderedNodes.length == nodes.length) {
        break;
      }
    }
    return orderedNodes;
  }

  Future<ReqResponse<List<Node>>> getNodes({int modalId}) async {
    List<Node> nodes = [];
    List<Node> orderedNodes = [];
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          url,
          queryParameters: {"modal": modalId});
      print(response.data);
      if (response.data['count'] > 0) {
        for (var result in response.data['results']) {
          nodes.add(Node.fromJson(result));
        }
        //给nodes排号顺序
        _buildOrderedNodes(orderedNodes, nodes);
        nodes.clear();
        return ReqResponse(isSuccess: true, t: orderedNodes);
      }
      return ReqResponse(isSuccess: false, message: "无相关数据");
    } catch (e) {
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }
}

class FlowNodesRepository {
  List<Node> nodes = [];
  List<Node> orderedNodes = [];

  Future<bool> delete({@required Node node}) async{
    try{
      Response response = await HttpHelper().getDio().delete(ImmpApi.getApiPath(ImmpApi.flowNodePath+"${node.id}/"));
      return true;
    }catch(e){
      print(e);
    }
    return false;
  }

  Future<bool> moveUp({@required Node node}) async{
    try{
      Response response = await HttpHelper().getDio().get(ImmpApi.getApiPath(ImmpApi.flowNodePath+"${node.id}/move_up/"));
      return true;
    }catch(e){
      print(e);
    }
    return false;
  }

  Future<bool> moveDown({@required Node node}) async{
    try{
      Response response = await HttpHelper().getDio().get(ImmpApi.getApiPath(ImmpApi.flowNodePath+"${node.id}/move_down/"));
      return true;
    }catch(e){
      print(e);
    }
    return false;
  }

  Future<ReqResponse<Node>> create({@required Node node}) async{
    try{
      Response response = await HttpHelper().getDio().post(ImmpApi.getApiPath(ImmpApi.flowNodePath),data: node.toJson());
      print(response);
      return ReqResponse(isSuccess: true);
    }catch(e){
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Future<ReqResponse<Node>> update({@required Node node}) async{
    try{
      Response response = await HttpHelper().getDio().put(ImmpApi.getApiPath(ImmpApi.flowNodePath+"${node.id}/"),data: node.toJson());
      print(response);
      return ReqResponse(isSuccess: true);
    }catch(e){
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Node _getNextNode(List<Node> nodes, Node node) {
    for (Node current in nodes) {
      if (node == null) {
        if (current.is_first == true) {
          return current;
        }
      } else {
        if (node.next != null) {
          if (node.next == current.id) {
            return current;
          }
        }
      }
    }
    return null;
  }

  List<Node> _buildOrderedNodes(List<Node> orderedNodes, List<Node> nodes) {
    Node node;
    while (true) {
      node = _getNextNode(nodes, node);
      if (node != null)
        orderedNodes.add(node);
      else
        break;
      if (node.is_end == true) {
        break;
      }
      if (orderedNodes.length == nodes.length) {
        break;
      }
    }
    return orderedNodes;
  }
  
  Future<ReqResponse<List<Node>>> getNodes({int modalId}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.flowNodePath),
          queryParameters: {"modal": modalId});
      print(response.data);
      if (response.data['count'] > 0) {
        //清空数据
        nodes.clear();
        orderedNodes.clear();
        for (var result in response.data['results']) {
          nodes.add(Node.fromJson(result));
        }
        //给nodes排号顺序
        _buildOrderedNodes(orderedNodes, nodes);
        return ReqResponse(isSuccess: true, t: nodes);
      }

      return ReqResponse(isSuccess: false, message: "无相关数据");
    } catch (e) {
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }
}
