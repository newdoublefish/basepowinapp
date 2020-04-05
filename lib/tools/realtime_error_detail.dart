import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:manufacture/data/http.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:manufacture/data/apis.dart';
import 'package:manufacture/data/repository.dart';
import 'package:manufacture/beans/real_info.dart';

class _InfoRow extends StatelessWidget {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  _InfoRow({this.realInfo});
  final RealInfo realInfo;

  Widget _buildError(RealInfo data) {
    return ListTile(
      leading: new Icon(
        Icons.warning,
        color: data.status.compareTo("发生") == 0 ? Colors.red : Colors.green,
      ),
      title: Text(
        data.message,
        style: _biggerFont,
      ),
      subtitle: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(data.type),
          Text(data.component),
          Text(data.occurredAt),
        ],
      ),
      trailing: new Text(
        data.status,
        style: TextStyle(
            color: data.status.toString().compareTo("发生") == 0
                ? Colors.red
                : Colors.green),
      ),
    );
  }

  Widget _buildLogin(RealInfo data) {
    return ListTile(
      leading: new Icon(Icons.blur_on),
      title: Text(
        data.message,
        style: _biggerFont,
      ),
      subtitle: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(data.type),
          Text(data.occurredAt),
        ],
      ),
    );
  }

  Widget _buildOffline(RealInfo data) {
    return ListTile(
      leading: new Icon(Icons.blur_off),
      title: Text(
        data.message,
        style: _biggerFont,
      ),
      subtitle: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(data.type),
          Text(data.occurredAt),
        ],
      ),
    );
  }

  Widget _buildInit(RealInfo data) {
    return ListTile(
      leading: new Icon(Icons.swap_vertical_circle),
      title: Text(
        data.message,
        style: _biggerFont,
      ),
      subtitle: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(data.type),
          Text(data.occurredAt),
        ],
      ),
    );
  }

  Widget _buildRow(RealInfo realInfo) {
    if (realInfo.type == '初始化') {
      return _buildInit(realInfo);
    } else if (realInfo.type == '故障') {
      return _buildError(realInfo);
    } else if (realInfo.type == '登录') {
      return _buildLogin(realInfo);
    } else if (realInfo.type == '离线') {
      return _buildOffline(realInfo);
    } else {
      print(realInfo);
      return ListTile();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildRow(realInfo);
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}

class _SearchDelegate extends SearchDelegate<void> {
  final List<String> keyword = <String>['初始化', "登录", "故障", "离线"];
  List<RealInfo> _list = [];
  //_SearchDelegate(this._list);

  void setSearchList(List<RealInfo> list) {
    _list = list;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    //print();
    //print(query);
    List<RealInfo> list = _list
        .where((RealInfo info) => info.type.compareTo(query) == 0)
        .toList();
    return ListView.builder(
        itemCount: list.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          return _InfoRow(realInfo: list[index]);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return _SuggestionList(
      query: query,
      suggestions: keyword,
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class RealTimeErrorDetail extends StatefulWidget {
  final String deviceSn;
  RealTimeErrorDetail({Key key, this.deviceSn}) : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _RealTimeErrorDetailState(deviceSn: this.deviceSn);
}

class BackdropTitle extends AnimatedWidget {
  const BackdropTitle({
    Key key,
    Listenable listenable,
  }) : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.5, 1.0),
            ).value,
            child: const Text('设置'),
          ),
          Opacity(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.5, 1.0),
            ).value,
            child: const Text('实时故障查询'),
          ),
        ],
      ),
    );
  }
}

