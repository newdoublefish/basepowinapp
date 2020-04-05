import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/apis.dart';
import 'object_repository.dart';

class BrandObjectRepository extends ObjectRepository<Brand> {
  BrandObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory BrandObjectRepository.init() {
    return BrandObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.brandPath),
      objectFromJsonFunc: (value) {
        return Brand.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}