import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/apis.dart';
import 'object_repository.dart';

class CategoryObjectRepository extends ObjectRepository<Category> {
  CategoryObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory CategoryObjectRepository.init() {
    return CategoryObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.categoryPath),
      objectFromJsonFunc: (value) {
        return Category.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}