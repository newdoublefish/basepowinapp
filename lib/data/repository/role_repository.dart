import 'package:flutter/material.dart';
import 'package:manufacture/beans/department.dart';
import 'package:manufacture/beans/role.dart';

import '../apis.dart';
import 'object_repository.dart';

class RoleRepository extends ObjectRepository<Role> {
  static RoleRepository _deptObjectRepository;

  RoleRepository(
      {@required String url,
      @required ObjectFromJsonFunc objectFromJsonFunc,
      @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory RoleRepository.init() {
    if (_deptObjectRepository == null) {
      _deptObjectRepository = RoleRepository(
        url: ImmpApi.getApiPath(ImmpApi.rolePath),
        objectFromJsonFunc: (value) {
          return Role.fromJson(value);
        },
        objectToJsonFunc: (value) {
          return value.toJson();
        },
      );
    }
    return _deptObjectRepository;
  }
}
