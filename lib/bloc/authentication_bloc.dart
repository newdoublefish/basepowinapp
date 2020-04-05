import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manufacture/data/repository.dart';
import 'package:manufacture/beans/global_info.dart';
import 'package:manufacture/beans/user.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info/package_info.dart';
import 'package:manufacture/data/repository/version_repository.dart';
import 'package:manufacture/beans/version.dart';
import 'package:manufacture/permission/permission.dart';

abstract class AuthenticationState extends Equatable{}

class AuthenticationUninitialized extends AuthenticationState{
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationAuthenticated';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';
}

class UpdateState extends AuthenticationState {
  final Version currentVersion;
  final Version latestVersion;
  UpdateState({@required this.currentVersion, @required this.latestVersion});
  @override
  String toString() => 'UpdateSate';
}


abstract class AuthenticationEvent extends Equatable{
  AuthenticationEvent([List props = const[]]):super(props);
}

class AppStarted extends AuthenticationEvent{
  final platform;
  AppStarted(this.platform);
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent{
//  final String username;
//  final String password;
//  LoggedIn({@required this.username,@required this.password}):super([username,password]);
//  @override
//  String toString() => 'LoggedIn { username: $username, password: $password}';
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent{
  @override
  String toString() => 'LoggedOut';
}

class AuthenticationUpdateEvent extends AuthenticationEvent {
  @override
  String toString() => 'UpdateEvent';
}


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{

  final UserRepository userRepository;
  final VersionRepository versionRepository;

  AuthenticationBloc({@required this.userRepository, @required this.versionRepository}): assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async*{
    if(event is AppStarted)
    {

        yield AuthenticationUninitialized();
        await Future.delayed(const Duration(milliseconds: 2000));
        await PermissionRequest.checkRequest();
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;
        //print('{$appName, $packageName, $version, $buildNumber}');
        Version current = await versionRepository.current(versionString: "$version+$buildNumber",platform: event.platform);
        Version latest = await versionRepository.latest(event.platform);

        if(current==null || current.is_valid==false){
          yield UpdateState(currentVersion: current, latestVersion: latest);
        }else{
          bool isLogin = await userRepository.load();
          if(isLogin)
            yield AuthenticationAuthenticated();
          else
            yield AuthenticationUnauthenticated();
        }
    }

    if(event is LoggedIn)
    {
        yield AuthenticationAuthenticated();
    }

    if(event is LoggedOut)
    {
         await userRepository.clearUser();
         yield AuthenticationUnauthenticated();
    }

    if(event is AuthenticationUpdateEvent){
      bool isLogin = await userRepository.load();
      if(isLogin)
        yield AuthenticationAuthenticated();
      else
        yield AuthenticationUnauthenticated();
    }
  }
}


