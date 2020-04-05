import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/apis.dart';
import 'object_repository.dart';

class UnitObjectRepository extends ObjectRepository<Unit> {
  UnitObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory UnitObjectRepository.init() {
    return UnitObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.unitPath),
      objectFromJsonFunc: (value) {
        return Unit.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}