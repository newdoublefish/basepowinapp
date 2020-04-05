import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/object_repository.dart';

typedef BuildCustomFilterGroup = Widget Function(BuildContext context, ValueChanged<FilterItem> callback);

class FilterItem {
  final String niceName;
  final String filterValue;
  FilterItem({this.niceName, this.filterValue});
  @override
  String toString() {
    return "FilterItem:{niceName:$niceName, filterValue:$filterValue}";
  }
}

class FilterGroup {
  String filterName;
  String niceName;
  List<FilterItem> filterItems;
  BuildCustomFilterGroup builder;

  FilterGroup({this.niceName, this.filterName, this.filterItems, this.builder});
  @override
  String toString() {
    // TODO: implement toString
    return "FilterGroup {filterName:$filterName, niceName:$niceName, filterItems:$filterItems}";
  }
}

class _FilterComponent {
  final FilterGroup group;
  bool isFilterExpand;
  FilterItem selectedItem;
  _FilterComponent({this.group, this.isFilterExpand = false});
  @override
  String toString() {
    return "_FilterComponent:{group:$group, isFilterExpand:$isFilterExpand, selectedItem:$selectedItem}";
  }
}

enum FilterMode {
  multi_outside,
  multi_inside,
}

class SmartFilterPage extends StatefulWidget {
  final Widget child;
  final List<FilterGroup> filterGroupList;
  final ValueChanged<Map<String, dynamic>> onFilterChange;
  final FilterMode mode;
  final Color filterGroupSelectColor;
  final Color barBackgroundColor;
  final Color expandPanelColor;
  SmartFilterPage(
      {Key key,
      this.child,
      this.onFilterChange,
      this.filterGroupList,
      this.barBackgroundColor = Colors.white,
      this.expandPanelColor = Colors.white,
      this.filterGroupSelectColor = Colors.green,
      this.mode = FilterMode.multi_outside})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _FilterPageState();
}

class _FilterContentNormal extends StatelessWidget{
  final _FilterComponent filterComponent;
  final ValueChanged<FilterItem> onFilterChange;
  _FilterContentNormal({this.onFilterChange, this.filterComponent});
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        semanticChildCount: filterComponent
            .group.filterItems.length,
        children: filterComponent
            .group.filterItems
            .map<ListTile>((item) {
          return ListTile(
            selected: filterComponent
                .selectedItem ==
                item
                ? true
                : false,
            title: Text(
              item.niceName,
              style: TextStyle(fontSize: 14),
            ),
            dense: false,
            onTap: () {
              onFilterChange(item);
//              _filterPanelStatusChange(
//                  component: _currentFilterComponent,
//                  item: item);
//              if (widget.onFilterChange != null) {
//                _filterMap.clear();
//                _filterComponentList
//                    .forEach((component) {
//                  if (component.selectedItem !=
//                      null) {
//                    if (component.selectedItem
//                        .filterValue !=
//                        null) {
//                      _filterMap[component
//                          .group.filterName] =
//                          component.selectedItem
//                              .filterValue;
//                    }
//                  }
//                });
//                widget.onFilterChange(_filterMap);
//              }
            },
          );
        }).toList());
  }
}

class _FilterPageState extends State<SmartFilterPage> {
  List<_FilterComponent> _filterComponentList;
  _FilterComponent _preFilterComponent;
  _FilterComponent _currentFilterComponent;
  Map<String, dynamic> _filterMap;

  @override
  void initState() {
    _filterMap = new Map<String, dynamic>();
    if (widget.filterGroupList != null) {
      _filterComponentList = widget.filterGroupList.map((group) {
        return _FilterComponent(group: group);
      }).toList();
      _currentFilterComponent = _filterComponentList[0];
      _preFilterComponent = _currentFilterComponent;
    }
    //print(_filterComponentList);
    //print(_activeFilterComponent);
    super.initState();
  }

  void _filterPanelStatusChange({_FilterComponent component, FilterItem item}) {
    print(component);
    _preFilterComponent = _currentFilterComponent;
    _currentFilterComponent = component;

    if (item != null) {
      _currentFilterComponent.selectedItem = item;
    }

    if (_preFilterComponent == _currentFilterComponent) {
      if (_currentFilterComponent.isFilterExpand) {
        setState(() {
          _currentFilterComponent.isFilterExpand = false;
        });
      } else {
        setState(() {
          _currentFilterComponent.isFilterExpand = true;
        });
      }
    } else {
      if (_preFilterComponent.isFilterExpand) {
        setState(() {
          _preFilterComponent.isFilterExpand = false;
          _currentFilterComponent.isFilterExpand = true;
        });
      } else {
        setState(() {
          _currentFilterComponent.isFilterExpand = true;
        });
      }
    }
  }

  void _onFilterChange(FilterItem item){
    print("ontap 1");
    _filterPanelStatusChange(
        component: _currentFilterComponent,
        item: item);
    if (widget.onFilterChange != null) {
      _filterMap.clear();
      _filterComponentList
          .forEach((component) {
        if (component.selectedItem !=
            null) {
          if (component.selectedItem
              .filterValue !=
              null) {
            _filterMap[component
                .group.filterName] =
                component.selectedItem
                    .filterValue;
          }
        }
      });
      widget.onFilterChange(_filterMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        widget.filterGroupList!=null?Container(
          color: widget.barBackgroundColor,
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _filterComponentList.map((component) {
                return Container(
                  margin: const EdgeInsets.only(left: 30,right: 30),
                  child: GestureDetector(
                    child: Container(
                      //color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(component.selectedItem != null
                              ? component.selectedItem.niceName
                              : component.group.niceName,),
                          Icon(
                            component.isFilterExpand
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: component.isFilterExpand
                                ? widget.filterGroupSelectColor
                                : null,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      //print(component);
                      _filterPanelStatusChange(component: component);
                    },
                  ),
                );
              }).toList(),
            ),
          )
        ):Container(),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: widget.child != null ? widget.child : Text('No content'),
              ),
              widget.filterGroupList!=null?GestureDetector(
                child: Container(
                  height: _currentFilterComponent.isFilterExpand
                      ? double.infinity
                      : 0,
                  //color: Colors.red,
                  //alignment: Alignment.center,
                  child: Stack(
                     children: <Widget>[
                       Opacity(
                         opacity: 0.5,
                         child: Container(
                           color: Colors.black,
                         ),
                       ),
                       SingleChildScrollView(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                           children: <Widget>[
                             Container(
                               color: widget.expandPanelColor,
                               padding: const EdgeInsets.only(
                                   top: 10, left: 10, right: 10, bottom: 10),
                               child: (_currentFilterComponent.group.filterItems ==
                                   null && _currentFilterComponent.group.builder == null)
                                   ? Center(
                                 child: Text('无查询条件'),
                               )
                                   : Builder(builder: (context){
                                     if(_currentFilterComponent.group.filterItems!=null){
                                       return _FilterContentNormal(filterComponent: _currentFilterComponent, onFilterChange: _onFilterChange,);
                                     }else if(_currentFilterComponent.group.builder!=null){
                                       return _currentFilterComponent.group.builder(context, _onFilterChange);
                                     }
                                     return Center(
                                         child: Text('无查询条件'));
                               },)
                             ),
                           ],
                         ),
                       ),
                     ],
                  )
                ),
                onTap: () {
                  print("ontap 2");
                  _filterPanelStatusChange(component: _currentFilterComponent);
                },
              ):Container(),
            ],
          ),
        )
      ],
    );
  }
}
