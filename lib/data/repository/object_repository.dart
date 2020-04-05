import 'dart:async';
import 'package:meta/meta.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/req_response.dart';
import 'pagenate_repository.dart';
import 'package:manufacture/beans/base_bean.dart';

typedef ObjectFromJsonFunc<T> = T Function(dynamic value);
typedef ObjectToJsonFunc<T> = Map<String, dynamic> Function(T object);

class ObjectRepository<T extends BaseBean> {
  List<T> list = [];
  int _total;
  PageNateRepository _repository = PageNateRepository();
  final String url;
  final ObjectFromJsonFunc<T> objectFromJsonFunc;
  final ObjectToJsonFunc<T> objectToJsonFunc;
  int get total => _total;
  int get current => list.length;

  ObjectRepository(
      {@required this.url,
      @required this.objectFromJsonFunc,
      @required this.objectToJsonFunc});

  bool isMax() {
    return _repository.hasReachedMax;
  }

  clear() {
    list.clear();
    _repository.reset();
  }

  Future<ReqResponse<List<T>>> getList(
      {Map<String, dynamic> queryParams = const {}}) async {
      if (_repository.hasReachedMax == false) {
        ReqResponse response = await _repository.request(
            url: url,
            queryParams: queryParams);
        if (response.isSuccess) {
          _total =  response.t['count'];
          for (var result in response.t['results']) {
            list.add(objectFromJsonFunc(result));
          }
        }
        return ReqResponse(isSuccess: response.isSuccess, t:list);
      }
      return ReqResponse(isSuccess: true, t: list);

  }

  Future<bool> create({T obj}) async{
    ReqResponse response = await HttpHelper().create(url, data: objectToJsonFunc(obj));
    return response.isSuccess;
  }

  Future<bool> put({T obj}) async{
    ReqResponse response = await HttpHelper().put(url+"${obj.id}/",data: objectToJsonFunc(obj));
    return response.isSuccess;
  }

  Future<T> get(int id) async{
    ReqResponse response = await HttpHelper().get(url:url+"$id/");
    if(response.isSuccess){
      return objectFromJsonFunc(response.t);
    }else{
      return null;
    }
  }

  Future<bool> delete({T obj}) async{
    ReqResponse req = await HttpHelper().delete(url, obj.id);
    return req.isSuccess;
  }
}
