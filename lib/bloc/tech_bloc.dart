import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/technology.dart';
import 'package:manufacture/data/repository/tech_repository.dart';

abstract class TechState extends Equatable{
  TechState([List props = const[]]):super(props);
}

class TechInitState extends TechState{}

class TechCheckedState extends TechState{
  final TechnologyModal modal;
  final String name;
  final bool checked;
  TechCheckedState({this.modal,this.name,this.checked});
}

class TechModalLoaded extends TechState{
  final TechnologyModal modal;
  TechModalLoaded({@required this.modal}):super([modal]);
}

class TechLoading extends TechState{
  final TechnologyModal modal;
  TechLoading({this.modal});
}

class TechCommitSuccess extends TechModalLoaded{
  TechCommitSuccess({TechnologyModal modal}):super(modal:modal);
}

class TechCommitError extends TechModalLoaded{}

abstract class TechEvent extends Equatable{
  TechEvent([List props = const[]]):super(props);
}

class CommitTechEvent extends TechEvent{
  final FlowInstance instance;
  final Node node;
  final List<TechDetail> details;
  final int modalId;
  CommitTechEvent({this.instance,this.node,this.details,this.modalId});
}

class GetTechModalEvent extends TechEvent{
  final int modalId;
  GetTechModalEvent({this.modalId});
}

class RefreshEvent extends TechEvent{
  final String name;
  final bool checked;
  RefreshEvent({this.name,this.checked});
}

class TechBloc extends Bloc<TechEvent, TechState>{
  final TechRepository techRepository;
  //TechnologyModal modal;
  Map<String, bool> values = {};

  TechBloc({this.techRepository});
  @override
  // TODO: implement initialState
  TechState get initialState => TechInitState();

  @override
  Stream<TechState> mapEventToState(TechEvent event) async*{
    // TODO: implement mapEventToState
    if(event is CommitTechEvent) {
      //yield TechLoading(modal: (currentState as TechModalLoaded).modal);
      Tech tech=new Tech();
      tech.detail = event.details;
      tech.modal = event.node.type_id;
      tech.flow_text = event.instance.code;
      tech.node_text = event.node.code;
      tech.finished = true;
      if(await techRepository.create(tech:tech)!=true){
        yield TechCommitError();
        return;
      }
      await techRepository.commit(instance: event.instance,node: event.node);
      yield TechCommitSuccess(modal: (state as TechModalLoaded).modal);
    }else if(event is GetTechModalEvent){
      TechnologyModal modal = await techRepository.getModal(id:event.modalId);
      yield TechModalLoaded(modal: modal);
    }else if(event is RefreshEvent) {
//      yield TechInitState();
//      values[event.name] = event.checked;
//      yield TechModalLoaded(modal: modal, values: values);
      //yield TechCheckedState(modal: modal, name: event.name, checked: event.checked);
    }
  }
}