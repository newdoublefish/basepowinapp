import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/core/object_filter_page.dart';
import 'package:manufacture/core/object_generate_page.dart';
import 'package:manufacture/core/object_select_dialog.dart';
import 'package:manufacture/core/object_select_widget.dart';
import 'package:manufacture/core/object_selector.dart';
import 'package:manufacture/data/repository/brand_repository.dart';
import 'package:manufacture/data/repository/category_repository.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import 'package:manufacture/util/dialog_util.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/product_repository.dart';
import '../../core/object_manager_page.dart';
import 'product_detail_page.dart';


class ProductManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductManagePageState();
}

class _ProductManagePageState extends State<ProductManagePage> {
  ProductObjectRepository _objectRepository;
  CategoryObjectRepository _categoryObjectRepository;
  ProjectObjectRepository _projectObjectRepository;
  _ProductGenerateDelegate _productGenerateDelegate;
  ObjectManagerController _objectManagerController = ObjectManagerController("refresh");

  @override
  void initState() {
    _objectRepository = ProductObjectRepository.init();
    _categoryObjectRepository = CategoryObjectRepository.init();
    _projectObjectRepository = ProjectObjectRepository.init();
    _productGenerateDelegate = _ProductGenerateDelegate(categoryObjectRepository: _categoryObjectRepository, projectObjectRepository: _projectObjectRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Product>(
      title: "产品管理",
      //initQueryParams: {"product_detail": widget.detail.id},
      objectRepository: _objectRepository,
      objectManagerController: _objectManagerController,
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
      filterGroupList: [
        FilterGroup(
            niceName: "型号",
            filterName: "category",
            builder: (context, func) {
              return ObjectFilterPage<Category>(
                objectRepository: _categoryObjectRepository,
                filterItemChange: func,
                onItemNiceName: (BaseBean result) {
                  return (result as Category).code;
                },
              );
            }),
        FilterGroup(
            niceName: "项目",
            filterName: "project",
            builder: (context, func) {
              return ObjectFilterPage<Project>(
                objectRepository: _projectObjectRepository,
                filterItemChange: func,
                onItemNiceName: (BaseBean result) {
                  return (result as Project).code;
                },
              );
            }),
      ],
      onTap: (BaseBean value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailPage(
            product: value as Product,
          );
        }));
      },
//      addEditPageBuilder: (context, BaseBean obj){
//        return OrganizationAddEditPage(
//          organization: obj as Organization,
//          objectRepository: _organizationObjectRepository,
//        );
//      },
      extraPopupButton: <Widget>[
        PopupMenuItem<void>(
          child: ListTile(
            leading: Icon(Icons.create_new_folder),
            title: Text("产品批量生成"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<bool>(context,
                  MaterialPageRoute(builder: (context) {
//                    return TechnologyGenerate(
//                      projectObjectRepository: _projectObjectRepository,
//                      techObjectRepository: _techObjectRepository,
//                    );
                    return ObjectGeneratePage<Product>(
                      objectRepository: _objectRepository,
                      objectGenerateDelegate: _productGenerateDelegate,
                    );
                  })).then((result) {
                if (result != null) {
                  //TODO: to refresh
                  _objectManagerController.requestRefresh();
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

class _ProductGenerateDelegate extends ObjectGenerateDelegate<Product> {
  final ProjectObjectRepository projectObjectRepository;
  final CategoryObjectRepository categoryObjectRepository;

  _ProductGenerateDelegate({@required this.projectObjectRepository, @required this.categoryObjectRepository}):assert(projectObjectRepository!=null, categoryObjectRepository!=null);

  BrandObjectRepository _brandObjectRepository = BrandObjectRepository.init();

  ObjectSelectController<Project> _projectSelectController =
      new ObjectSelectController();

  ObjectSelectController<Category> _categorySelectController =
      new ObjectSelectController();

  ObjectSelectController<Brand> _brandSelectController =
      new ObjectSelectController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListTile(
          leading: Text("批次"),
          dense: true,
          title: ObjectSelector<Project>(
            objectRepository: projectObjectRepository,
            title: "批次选择",
            buildValueText: (BaseBean detail) {
              return (detail as Project).code;
            },
            //object: Detail()..id = 1,
            controller: _projectSelectController,
            objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
              ObjectTobeSelect<Project>(
                  title: "批次",
                  buildQueryParam: (BaseBean t) {
                    return null;
                  },
                  objectRepository: projectObjectRepository,
                  buildObjectItem: (BaseBean t) {
                    return Text(((t as Project).code));
                  }),
            ]),
          ),
        ),
        ListTile(
          leading: Text("产品类型"),
          dense: true,
          title: ObjectSelector<Category>(
            objectRepository: categoryObjectRepository,
            title: "类型选择",
            buildValueText: (BaseBean detail) {
              return (detail as Category).name;
            },
            //object: Detail()..id = 1,
            controller: _categorySelectController,
            objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
              ObjectTobeSelect<Category>(
                  title: "类型",
                  buildQueryParam: (BaseBean t) {
                    return null;
                  },
                  objectRepository: categoryObjectRepository,
                  buildObjectItem: (BaseBean t) {
                    return Text(((t as Category).code));
                  }),
            ]),
          ),
        ),
        ListTile(
          leading: Text("品牌选择"),
          dense: true,
          title: ObjectSelector<Brand>(
            objectRepository: _brandObjectRepository,
            title: "选择品牌",
            buildValueText: (BaseBean detail) {
              return (detail as Brand).name;
            },
            //object: Detail()..id = 1,
            controller: _brandSelectController,
            objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
              ObjectTobeSelect<Brand>(
                  title: "类型",
                  buildQueryParam: (BaseBean t) {
                    return null;
                  },
                  objectRepository: _brandObjectRepository,
                  buildObjectItem: (BaseBean t) {
                    return Text(((t as Brand).name));
                  }),
            ]),
          ),
        ),
      ],
    );
  }

  @override
  bool onVerify(BuildContext context) {
    if (_projectSelectController.selectObject == null) {
      DialogUtil.alert(context, content: Text("请选择批次号"));
      return false;
    }
    if (_categorySelectController.selectObject == null) {
      DialogUtil.alert(context, content: Text("请选择产品类型"));
      return false;
    }

    if (_brandSelectController.selectObject == null) {
      DialogUtil.alert(context, content: Text("请选择产品品牌"));
      return false;
    }

    return true;
  }

  @override
  Product buildObject(String code) {
    Product _product = Product();
    _product.code = code;
    _product.project = _projectSelectController.selectObject.id;
    _product.category = _categorySelectController.selectObject.id;
    _product.brand = _brandSelectController.selectObject.id;
    _product.status = 0;
    return _product;
  }

  @override
  String buildTitle() {
    return "产品批量生成";
  }
}
