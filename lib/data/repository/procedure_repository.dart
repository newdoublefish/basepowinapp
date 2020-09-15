import 'package:flutter/material.dart';
import 'package:manufacture/beans/procedure.dart';
import 'package:manufacture/beans/req_response.dart';
import '../apis.dart';
import '../http.dart';
import 'object_repository.dart';

class ProcedureRepository extends ObjectRepository<Procedure> {
  static ProcedureRepository _objectRepository;

  ProcedureRepository(
      {@required String url,
        @required ObjectFromJsonFunc objectFromJsonFunc,
        @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory ProcedureRepository.init() {
    if (_objectRepository == null) {
      _objectRepository = ProcedureRepository(
        url: ImmpApi.getApiPath(ImmpApi.procedurePath),
        objectFromJsonFunc: (value) {
          return Procedure.fromJson(value);
        },
        objectToJsonFunc: (value) {
          return value.toJson();
        },
      );
    }
    return _objectRepository;
  }

  Future<bool> receive({Procedure procedure, int quantity}) async{
    ReqResponse response = await HttpHelper().put(url+"${procedure.id}/receive/", data: {
      "quantity": quantity
    });
    return response.isSuccess;
  }
}
