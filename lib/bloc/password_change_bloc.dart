import 'package:manufacture/beans/user_bean.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/req_response.dart';

class PasswordChangeState{}

class InitState extends PasswordChangeState{}

class CommitingState extends PasswordChangeState{}

class CommitedState extends PasswordChangeState{
  final bool isSuccess;
  final String message;
  CommitedState({this.isSuccess, this.message});
}

class PasswordChangeEvent{}

class CommitEvent extends PasswordChangeEvent{
  final UserBean userBean;
  final String oldPassword;
  final String newPassword;
  CommitEvent({this.userBean,this.oldPassword, this.newPassword});
}

class PasswordChangeBloc extends Bloc<PasswordChangeEvent, PasswordChangeState>{
  final UserObjectRepository userObjectRepository;
  PasswordChangeBloc({this.userObjectRepository});
  @override
  // TODO: implement initialState
  PasswordChangeState get initialState => InitState();

  @override
  Stream<PasswordChangeState> mapEventToState(PasswordChangeEvent event) async*{
    if(event is CommitEvent){
      yield CommitingState();
      bool flag = await userObjectRepository.resetPassword(userBean: event.userBean, oldPassword: event.oldPassword, newPassword: event.newPassword);
      yield CommitedState(isSuccess: flag);
    }
  }
}