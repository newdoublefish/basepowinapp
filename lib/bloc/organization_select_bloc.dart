import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/organization_repository.dart';

class OrganizationSelectState{}

class OrganizationInitState extends OrganizationSelectState{}

class OrganizationLoadState extends OrganizationSelectState{
  final List<Organization> organizations;
  final Organization current;
  OrganizationLoadState({this.organizations,this.current});
}

class OrganizationSelected extends OrganizationSelectState{
  final Organization current;
  OrganizationSelected({this.current});
}

class OrganizationSelectEvent{}

class OrganizationLoadEvent extends OrganizationSelectEvent{}

class OrganizationDoSelectEvent extends OrganizationSelectEvent{
  final int id;
  OrganizationDoSelectEvent({this.id});
}

class OrganizationSelectBloc extends Bloc<OrganizationSelectEvent, OrganizationSelectState>{
  final OrganizationRepository repository;
  OrganizationSelectBloc({@required this.repository});

  @override
  OrganizationSelectState get initialState => OrganizationInitState();
  @override

  Stream<OrganizationSelectState> mapEventToState(OrganizationSelectEvent event) async*{
    if(event is OrganizationLoadEvent){
      if(repository.organizations.length==0){
        ReqResponse<List<Organization>> req = await repository.getOrganizations();
      }
      yield OrganizationLoadState(organizations: repository.organizations, current: repository.organizations[0]);
    }else if(event is OrganizationDoSelectEvent){
      if(repository.organizations.length==0){
        ReqResponse<List<Organization>> req = await repository.getOrganizations();
      }
      for(var Organization in repository.organizations){
        if(Organization.id == event.id){
          yield OrganizationLoadState(organizations: repository.organizations, current: Organization);
          return;
        }
      }
      yield OrganizationLoadState(organizations: repository.organizations, current: repository.organizations[0]);
    }
  }
}