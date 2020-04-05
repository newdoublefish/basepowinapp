import 'package:dio/dio.dart';
import 'package:manufacture/beans/req_response.dart';
import 'dart:async';

class HttpHelper{
  Dio _dio;
  static HttpHelper _singleton = HttpHelper.init();

  factory HttpHelper()
  {
    return _singleton;
  }

  HttpHelper.init(){
    _dio = new Dio();
  }

  void setToken(String token){
    _dio.options.headers['Authorization'] = "Token "+token;
  }

  Future<ReqResponse> post(String url,{data}) async{
    ReqResponse req = ReqResponse();
    try {
      Response response = await _dio.post(url, data: data);
      req.t = response.data;
      req.isSuccess = true;
      req.message = "操作成功";
    }on DioError catch(e){
      print(e.response);
      req.isSuccess = false;
      req.message = e.response.toString();
    }
    return req;
  }

  Future<ReqResponse> put(String url,{data}) async{
    ReqResponse req = ReqResponse();
    try {
      Response response = await _dio.put(url, data: data);
      req.isSuccess = true;
      req.message = "操作成功";
    }on DioError catch(e){
      print(e.response);
      req.isSuccess = false;
      req.message = e.response.toString();
    }
    return req;
  }

  Future<ReqResponse> get({String url,  Map<String, dynamic> queryParams}) async{
    ReqResponse req = ReqResponse();
    try{
      Response response =
        await _dio.get(url, queryParameters: queryParams);
      req.isSuccess = true;
      req.t = response.data;
    }on DioError catch(e){
      print(e.response);
      req.isSuccess = false;
      req.message = e.response.toString();
    }
    return req;
  }
  
  Future<ReqResponse> create<T>(String url,{data}) async{
    ReqResponse req = ReqResponse();
    try {
      Response response = await _dio.post(url, data: data);
      req.isSuccess = true;
    }on DioError catch(e){
      print(e.response.statusMessage);
      req.isSuccess = false;
    }
    return req;
  }

  Future<ReqResponse> delete(String url,int id) async{
    ReqResponse req = ReqResponse();
    try {
      Response response = await _dio.delete(url+"$id/");
      req.isSuccess = true;
    }on DioError catch(e){
      print(e.response.statusMessage);
      req.isSuccess = false;
    }
    return req;
  }

  Dio getDio(){
    return _dio;
  }
}

