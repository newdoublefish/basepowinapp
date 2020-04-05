import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/version.dart';
import 'package:flutter/material.dart';

class VersionRepository{
  Version currentVersion;
  Version latestVersion;

  int _getTerminalType(platform){
    return platform==TargetPlatform.android?1:2;
  }

  Future<Version> current({String versionString,platform}) async{
    try{
      print(versionString);
      Response response;
      response = await HttpHelper().getDio().get(ImmpApi.getApiPath(ImmpApi.versionPath),queryParameters: {"version":versionString, "terminal_type":_getTerminalType(platform)});
      print(response.data);
      if(response.data['count']>=1){
        currentVersion = Version.fromJson(response.data['results'][0]);
        return currentVersion;
      }
    }catch(e){

    }
    return null;
  }

  Future<Version> latest(platform) async{
    try{
      Response response;
      response = await HttpHelper().getDio().get(ImmpApi.getApiPath(ImmpApi.versionPath+"latest/"),queryParameters: {"terminal_type":_getTerminalType(platform)});
      print(response.data);
      if(response.data['status'].toString().compareTo("success")==0){
        latestVersion = Version.fromJson(response.data['msg']);
        return Version.fromJson(response.data['msg']);
      }
    }catch(e){

    }
    return null;
  }
}