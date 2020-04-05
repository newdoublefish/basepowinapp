import 'dart:async';

abstract class BaseRepository<T>{
  int getTotal();
  bool isMax();
  void clear();
  List<T> list();
  Future<bool> getList({Map<String, dynamic> queryParams = const {}});
  Future<bool> create({T obj});
  Future<bool> put({T obj});
  Future<bool> delete({T obj});
}