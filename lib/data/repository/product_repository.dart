import 'package:manufacture/beans/project.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/http.dart';
import 'package:manufacture/beans/ship.dart';
import 'object_repository.dart';

class ProductObjectRepository extends ObjectRepository<Product> {
  ProductObjectRepository(
      {@required String url, @required ObjectFromJsonFunc objectFromJsonFunc, @required ObjectToJsonFunc objectToJsonFunc})
      : super(
      url: url,
      objectToJsonFunc: objectToJsonFunc,
      objectFromJsonFunc: objectFromJsonFunc);

  factory ProductObjectRepository.init() {
    return ProductObjectRepository(
      url: ImmpApi.getApiPath(ImmpApi.productPath),
      objectFromJsonFunc: (value) {
        return Product.fromJson(value);
      },
      objectToJsonFunc: (value) {
        return value.toJson();
      },
    );
  }
}

class ProductRepository {
  String _preUrl;
  String _nextUrl;
  List<Product> _listProduct = [];

  void resetUrls() {
    _listProduct.clear();
    _preUrl = null;
    _nextUrl = null;
  }

  Future<ShipOrder> getOrder({int productId}) async{
    ShipOrder shipOrder;
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.productPath+"$productId/get_ship_order/"));
      shipOrder = ShipOrder.fromJson(response.data['data']);
      return shipOrder;
    }
    catch(e){
      print(e);
    }
    return null;
  }

  Future<String> fetchProducts({String url, Map<String, dynamic> queryParams}) async {
    try {
      Response response;
      response = await HttpHelper().getDio().get(
            url,queryParameters: queryParams
          );
      print(response);
      if (response.data['count'] >= 1) {
        for (var result in response.data['results']) {
          _listProduct.add(Product.fromJson(result));
        }
      }
      return response.data['next'];
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Product>> getProductList(
      {int detailId, String status, int organ}) async {
    if (_preUrl == null && _nextUrl == null) {
      _preUrl = ImmpApi.getApiPath(ImmpApi.productPath);
      Map<String, dynamic> map={};
      if(detailId!=null)
      {
        map['detail']=detailId;
      }
      
      if(status!=null){
        if(status.compareTo("已生产")==0){
          map['status']=1;
        }else if(status.compareTo("已发货")==0){
          map['status']=4;
        }else if(status.compareTo("未生产")==0){
          map['status']=0;
        }
      }
      if ((_nextUrl = await fetchProducts(url: _preUrl, queryParams: map)) != null) {

      }
    } else {
      if (_nextUrl != null) {
        if ((_nextUrl = await fetchProducts(url: _nextUrl)) != null) {
          _preUrl = _nextUrl;
        }
      }
    }
    return _listProduct;
  }

  Future<Product> getProduct({String code}) async{
    Product product;
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.productPath), queryParameters: {"code": code}
      );
      if(response.data['count']>=1) {
        product = Product.fromJson(response.data['results'][0]);
      }
      return product;
    }
    catch(e){
      print(e);
    }
    return null;
  }

  Future<List<ProductAttribute>> getAttribute({int id}) async{
    List<ProductAttribute> attributes=[];
    try {
      Response response;
      response = await HttpHelper().getDio().get(
          ImmpApi.getApiPath(ImmpApi.productPath+"$id/get_attribute/"));
      if(response.data['status'].toString().compareTo('success')==0){
        for(var result in response.data['data']){
          attributes.add(ProductAttribute.fromJson(result));
        }
        return attributes;
      }
    }
    catch(e){
      print(e);
    }
    return [];
  }

}
