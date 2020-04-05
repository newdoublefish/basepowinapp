import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/core/object_create_modify_page.dart';
import 'package:manufacture/core/object_select_dialog.dart';
import 'package:manufacture/core/object_selector.dart';
import 'package:manufacture/data/repository/category_repository.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/ui/pages/ship_info_manage_page.dart';
import '../../core/object_manager_page.dart';

class ShipDetailManage extends StatefulWidget {
  final ShipOrder shipOrder;
  final bool canDeleteSingle;
  final bool canDeleteBatch;
  final bool canAddEditObject;
  ShipDetailManage(
      {Key key,
      this.shipOrder,
      this.canDeleteSingle = true,
      this.canDeleteBatch = true,
      this.canAddEditObject = true})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ManageState();
}

class _ManageState extends State<ShipDetailManage> {
  ShipDetailObjectRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = ShipDetailObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<ShipDetail>(
      title: "发货明细",
      objectRepository: _objectRepository,
      initQueryParams: {"ship_instance": widget.shipOrder.id},
      canDeleteSingle: widget.canDeleteSingle,
      canDeleteBatch: widget.canDeleteBatch,
      canAddEditObject: widget.canAddEditObject,
      itemWidgetBuilder: (context, BaseBean obj) {
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as ShipDetail).name[0]))),
          title: Text((obj as ShipDetail).name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("计划数量:${(obj as ShipDetail).quantity_plan}"),
              Text("完成数量:${(obj as ShipDetail).quantity_actual}"),
            ],
          )
        );
        return widget;
      },
      onTap: (BaseBean value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ShipInfoManage(
            detail: value as ShipDetail,
          );
        }));
      },
      addEditPageBuilder: (context, BaseBean obj) {
        return _ShipDetailCreateModify(
          shipDetailObjectRepository: _objectRepository,
          shipDetail: obj as ShipDetail,
          shipOrder: widget.shipOrder,
        );
      },
    );
  }
}

class _ShipDetailCreateModify extends StatefulWidget {
  final ShipOrder shipOrder;
  final ShipDetail shipDetail;
  final ShipDetailObjectRepository shipDetailObjectRepository;
  _ShipDetailCreateModify(
      {Key key,
      this.shipDetail,
      this.shipOrder,
      this.shipDetailObjectRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShipDetailCreateModifyState();
}

class _ShipDetailCreateModifyState extends State<_ShipDetailCreateModify> {
  ShipDetail _shipDetail;
  TextEditingController _planController = new TextEditingController();
  int _category;
  CategoryObjectRepository _categoryObjectRepository;

  @override
  void initState() {
    _categoryObjectRepository = CategoryObjectRepository.init();
    if (widget.shipDetail != null) {
      _shipDetail = widget.shipDetail;
      _category = widget.shipDetail.category;
      _planController.text = "${widget.shipDetail.quantity_plan}";
    } else {
      _shipDetail = ShipDetail();
      _shipDetail.quantity_actual = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectCreateModifyPage<ShipDetail>(
      title: "发货明细",
      type: widget.shipDetail != null
          ? ObjectOperateType.MODIFY
          : ObjectOperateType.CREATE,
      objectRepository: widget.shipDetailObjectRepository,
      buildBody: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 24.0),
            TextFormField(
              controller: _planController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                filled: true,
                labelText: '数量',
                //hintText: '名称',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            const SizedBox(height: 24.0),
            ObjectSelector<Category>(
              objectRepository: _categoryObjectRepository,
              title: "产品类型",
              buildValueText: (BaseBean detail) {
                return (detail as Category).code;
              },
              object: _category != null ? (Category()..id = _category) : null,
              //controller: _techModalSelectController,
              onSelectCallBack: (BaseBean value) {
                _category = value.id;
              },
              objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
                ObjectTobeSelect<Category>(
                    title: "产品类型",
                    buildQueryParam: (BaseBean t) {
                      return null;
                    },
                    objectRepository: _categoryObjectRepository,
                    buildObjectItem: (BaseBean t) {
                      return Text(((t as Category).code));
                    }),
              ]),
            )
          ],
        );
      },
      buildObject: () {
        _shipDetail.quantity_plan = int.parse(_planController.text.toString());
        _shipDetail.ship_instance = widget.shipOrder.id;
        _shipDetail.category = _category;
        return _shipDetail;
      },
    );
  }
}
