import 'package:flutter/material.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/beans/task.dart';

import '../apis.dart';
import '../http.dart';
import 'object_repository.dart';

class TaskRepository extends ObjectRepository<Task> {
  TaskRepository _objectRepository;
  TaskRepository(
      {@required String url,
      @required ObjectFromJsonFunc objectFromJsonFunc,
      @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory TaskRepository.init() {
      return TaskRepository(
        url: ImmpApi.getApiPath(ImmpApi.taskPath),
        objectFromJsonFunc: (value) {
          print("---1");
          return Task.fromJson(value);
        },
        objectToJsonFunc: (value) {
          print("---2");
          return value.toJson();
        },
      );
    }

  Future<ReqResponse> start(
      {Task task}) async {
    ReqResponse response;
    response = await HttpHelper().get(url:url+"${task.id}/start/", queryParams:{});
    return response;
  }

  Future<ReqResponse> finish(
      {Task task}) async {
    ReqResponse response;
    response = await HttpHelper().get(url:url+"${task.id}/finish/", queryParams:{});
    return response;
  }


}
