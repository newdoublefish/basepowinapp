import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/user.dart';

abstract class UserManagerState extends Equatable{
  UserManagerState([List props = const[]]):super(props);
}

class InitState extends UserManagerState{}

class LoadingState extends UserManagerState{}

class LoadedState extends UserManagerState{
  final List<User> userList;
  LoadedState({this.userList});
}



abstract class UserManagerEvent extends Equatable{
  UserManagerEvent([List props = const[]]):super(props);
}

class FetchUserListEvent extends UserManagerEvent{}

class UserManagerBloc extends Bloc<UserManagerEvent, UserManagerState>{
  final UserRepository userRepository;
  UserManagerBloc({@required this.userRepository});

  @override
  // TODO: implement initialState
  UserManagerState get initialState => InitState();

  @override
  Stream<UserManagerState> mapEventToState(UserManagerEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchUserListEvent){
      List<User> userList = await userRepository.fetchUserList();
      yield LoadedState(userList: userList);
    }
  }

}