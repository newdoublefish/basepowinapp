import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/organization_repository.dart';
import 'package:manufacture/ui/pages/manager_page.dart';
import '../../core/object_manager_page.dart';
import 'organization_add_edit_page.dart';
import 'unit_manager_page.dart';

class OrganizationManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrganizationManagerState();
}

class _OrganizationManagerState extends State<OrganizationManager> {
  OrganizationObjectRepository _organizationObjectRepository;
  @override
  void initState() {
    _organizationObjectRepository = OrganizationObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Organization>(
      title: "组织管理",
      //initQueryParams: {"product_detail": 14},
      objectRepository: _organizationObjectRepository,
      itemWidgetBuilder: (context, BaseBean obj) {
        Widget widget = Container(
          padding: const EdgeInsets.all(8),
          child: Card(
            color: Theme.of(context).accentColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                  //leading: Icon(Icons.settings_input_component),
                  title: Text((obj as Organization).name),
                  subtitle: Text((obj as Organization).short),
                  trailing: IconButton(
                    icon: Icon(Icons.group),
                    onPressed: () {
                      print("1111");
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ManagerPage(
                          organization: obj as Organization,
                        );
                      }));
                    },
                  ),
                )
              ],
            ),
          ),
        );
        return widget;
      },
      onTap: (BaseBean value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return UnitManager(
            organization: value as Organization,
          );
        }));
      },
      addEditPageBuilder: (context, BaseBean obj) {
        return OrganizationAddEditPage(
          organization: obj as Organization,
          objectRepository: _organizationObjectRepository,
        );
      },
      extraPopupButton: <Widget>[
        PopupMenuItem<void>(
          child: ListTile(
              leading: Icon(Icons.format_list_bulleted),
              title: Text('测试'),
              onTap: () {
                Navigator.pop(context);
              }),
        )
      ],
    );
  }
}
