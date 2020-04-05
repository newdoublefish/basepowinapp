import 'package:flutter/cupertino.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/beans/organization.dart';
import 'pagenate_repository.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/data/apis.dart';
import 'object_repository.dart';
import 'dart:async';

class OrganizationObjectRepository extends ObjectRepository<Organization> {
  static OrganizationObjectRepository _organizationRepository;
  OrganizationObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
            url: url,
            objectToJsonFunc: objectToJsonFunc,
            objectFromJsonFunc: objectFromJsonFunc);

  factory OrganizationObjectRepository.init() {
    if(_organizationRepository==null){
      _organizationRepository = OrganizationObjectRepository(
        url: ImmpApi.getApiPath(ImmpApi.organizationPath),
        objectFromJsonFunc: (value) {
          return Organization.fromJson(value);
        },
        objectToJsonFunc: (value) {
          return value.toJson();
        },
      );
    }
    return _organizationRepository;
//    return OrganizationObjectRepository(
//      url: ImmpApi.getApiPath(ImmpApi.organizationPath),
//      objectFromJsonFunc: (value) {
//        return Organization.fromJson(value);
//      },
//      objectToJsonFunc: (value) {
//        return value.toJson();
//      },
//    );
  }
}

class OrganizationRepository {
  List<Organization> organizations = [];
  PageNateRepository _repository = PageNateRepository();

  bool isMax() {
    return _repository.hasReachedMax;
  }

  clear() {
    organizations.clear();
    _repository.reset();
  }

  Future<ReqResponse<List<Organization>>> getOrganizations(
      {Map<String, dynamic> queryParams = const {}}) async {
    try {
      if (_repository.hasReachedMax == false) {
        Response response;
//        response= await _repository.request(
//            url: ImmpApi.getApiPath(ImmpApi.organizationPath),
//            queryParams: queryParams);
        if (response != null) {
          for (var result in response.data['results']) {
            organizations.add(Organization.fromJson(result));
          }
        }
      }
      return ReqResponse(isSuccess: true, t: organizations);
    } catch (e) {
      print(e);
    }
    return ReqResponse(isSuccess: false);
  }

  Future<bool> create({Organization organization}) async {
    try {
      Response response = await HttpHelper().getDio().post(
          ImmpApi.getApiPath(ImmpApi.organizationPath),
          data: organization.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> put({Organization organization}) async {
    try {
      Response response = await HttpHelper().getDio().put(
          ImmpApi.getApiPath(ImmpApi.organizationPath + "${organization.id}/"),
          data: organization.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> delete({Organization organization}) async {
    try {
      Response response = await HttpHelper().getDio().delete(
            ImmpApi.getApiPath(
                ImmpApi.organizationPath + "${organization.id}/"),
          );
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
