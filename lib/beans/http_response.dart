import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
part 'http_response.g.dart';

/*
0：成功

100：请求错误

101：缺少appKey

102：缺少签名

103：缺少参数

200：服务器出错

201：服务不可用

202：服务器正在重启
* */

@JsonSerializable(nullable: false)
class HttpResponse{
  String status;
  int code;
  String message;
  dynamic data;

  HttpResponse();

  factory HttpResponse.error(){
    return HttpResponse()
        .. status="error"
        .. code = 100
        .. message = "请求失败";
  }

  factory HttpResponse.success(){
    return HttpResponse()
      .. status="success"
      .. code = 0
      .. message = "请求成功";
  }

  factory HttpResponse.fromJson(Map<String, dynamic> json) => _$HttpResponseFromJson(json);
  Map<String, dynamic> toJson() => _$HttpResponseToJson(this);

  @override
  String toString() {
    return "HttpResponse {status:$status, code:$code, message:$message, data:$data}";
  }
}
