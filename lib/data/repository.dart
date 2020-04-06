import 'http.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/beans/user.dart';
import 'package:manufacture/data/apis.dart';

Future<User> getUser(String username) async {
  User user;
  try {
    Response response;
    response = await HttpHelper().getDio().get(
        ImmpApi.getApiPath(ImmpApi.userInfoPath),
        queryParameters: {"userName": username});
    print(response);
    if (response.data['count'] >= 1) {
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
    HttpHelper().getDio().options.headers['Authorization'] = "Token " + token;
    user = await getUser(username);
  } catch (e) {
    print(e);
  }
  return user;
}
