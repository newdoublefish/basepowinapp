import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/beans/technology.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';

import 'object_repository.dart';

class ShipInfoObjectRepository extends ObjectRepository<ShipInfo> {
  ShipInfoObjectRepository(
      {@required String url,
        @required ObjectFromJsonFunc objectFromJsonFunc,
        @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory ShipInfoObjectRepository.init() {
    return ShipInfoObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.shipInfo),
      objectFromJsonFunc: (value) {
        return ShipInfo.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}

class ShipDetailObjectRepository extends ObjectRepository<ShipDetail> {
  ShipDetailObjectRepository(
      {@required String url,
        @required ObjectFromJsonFunc objectFromJsonFunc,
        @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory ShipDetailObjectRepository.init() {
    return ShipDetailObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.shipDetail),
      objectFromJsonFunc: (value) {
        return ShipDetail.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}

class ShipObjectRepository extends ObjectRepository<ShipOrder> {
  ShipObjectRepository(
      {@required String url,
      @required ObjectFromJsonFunc objectFromJsonFunc,
      @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory ShipObjectRepository.init() {
    return ShipObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.shipOrder),
      objectFromJsonFunc: (value) {
        return ShipOrder.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}

class ShipModalObjectRepository extends ObjectRepository<ShipModal> {
  static ShipModalObjectRepository _shipModalObjectRepository;

  ShipModalObjectRepository(
      {@required String url,
      @required ObjectFromJsonFunc objectFromJsonFunc,
      @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory ShipModalObjectRepository.init() {
    if (_shipModalObjectRepository == null)
      _shipModalObjectRepository = ShipModalObjectRepository(
        url: ImmpApi.getApiPath(ImmpApi.shipModal),
        objectFromJsonFunc: (value) {
          return ShipModal.fromJson(value);
        },
        objectToJsonFunc: (value) {
          return value.toJson();
        },
      );
    return _shipModalObjectRepository;
  }
}

class ShipRepository {
  Future<ShipOrder> getShipById({int id}) async {
    try {
      Response response;
      response = await HttpHelper()
          .getDio()
          .get(ImmpApi.getApiPath(ImmpApi.shipOrder + "$id/"));
      print(response);
      return ShipOrder.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<ShipOrder> getShipOrder({String code}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.shipOrder),
          queryParameters: {"code": code});
      print(response);
      if (response.data['count'] >= 1) {
        ShipOrder order = ShipOrder.fromJson(response.data['results'][0]);
        return order;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<ShipDetail>> getShipDetailList({int orderId}) async {
    List<ShipDetail> detailList = [];
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.shipDetail),
          queryParameters: {"ship_instance": orderId});
      print(response);
      if (response.data['count'] >= 1) {
        //ShipOrder order = ShipOrder.fromJson(response.data['results'][0]);
        //return order;

        for (var result in response.data['results']) {
          detailList.add(ShipDetail.fromJson(result));
        }
      }
    } catch (e) {
      print(e);
    }
    return detailList;
  }

  Future<ShipOrder> getShipOrderByProduct({int product}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.shipOrderGetByProduct),
          data: {"product": product});
      print(response);
      ShipOrder order = ShipOrder.fromJson(response.data);
      return order;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> createShipOrder({ShipOrder order}) async {
    try {
      Response response;
      response = await HttpHelper()
          .getDio()
          .post(ImmpApi.getApiPath(ImmpApi.shipOrder), data: order.toJson());
      print(response);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<ShipModal>> listShipModal() async {
    List<ShipModal> shipOrderList = [];
    try {
      Response response;
      response = await HttpHelper().getDio().get(
            ImmpApi.getApiPath(ImmpApi.shipModal),
          );
      print(response);
      if (response.data['count'] >= 1) {
        //ShipOrder order = ShipOrder.fromJson(response.data['results'][0]);
        //return order;
        for (var result in response.data['results']) {
          shipOrderList.add(ShipModal.fromJson(result));
        }
      }
    } catch (e) {
      print(e);
    }
    return shipOrderList;
  }

  Future<List<ShipOrder>> listShipOrder() async {
    List<ShipOrder> shipOrderList = [];
    try {
      Response response;
      response = await HttpHelper().getDio().get(
            ImmpApi.getApiPath(ImmpApi.shipOrder),
          );
      print(response);
      if (response.data['count'] >= 1) {
        //ShipOrder order = ShipOrder.fromJson(response.data['results'][0]);
        //return order;
        for (var result in response.data['results']) {
          shipOrderList.add(ShipOrder.fromJson(result));
        }
      }
    } catch (e) {
      print(e);
    }
    return shipOrderList;
  }

  Future<List<ShipInfo>> listShipInfoOfShipOrder(int orderId) async {
    List<ShipInfo> _list = [];
    try {
      Response response;
      response = await HttpHelper()
          .getDio()
          .get(ImmpApi.getApiPath(ImmpApi.shipOrder) + "$orderId/products/");
      print(response);
      for (var result in response.data) {
        _list.add(ShipInfo.fromJson(result));
      }
      return _list;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<ShipInfo>> listShipInfoOfShipDetail({int detailId}) async {
    List<ShipInfo> _list = [];
    try {
      Response response;
      response = await HttpHelper()
          .getDio()
          .get(ImmpApi.getApiPath(ImmpApi.shipDetail) + "$detailId/products/");
      print(response);
      for (var result in response.data) {
        _list.add(ShipInfo.fromJson(result));
      }
      return _list;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<bool> create({
    int product,
    int detail,
  }) async {
    try {
      Response response;

      response = await HttpHelper()
          .getDio()
          .post(ImmpApi.getApiPath(ImmpApi.shipInfo), data: {
        "product": product,
        "ship_detail": detail,
      });
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> delete({ShipInfo info}) async {
    try {
      Response response;

      response = await HttpHelper().getDio().delete(
            ImmpApi.getApiPath(ImmpApi.shipInfo + "${info.id}/"),
          );
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<ShipInfo> getShipInfoProduct({
    int id,
  }) async {
    try {
      Response response;

      response = await HttpHelper().getDio().get(
            ImmpApi.getApiPath(ImmpApi.shipInfo + "$id/product/"),
          );
      print(response);
      ShipInfo shipInfo = ShipInfo.fromJson(response.data);
      print(shipInfo);
      return ShipInfo.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> commit({FlowInstance instance, Node node}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.flowCommit),
          data: {"flow_code": instance.code, "node_code": node.code});
      print(response);
      return "success".compareTo(response.data['status']) == 0 ? true : false;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
