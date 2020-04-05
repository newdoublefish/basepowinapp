import 'dart:async';
import 'package:manufacture/beans/project.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/beans/record.dart';

import 'object_repository.dart';

class RecordTypeRepository extends ObjectRepository<RecordType> {
  RecordTypeRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory RecordTypeRepository.init() {
    return RecordTypeRepository(
      url: ImmpApi.getApiPath(ImmpApi.recordTypePath),
      objectFromJsonFunc: (value) {
        return RecordType.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}

class RecordRepository {
  List<RecordType> recordTypeList = [];

  Future<ReqResponse<List<RecordType>>> getRecordTypeList() async {
    print("11111111111111");
    try {
      Response response =
          await HttpHelper().getDio().get(ImmpApi.getApiPath(ImmpApi.recordTypePath));
      print(response);
      if (response.data['count'] > 0) {
        //清空数据
        recordTypeList.clear();
        for (var result in response.data['results']) {
          recordTypeList.add(RecordType.fromJson(result));
        }
        return ReqResponse(isSuccess: true, t: recordTypeList);
      }
      return ReqResponse(isSuccess: true);
    } catch (e) {
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Future<RecordType> getRecordType(int id) async {
    if (recordTypeList.length == 0) {
      await getRecordTypeList();
    }
    for (RecordType recordType in recordTypeList) {
      if (recordType.id == id) {
        return recordType;
      }
    }

    return null;
  }
}
