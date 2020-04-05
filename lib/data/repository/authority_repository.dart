import 'dart:async';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/authority.dart';


class AuthorityRepository{
  Authority _authority;

  Authority get authority=> _authority==null?Authority():_authority;

  Future<void> getAuthority({int userId}) async{
    try {
      Response response;
      response = await HttpHelper().getDio().get(
        ImmpApi.getApiPath(ImmpApi.authorityPath),);
      print(response);
      if(response.data['count'] >= 1)
      {
        _authority = Authority.fromJson(response.data['results'][0]);
      }
    } catch (e) {
      _authority=null;
    }
  }
}