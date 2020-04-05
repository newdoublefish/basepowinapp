import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/product_repository.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/util/dialog_util.dart';
import 'package:manufacture/util/snackbar_util.dart';
import '../../core/object_manager_page.dart';
import 'scan_page.dart';

class ShipInfoManage extends StatefulWidget {
  final ShipDetail detail;
  ShipInfoManage({Key key, this.detail}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ManageState();
}

class _ManageState extends State<ShipInfoManage> {
  ShipInfoObjectRepository _objectRepository;
  ObjectManagerController _objectManagerController = ObjectManagerController("refresh");
  @override
  void initState() {
    _objectRepository = ShipInfoObjectRepository.init();
    super.initState();
  }

  _addProduct(BuildContext context){
    Navigator.push<String>(context,
        MaterialPageRoute(builder: (context) {
          return Scan(
            title: "输入或者扫描产品编号",
          );
        })).then((result) {
      print(result);
      if (result != null) {
        if (result.length > 0) {
          Navigator.push<Product>(context,
              MaterialPageRoute(builder: (context) {
                return _ProductPage(
                  code: result,
                );
              })).then((value) {
            print(value);
            if (value != null) {
              DialogUtil.show(context,
                  title: Text("提示"),
                  content: Text("确定要添加${value.code}?"),
                  onPositive: () async {
                    bool flag = await _objectRepository.create(
                        obj: ShipInfo()
                          ..product = value.id
                          ..ship_detail = widget.detail.id);
                    print(flag);
                    if (flag) {
                      SnackBarUtil.success(
                          context: context, message: "添加成功");
                      _objectManagerController.requestRefresh();
                    } else {
                      SnackBarUtil.fail(
                          context: context, message: "添加失败");
                    }
                  });
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context){
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              _addProduct(context);
            },
          );
        },
      ),
      body: Builder(builder: (context){
        return ObjectManagerPage<ShipInfo>(
          title: "发货产品",
          objectRepository: _objectRepository,
          initQueryParams: {"ship_detail": widget.detail.id},
          objectManagerController: _objectManagerController,
          itemWidgetBuilder: (context, BaseBean obj) {
            Widget widget = ListTile(
              leading: ExcludeSemantics(
                  child: CircleAvatar(
                      child: Text((obj as ShipInfo).product_code[0]))),
              title: Text((obj as ShipInfo).product_code),
            );
            return widget;
          },
          onTap: (BaseBean value) {},
          extraPopupButton: <Widget>[
            PopupMenuItem<void>(
              child: ListTile(
                leading: Icon(Icons.create_new_folder),
                title: Text("添加"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push<String>(context,
                      MaterialPageRoute(builder: (context) {
                        return Scan(
                          title: "输入或者扫描产品编号",
                        );
                      })).then((result) {
                    print(result);
                    if (result != null) {
                      if (result.length > 0) {
                        Navigator.push<Product>(context,
                            MaterialPageRoute(builder: (context) {
                              return _ProductPage(
                                code: result,
                              );
                            })).then((value) {
                          print(value);
                          if (value != null) {
                            DialogUtil.show(context,
                                title: Text("提示"),
                                content: Text("确定要添加${value.code}?"),
                                onPositive: () async {
                                  bool flag = await _objectRepository.create(
                                      obj: ShipInfo()
                                        ..product = value.id
                                        ..ship_detail = widget.detail.id);
                                  print(flag);
                                  if (flag) {
                                    SnackBarUtil.success(
                                        context: context, message: "添加成功");
                                    _objectManagerController.requestRefresh();
                                  } else {
                                    SnackBarUtil.fail(
                                        context: context, message: "添加失败");
                                  }
                                });
                          }
                        });
                      }
                    }
                  });
                },
              ),
            ),
          ],
//      addEditPageBuilder: (context, BaseBean obj) {
//        return _ShipDetailCreateModify(
//          shipDetailObjectRepository: _objectRepository,
//          shipDetail: obj as ShipDetail,
//          shipOrder: widget.shipOrder,
//        );
//      },
        );
      },
      ),
    );
  }
}

class _ProductPage extends StatefulWidget {
  final String code;
  _ProductPage({Key key, this.code}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<_ProductPage> {
  ProductObjectRepository _productObjectRepository =
      ProductObjectRepository.init();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Product>(
      title: "搜索产品结果",
      initQueryParams: {"code_contains": widget.code},
      objectRepository: _productObjectRepository,
      itemWidgetBuilder: (context, BaseBean obj) {
        Product _product = obj as Product;
        Widget widget = ListTile(
          leading: Icon(
            Icons.category,
            color: Theme.of(context).accentColor,
          ),
          title: Text(_product.code),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("型号:${(_product.category_text)}"),
            ],
          ),
          trailing: Text(_product.status_text),
        );
        return widget;
      },
      onTap: (BaseBean value) {
        Navigator.pop(context, value as Product);
//        Navigator.push(context, MaterialPageRoute(builder: (context){
//          return ProductDetailPage(
//            product: value as Product,
//          );
//        }));
      },
    );
  }
}