class _RealTimeErrorDetailState extends State<RealTimeErrorDetail>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<RealInfo> _list = [];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final String deviceSn;
  DateTime _fromDate;
  TimeOfDay _fromTime;
  DateTime _tempDate;
  TimeOfDay _tempTime;
  final _SearchDelegate _delegate = _SearchDelegate();

  int _lastRefreshTime = 0;
  int _errorCnt = 0;

  AnimationController _controller;
  _RealTimeErrorDetailState({Key key, this.deviceSn});

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _fromDate = now.subtract(new Duration(days: 1));
    _fromTime = TimeOfDay.now();
    _tempDate = now.subtract(new Duration(days: 1));
    _tempTime = TimeOfDay.now();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
    _onRefresh();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    final RenderBox renderBox = _scaffoldKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  // By design: the panel can only be opened with a swipe. To close the panel
  // the user must either tap its heading or the backdrop's menu icon.

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  Future<void> _onRefresh() async {
    if (_lastRefreshTime == 0) {
      _lastRefreshTime = DateTime(_fromDate.year, _fromDate.month,
              _fromDate.day, _fromTime.hour, _fromTime.minute)
          .millisecondsSinceEpoch;
    }
    List<RealInfo> list = await getErrors(deviceSn, _lastRefreshTime);
    if (list != null && list.length != 0) {
      setState(() {
        _list.insertAll(0, list);
        _lastRefreshTime =
            DateTime.parse(_list[0].occurredAt).millisecondsSinceEpoch;
        _errorCnt = _list.length;
      });
    }
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    final Animation<RelativeRect> panelAnimation = _controller.drive(
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0.0,
          panelTop - MediaQuery.of(context).padding.bottom,
          0.0,
          panelTop - panelSize.height,
        ),
        end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
      ),
    );

    final ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          ListTileTheme(
            iconColor: theme.primaryIconTheme.color,
            textColor: theme.primaryTextTheme.title.color.withOpacity(0.6),
            selectedColor: theme.primaryTextTheme.title.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _DateTimePicker(
                    labelText: 'From',
                    selectedDate: _tempDate,
                    selectedTime: _tempTime,
                    selectDate: (DateTime date) {
                      setState(() {
                        _tempDate = date;
                      });
                    },
                    selectTime: (TimeOfDay time) {
                      setState(() {
                        _tempTime = time;
                      });
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: MaterialButton(
                        child: Text(
                          '确定',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          _fromTime = _tempTime;
                          _fromDate = _tempDate;
                          setState(() {
                            _lastRefreshTime = 0;
                            _list.clear();
                          });
                          _onRefresh();
                          _toggleBackdropPanelVisibility();
                        }),
                  ),
//                  Container(
//                    //alignment: Alignment.center,
//                    margin: const EdgeInsets.only(top: 10),
//                    child: RaisedButton(
//                      color: Colors.deepOrange,
//                        child: Text(
//                          '清空',
//                          style: TextStyle(fontSize: 18),
//                        ),
//                        onPressed: () {
//                          _list.clear();
//                          _lastRefreshTime = 0;
//                          _errorCnt = 0;
//                          _toggleBackdropPanelVisibility();
//                        }),
//                  ),
                ],
              ),
            ),
          ),
          PositionedTransition(
            rect: panelAnimation,
            child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 80,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.dashboard,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        Text('装置编号'),
                                      ],
                                    ),
                                    Text(
                                      deviceSn,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.green),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.grain,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        Text('信息数量'),
                                      ],
                                    ),
                                    Text(
                                      _errorCnt.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.deepOrange),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Divider(),
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                            itemCount: _list.length * 2,
                            itemBuilder: (context, i) {
                              if (i.isOdd) return Divider();
                              final index = i ~/ 2;
                              return _InfoRow(realInfo: _list[index]);
                            }),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: BackdropTitle(
          listenable: _controller.view,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
//              setState(() {
//                _list.clear();
//                _lastRefreshTime = 0;
//                _errorCnt = 0;
//              });
              showDialog(
                  builder: (context) => new AlertDialog(
                        title: new Text('提示'),
                        content: new Text('确定要清空'),
                        actions: <Widget>[
                          new FlatButton(
                              onPressed: () {
                                setState(() {
                                  _list.clear();
                                  _lastRefreshTime = 0;
                                  _errorCnt = 0;
                                });
                                Navigator.pop(context);
                              },
                              child: new Text('确定')),
                          new FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: new Text('取消'))
                        ],
                      ),
                  context: context);
            },
          ),
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              _delegate.setSearchList(_list);
              showSearch<void>(
                context: context,
                delegate: _delegate,
              );
            },
          ),
          IconButton(
            onPressed: _toggleBackdropPanelVisibility,
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              semanticLabel: 'close',
              progress: _controller.view,
            ),
          ),
        ],
      ),
//
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }
}
