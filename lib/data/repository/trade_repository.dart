import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/apis.dart';
import 'object_repository.dart';

class TradeObjectRepository extends ObjectRepository<Trade> {
  TradeObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory TradeObjectRepository.init() {
    return TradeObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.tradePath),
      objectFromJsonFunc: (value) {
        return Trade.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}