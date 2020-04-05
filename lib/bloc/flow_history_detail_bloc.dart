import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/beans/test.dart';
import 'package:manufacture/beans/technology.dart';
import 'package:manufacture/data/repository/test_repository.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/tech_repository.dart';

abstract class HistoryState extends Equatable {
  HistoryState([List props = const []]) : super(props);
}

class InitState extends HistoryState {}

class TestReportLoaded extends HistoryState {
  final Test test;
  final List<TestItem> list;
  TestReportLoaded({@required this.test, @required this.list});
}

class TechDetailLoaded extends HistoryState {
  final Tech tech;
  TechDetailLoaded({@required this.tech});
}

class ShipLoadedState extends HistoryState{
  final ShipOrder shipOrder;
  ShipLoadedState({@required this.shipOrder});
}

abstract class HistoryEvent extends Equatable {
  HistoryEvent([List props = const []]) : super(props);
}

class FetchReportEvent extends HistoryEvent {
  final int reportType;
  final int id;
  FetchReportEvent({@required this.reportType, @required this.id});
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final TestRepository testRepository;
  final ShipRepository shipRepository;
  final TechRepository techRepository;
  HistoryBloc({@required this.testRepository, @required this.shipRepository, @required this.techRepository});

  @override
  // TODO: implement initialState
  HistoryState get initialState => InitState();

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent event) async* {
    // TODO: implement mapEventToState
    if (event is FetchReportEvent) {
      yield InitState();
      if (event.reportType == 0) {
        Test test = await testRepository.getTest(id: event.id);
        List<TestItem> itemList=[];
        if(test.project_file!=null){
          itemList = await testRepository.getTestProjectFile(url: test.project_file);
        }else if(test.detail!=null){
          for(var group in test.detail.results){
            for(var item in group.items){
              itemList.add(item);
            }
          }
        }
        yield TestReportLoaded(test:test, list: itemList);
      }else if(event.reportType==1){
        yield TechDetailLoaded(tech: await techRepository.getTechDetail(id: event.id));
      }else if(event.reportType==2){
        ShipInfo shipInfo = await shipRepository.getShipInfoProduct(id: event.id);
        if(shipInfo!=null){
          //ShipOrder shipOrder = await shipRepository.getShipById(id: shipInfo.shipInstance);
          yield ShipLoadedState(shipOrder: null);
        }
      }
    }
    //return null;
  }
}
