import 'base_repository.dart';
import 'dart:async';

class TempRepository<T> extends BaseRepository<T>{
  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  Future<bool> create({T obj}) async{
    // TODO: implement create
    return null;
  }

  @override
  Future<bool> delete({T obj}) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<bool> getList({Map<String, dynamic> queryParams = const {}}) {
    // TODO: implement getList
    return null;
  }

  @override
  int getTotal() {
    // TODO: implement getTotal
    return null;
  }

  @override
  bool isMax() {
    // TODO: implement isMax
    return null;
  }

  @override
  List<T> list() {
    // TODO: implement list
    return null;
  }

  @override
  Future<bool> put({T obj}) {
    // TODO: implement put
    return null;
  }

}