import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/manager.dart';
import 'package:manufacture/data/apis.dart';
import 'object_repository.dart';

class ManagerObjectRepository extends ObjectRepository<Manager> {
  ManagerObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory ManagerObjectRepository.init() {
    return ManagerObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.managerPath),
      objectFromJsonFunc: (value) {
        return Manager.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}