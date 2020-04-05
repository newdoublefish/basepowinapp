import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/beans/project.dart';

//abstract class ShipDetailState extends Equatable{
//  ShipDetailState([List props = const[]]):super(props);
//}
//
//class LoadingState extends ShipDetailState{}

class LoadedState{
  final List<ShipInfo> infoList;
  LoadedState({@required this.infoList});
}

//class JustLoadedState extends LoadedState
//{
//  JustLoadedState({@required List<ShipInfo> infoList}):super(infoList:infoList);
//}

class LoadedSuccessState extends LoadedState
{
  final String msg;
  LoadedSuccessState({@required List<ShipInfo> infoList, this.msg}):super(infoList:infoList);
}

class LoadedFailState extends LoadedState
{
  final String msg;
  LoadedFailState({@required List<ShipInfo> infoList, this.msg}):super(infoList:infoList);
}

abstract class ShipDetailEvent extends Equatable{
  ShipDetailEvent([List props = const[]]):super(props);
}

class LoadEvent extends ShipDetailEvent{
  final int detailId;
  LoadEvent({@required this.detailId});
}

class AddEvent extends ShipDetailEvent{
  final String productCode;
  final int shipDetail;
  AddEvent({this.productCode, this.shipDetail});
}

class DeleteEvent extends ShipDetailEvent{
  final List<ShipInfo> shipInfoList;
  final int shipDetail;
  DeleteEvent({@required this.shipInfoList, @required this.shipDetail});
}

class ShipDetailBlock extends Bloc<ShipDetailEvent, LoadedState> {
  final ShipRepository shipRepository;
  final ProjectRepository projectRepository;
  ShipDetailBlock({@required this.shipRepository, @required this.projectRepository}):assert(shipRepository!=null);

  @override
  // TODO: implement initialState
  LoadedState get initialState => LoadedState(infoList: []);

  @override
  Stream<LoadedState> mapEventToState(ShipDetailEvent event) async*{
    // TODO: implement mapEventToState
    if(event is LoadEvent){
      List<ShipInfo> _shipInfo = await shipRepository.listShipInfoOfShipDetail(detailId: event.detailId);
      yield LoadedState(infoList: _shipInfo);
    }else if(event is AddEvent){
      Product product = await projectRepository.fetchProductByCode(code: event.productCode);
      if(product==null) {
        // TODO:添加失败
        yield LoadedFailState(infoList: state.infoList, msg: "添加失败");
      }
      if(await shipRepository.create(product: product.id,detail: event.shipDetail)){
        yield LoadedSuccessState(infoList: await shipRepository.listShipInfoOfShipDetail(detailId: event.shipDetail), msg: "添加成功");
      }else{
        yield LoadedFailState(infoList: state.infoList, msg: "添加失败");
      }
    }else if(event is DeleteEvent){
      for(var shipInfo in event.shipInfoList){
        if(await shipRepository.delete(info: shipInfo)){

        }else{
          yield LoadedFailState(infoList: await shipRepository.listShipInfoOfShipDetail(detailId: event.shipDetail), msg: "删除${shipInfo.product}失败");
          return;
        }
      }
      yield LoadedSuccessState(infoList: await shipRepository.listShipInfoOfShipDetail(detailId: event.shipDetail), msg: "删除成功");
    }
  }
}




