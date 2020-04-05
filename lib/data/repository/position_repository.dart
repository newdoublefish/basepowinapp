import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/apis.dart';
import 'object_repository.dart';

class PositionObjectRepository extends ObjectRepository<Position> {
  PositionObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory PositionObjectRepository.init() {
    return PositionObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.positionPath),
      objectFromJsonFunc: (value) {
        return Position.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}