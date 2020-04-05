import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/bloc/object_filter_bloc.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import 'package:manufacture/data/repository/object_repository.dart';

typedef OnItemShow<T> = String Function(T t);

class ObjectFilterPage<T extends BaseBean> extends StatefulWidget{
  final ValueChanged<FilterItem> filterItemChange;
  final ObjectRepository<T> objectRepository;
  final OnItemShow<T> onItemNiceName;
  final Map<String, dynamic> initQueryParams;
  ObjectFilterPage({Key key, this.filterItemChange,this.objectRepository,this.onItemNiceName,this.initQueryParams}):super(key:key);
  @override
  State<StatefulWidget> createState() => ObjectFilterPageState<T>();
}

class ObjectFilterPageState<T extends BaseBean> extends State<ObjectFilterPage>{
  ObjectFilterBloc<T> _bloc;

  @override
  void initState() {
    _bloc = ObjectFilterBloc(objectRepository: widget.objectRepository);
    _bloc.add(LoadEvent(queryParams: widget.initQueryParams));
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<ObjectFilterBloc, ObjectFilterState>(
      bloc: _bloc,
      listener: (context, state){},
      condition: (preState, currentState){
        return true;
      },
      child: BlocBuilder<ObjectFilterBloc, ObjectFilterState>(
        bloc: _bloc,
        builder: (context, state){
          if(state is LoadedState){
            List<ListTile> _widgets = state.list.map((bean){
              return ListTile(
                title: Text(widget.onItemNiceName!=null?widget.onItemNiceName(bean):"item ${bean.id}"),
                onTap: (){
                  widget.filterItemChange(FilterItem(niceName: widget.onItemNiceName!=null?widget.onItemNiceName(bean):"item ${bean.id}",filterValue: "${bean.id}"));
                },
              );
            }).toList();

            _widgets.insert(0, ListTile(
              title: Text("全部"),
              onTap: (){
                widget.filterItemChange(FilterItem(niceName: "全部",));
              },
            ));

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _widgets,
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }

}