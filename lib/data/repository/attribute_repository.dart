import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/apis.dart';
import 'object_repository.dart';

class AttributeObjectRepository extends ObjectRepository<ProductAttribute> {
  AttributeObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory AttributeObjectRepository.init() {
    return AttributeObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.attributePath),
      objectFromJsonFunc: (value) {
        return ProductAttribute.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}