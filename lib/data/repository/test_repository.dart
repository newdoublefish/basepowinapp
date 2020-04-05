import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/test.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:xml/xml.dart' as xml;

class TestRepository{
  Future<Test> getTest({int id}) async{
    try {
      Response response;
      response = await HttpHelper().getDio().get(
        ImmpApi.getApiPath(ImmpApi.testPath+"$id/"),);
      print(response);
      Test test = Test.fromJson(response.data);
      return test;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<TestItem>> getTestProjectFile({String url}) async{
    try {
      List<TestItem> _list=[];
      Response response;
      response = await HttpHelper().getDio().get(url);
      var document = xml.parse(response.data.toString());
      var results = document.findAllElements('Result');
      results.forEach((element){
        Map<String, dynamic> map = {};
        element.attributes.forEach((attribute){
          if(attribute.name.toString().compareTo("id")==0 || attribute.name.toString().compareTo("total")==0 || attribute.name.toString().compareTo("error")==0){
            map[attribute.name.toString()] = int.parse(attribute.value.toString());
          }else{
            map[attribute.name.toString()] = attribute.value.toString();
          }
        });
        if(!map.containsKey("name")){
            map['name'] = "test ${map['id']}";
        }
        _list.add(TestItem.fromJson(map));
      });
      return _list;
    } catch (e) {
      print(e);
    }
    return [];
  }
}