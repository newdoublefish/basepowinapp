import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/technology.dart';
import 'package:manufacture/data/repository/tech_repository.dart';

class TechOperateState{}

class InitState extends TechOperateState{}

class LoadedState extends TechOperateState{
  final TechnologyModal technologyModal;
  final Tech tech;
  LoadedState({this.technologyModal,this.tech});
}

class NodeSuchTechState extends TechOperateState{

}

class DoneState extends TechOperateState{
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess,this.message});
}

class TechOperateEvent{}

class LoadEvent extends TechOperateEvent{
  final String code;
  final int modalId;
  LoadEvent({this.code,this.modalId});
}

class CommitEvent extends TechOperateEvent{
  final Tech tech;
  final List<TechDetail> details;
  final TechnologyModal technologyModal;
  CommitEvent({this.tech,this.details,this.technologyModal});
}

class TechOperateBloc extends Bloc<TechOperateEvent, TechOperateState>{
  final TechObjectRepository techObjectRepository;
  TechOperateBloc({this.techObjectRepository});

  @override
  TechOperateState get initialState => InitState();

  @override
  Stream<TechOperateState> mapEventToState(TechOperateEvent event) async*{
    if(event is LoadEvent){
      await techObjectRepository.getList(queryParams: {"code":event.code});
      if(techObjectRepository.list.length==0){
        yield NodeSuchTechState();
      }else{
        TechnologyModal modal = await techObjectRepository.getModal(id:event.modalId);
        Tech tech = techObjectRepository.list[0];
        if(tech.detail!=null && tech.detail.length>0) {
          for (TechDetailGroup group in modal.detail) {
            for (TechDetail detail in group.items) {
              for(TechDetail _detail in tech.detail){
                if(detail.name.compareTo(_detail.name)==0){
                  detail.value = _detail.value;
                }
              }
            }
          }
        }
        yield LoadedState(technologyModal: modal,tech: techObjectRepository.list[0]);
      }
    }else if(event is CommitEvent){
      print(event.technologyModal);
      event.tech.modal = event.technologyModal.id;
      event.tech.detail = event.details;
      event.tech.finished = true;
      print(event.tech);
      if(await techObjectRepository.put(obj: event.tech)){
        yield DoneState(isSuccess: true, message: "提交成功");
      }else{
        yield DoneState(isSuccess: false, message: "提交失败");
      }
    }
  }

}