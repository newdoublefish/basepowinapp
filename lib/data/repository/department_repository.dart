import 'package:flutter/material.dart';
import 'package:manufacture/beans/department.dart';

import '../apis.dart';
import 'object_repository.dart';

class DepartmentRepository extends ObjectRepository<Department> {
  static DepartmentRepository _deptObjectRepository;

  DepartmentRepository(
      {@required String url,
      @required ObjectFromJsonFunc objectFromJsonFunc,
      @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory DepartmentRepository.init() {
    if (_deptObjectRepository == null) {
      _deptObjectRepository = DepartmentRepository(
        url: ImmpApi.getApiPath(ImmpApi.departmentPath),
        objectFromJsonFunc: (value) {
          return Department.fromJson(value);
        },
        objectToJsonFunc: (value) {
          return value.toJson();
        },
      );
    }
    return _deptObjectRepository;
  }
}
