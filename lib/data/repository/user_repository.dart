import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:manufacture/beans/user.dart';
import 'package:manufacture/beans/authority.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'object_repository.dart';
import 'package:manufacture/beans/user_bean.dart';

class UserObjectRepository extends ObjectRepository<UserBean> {
  static UserObjectRepository _userObjectRepository;
  UserObjectRepository(
      {@required String url,
      @required ObjectFromJsonFunc objectFromJsonFunc,
      @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory UserObjectRepository.init() {
    if (_userObjectRepository == null) {
      _userObjectRepository = UserObjectRepository(
        url: ImmpApi.getApiPath(ImmpApi.userInfoPath),
        objectFromJsonFunc: (value) {
          return UserBean.fromJson(value);
        },
        objectToJsonFunc: (value) {
          return value.toJson();
        },
      );
    }
    return _userObjectRepository;
  }

  Future<bool> resetPassword(
      {UserBean userBean, String oldPassword, String newPassword}) async {
    try {
      ReqResponse response = await HttpHelper().post(
          url + "${userBean.id}/reset_password/",
          data: {"old": oldPassword, "new": newPassword});
      return response.isSuccess;
    } catch (e) {
      print(e);
    }
    return false;
  }
}

class UserRepository {
  User _user;
  Authority _authority;

  User get user => _user;
  Authority get authority => _authority;

  Future<List<User>> fetchUserList() async {
    try {
      ReqResponse response;
      response = await HttpHelper().get(
            url:ImmpApi.getApiPath(ImmpApi.userInfoPath),
          );
      print(response);
      if (response.t['count'] >= 1) {
        List<User> userList = [];
        for (var data in response.t['results']) {
          userList.add(User.fromJson(data));
        }
        return userList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    String password = prefs.getString("password");
    if (username != null && password != null) {
      User user = new User();
      user.username = username;
      user.password = password;
      return user;
    }
    return null;
  }

  Future<bool> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    String password = prefs.getString("password");
    if (username != null && password != null) {
      User user = await authenticate(
          username: username, password: password, persist: false);
      if (user != null) return true;
    }
    return false;
  }

  Future clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("token");
  }

  Future<void> getAuthority({int userId}) async {
    try {
      ReqResponse response;
      response = await HttpHelper().get(
          url: ImmpApi.getApiPath(ImmpApi.authorityPath),
          queryParams: {"user": userId});
      if (response.isSuccess) {
        if (response.t['count'] >= 1) {
          _authority = Authority.fromJson(response.t['results'][0]);
        } else {
          _authority = Authority();
        }
      }else{
        _authority = Authority();
      }
    } catch (e) {
      print(e);

    }
  }

  //TODO: 重新设计登入逻辑
  Future<User> authenticate(
      {@required String username,
      @required String password,
      @required bool persist}) async {
    try {
      ReqResponse res = await HttpHelper().post(
          ImmpApi.getApiPath(ImmpApi.loginPath),
          data: {"username": username, "password": password});
      print(res.t);
      String token = res.t['token'];
      HttpHelper().setToken(token);
      _user = User.fromJson(res.t['user']);
      print(_user);
      if (persist == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("username", username);
        prefs.setString("password", password);
        prefs.setString("token", token);
      }
//      await getAuthority(userId: _user.id);
//      print(_authority);

      return _user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<User> getUser(String username) async {
    User user;
    try {
      ReqResponse response;
      response = await HttpHelper().get(
          url:ImmpApi.getApiPath(ImmpApi.userInfoPath),
          queryParams: {"userName": username});
      print(response);
      if (response.t['count'] >= 1) {
        user = User.fromJson(response.t['results'][0]);
        print(user);
      }
    } catch (e) {
      print(e);
    } finally {}
    return user;
  }
}
