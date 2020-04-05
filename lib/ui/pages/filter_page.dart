import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final Widget child;
  final List<String> filterList;
  final ValueChanged<String> filterChange;
  FilterPage({Key key, this.child, this.filterList, this.filterChange}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool _expandFilter = false;
  String _filter;

  @override
  void initState() {
    _filter = widget.filterList!=null?widget.filterList[0]:"选择";
    super.initState();
  }

  void _filterPanleStatusChange() {
    if (_expandFilter) {
      setState(() {
        _expandFilter = false;
      });
    } else {
      setState(() {
        _expandFilter = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Row(
                  children: <Widget>[
                    Text(_filter),
                    Icon(_expandFilter
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                  ],
                ),
                onTap: () {
                  _filterPanleStatusChange();
                },
              ),
//              Row(
//                children: <Widget>[
//                  Text('数量'),
//                  Text('  100'),
//                ],
//              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: widget.child != null ? widget.child : Text('No content'),
              ),
              GestureDetector(
                child: Container(
                  height: _expandFilter ? double.infinity : 0,
                  //color: Colors.red,
                  //alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          child: widget.filterList == null
                              ? Center(
                                  child: Text('无查询条件'),
                                )
                              : ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  semanticChildCount: widget.filterList.length,
                                  children:
                                      widget.filterList.map<ListTile>((value) {
                                    return ListTile(
                                      title: Text(value, style: TextStyle(fontSize: 14),),
                                      dense: false,
                                      onTap: (){
                                        if(widget.filterChange!=null){
                                          _filter = value;
                                          _filterPanleStatusChange();
                                          widget.filterChange(value);
                                        }
                                      },
                                    );
                                  }).toList()),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  _filterPanleStatusChange();
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
