import 'package:flutter/material.dart';
import 'package:manufacture/beans/mop.dart';
import '../apis.dart';
import 'object_repository.dart';

class MopRepository extends ObjectRepository<Mop> {
  static MopRepository _objectRepository;

  MopRepository(
      {@required String url,
      @required ObjectFromJsonFunc objectFromJsonFunc,
      @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory MopRepository.init() {
    if (_objectRepository == null) {
      _objectRepository = MopRepository(
        url: ImmpApi.getApiPath(ImmpApi.mopPath),
        objectFromJsonFunc: (value) {
          return Mop.fromJson(value);
        },
        objectToJsonFunc: (value) {
          return value.toJson();
        },
      );
    }
    return _objectRepository;
  }
}
