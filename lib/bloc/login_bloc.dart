import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/bloc/authentication_bloc.dart';
import 'package:manufacture/beans/global_info.dart';

abstract class LoginState extends Equatable{
  LoginState([List props = const[]]):super(props);
}

class LoginInitial extends LoginState{
  @override
  String toString() => 'LoginInitial';
}

class LoginLoading extends LoginState{
  @override
  String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState{
  final String error;
  LoginFailure({@required this.error}):super([error]);
  @override
  String toString() => 'LoginFailure {error: $error}';
}

abstract class LoginEvent extends Equatable{
  LoginEvent([List props = const[]]):super(props);
}

class LoginButtonPressed extends LoginEvent{
  final String username;
  final String password;
  final bool persist;

  LoginButtonPressed({@required this.username, @required this.password, @required this.persist}):super([username,password,persist]);

  @override
  String toString() => 'LoginButtonPressed {username:$username, password:$password, persist:$persist}';
}

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  final AuthenticationBloc authenticationBloc;
  final UserRepository userRepository;
  LoginBloc({@required this.authenticationBloc, @required this.userRepository}):assert(authenticationBloc!=null),assert(userRepository!=null);
  @override
  // TODO: implement initialState
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    // TODO: implement mapEventToState
    if(event is LoginButtonPressed){
      GlobalInfo.user = await userRepository.authenticate(username: event.username, password: event.password, persist: event.persist);
      if(GlobalInfo.user==null)
      {
          yield LoginFailure(error: "登入失败");
      }else {
        authenticationBloc.add(LoggedIn());
        yield LoginInitial();
      }
    }
  }
}