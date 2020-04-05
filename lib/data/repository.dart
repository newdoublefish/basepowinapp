import 'http.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/beans/user.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/beans/real_info.dart';

//Future<void> getUserInfo(String username) async {
//  try {
//    Response response;
//    response = await HttpHelper().getDio().get(
//        ImmpApi.getApiPath(ImmpApi.userInfoPath),
//        queryParameters: {"userName": username});
//    if (response.data['code'] == 200) {
//      print(response.data);
//      if (response.data['data']['total'] >= 1) {
//        user = User.fromJson(response.data['data']['records'][0]);
//        print(user.toString());
//      }
//    } else {}
//  } catch (e) {
//    print(e);
//  } finally {}
//}

Future<User> getUser(String username) async {
  User user;
  try {
    Response response;
    response = await HttpHelper().getDio().get(
        ImmpApi.getApiPath(ImmpApi.userInfoPath),
        queryParameters: {"userName": username});
    print(response);
    if(response.data['count'] >= 1)
    {
      user = User.fromJson(response.data['results'][0]);
      print(user);
    }
  } catch (e) {
    print(e);
  } finally {}
  return user;
}

Future<User> login(String username, String password) async {
  User user;
  try {
    Response response;
    response = await HttpHelper().getDio().post(
        ImmpApi.getApiPath(ImmpApi.loginPath),
        data: {"username": username, "password": password});
    String token = response.data['token'];
    HttpHelper().getDio().options.headers['Authorization'] = "Token "+token;
    user = await getUser(username);
  } catch (e) {
    print(e);
  }
  return user;
}

Future<List<RealInfo>> getErrors(String deviceNo,int timeline) async{
  try {
    Response response;
    response = await HttpHelper().getDio().get(ImmpApi.getApiPath(ImmpApi.errorPath), queryParameters: {'deviceNumber':deviceNo, 'lastRequestAt':timeline});
    if(response.data is List)
    {
        List temp = response.data;
        List<RealInfo> realInfoList = temp.map<RealInfo>((value){
          return RealInfo.fromJson(value);
        }).toList();
        return realInfoList;
    }

  } catch (e) {
    print(e);
  } finally {

  }
  return null;
}
