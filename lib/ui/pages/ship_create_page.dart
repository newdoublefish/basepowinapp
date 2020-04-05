import 'package:flutter/material.dart';
import 'package:manufacture/bloc/ship_create_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/ship_repository.dart';

typedef ModalSelectCallback = void Function(ShipModal modal);

class _ModalSelect extends StatefulWidget {
  final List<ShipModal> list;
  final ModalSelectCallback modalSelectCallback;
  _ModalSelect({@required this.list, @required this.modalSelectCallback});
  @override
  State<StatefulWidget> createState() => _ModalSelectState();
}

class _ModalSelectState extends State<_ModalSelect> {
//  String dropdown3Value = 'Can';
  List<String> dropDownList;
  ShipModal _dropdownShipModal;

  @override
  void initState() {
    _dropdownShipModal = widget.list[0];
    widget.modalSelectCallback(_dropdownShipModal);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ShipModal>(
      value: _dropdownShipModal,
      onChanged: (ShipModal newValue) {
        setState(() {
          _dropdownShipModal = newValue;
          widget.modalSelectCallback(_dropdownShipModal);
        });
      },
      items: widget.list.map<DropdownMenuItem<ShipModal>>((ShipModal value) {
        return DropdownMenuItem<ShipModal>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}

class _ShipForm extends StatefulWidget {
  final ShipModal shipModal;
  final CreateShipBloc createShipBloc;
  _ShipForm({this.shipModal, this.createShipBloc});
  @override
  State<StatefulWidget> createState() => _ShipFormState();
}

class _ShipFormState extends State<_ShipForm> {
  List<Widget> _list;
  ShipModal _shipModal;
  List<TextEditingController> _controllerList = [];
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _shipModal = widget.shipModal;
    _list = widget.shipModal.info.map<Widget>((i) {
      TextEditingController controller = new TextEditingController();
      _controllerList.add(controller);
      return TextFormField(
        controller: controller,
        validator: (value) {
          if (value.isEmpty) {
            return "内容不能为空";
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.info),
          labelText: i.name,
          hintText: i.name,
          //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
        ),
      );
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //这样做的原因和 flutter渲染有关系， widget只是 renderObject的配置， 由element来对比区别。
    //解决提交失败， 填写的内容不保存的问题
    print(_shipModal);
    print(widget.shipModal);
    if (_shipModal.id != widget.shipModal.id) {
      _shipModal = widget.shipModal;
      _amountController.clear();
      _codeController.clear();
      _controllerList.clear();
      _list = widget.shipModal.info.map<Widget>((i) {
        TextEditingController controller = new TextEditingController();
        _controllerList.add(controller);
        return TextFormField(
          controller: controller,
          validator: (value) {
            if (value.isEmpty) {
              return "内容不能为空";
            }
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.info),
            labelText: i.name,
            hintText: i.name,
            //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
          ),
        );
      }).toList();
    }
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _codeController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.code),
                labelText: '编号',
                hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            TextFormField(
              controller: _amountController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.supervisor_account),
                labelText: '数量',
                hintText: '数量',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _list,
            ),
            RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text("确认"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(
                        color: Color(0xFFFFF00F),
                        style: BorderStyle.solid,
                        width: 2)),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    for (int i = 0; i < widget.shipModal.info.length; i++) {
                      widget.shipModal.info[i].value = _controllerList[i].text;
                      print(_controllerList[i].text);
                    }
                    print(widget.shipModal.info);
                    ShipOrder order = new ShipOrder();
                    order.info = widget.shipModal.info;
                    order.code = _codeController.text;
                    order.finished = false;
                    order.modal = widget.shipModal.id;
                    //order.contract_code = _amountController.text;
                    print(order);
                    widget.createShipBloc.add(CommitNewShipEvent(
                        order: order, modal: widget.shipModal));
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class CreateOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateOrderPage();
}

class _CreateOrderPage extends State<CreateOrder> {
  CreateShipBloc _createShipBloc;
  ShipModal _shipModal;
  List<ShipModal> _shipModalList;

  @override
  void initState() {
    _createShipBloc = new CreateShipBloc(shipRepository: ShipRepository());
    _createShipBloc.add(FetchShipModalEvent());
    super.initState();
  }

  @override
  void dispose() {
    _createShipBloc.close();
    super.dispose();
  }

  void _showDialog(List<ShipModal> list) {
    ShipModal sm;
    showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: new Text("选择发货模型"),
          content: Builder(builder: (context) {
            return _ModalSelect(
              list: list,
              modalSelectCallback: (modal) {
                sm = modal;
              },
            );
          }),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  _shipModal = sm;
                  _createShipBloc
                      .add(SelectShipModalEvent(shipModal: _shipModal));
                  Navigator.of(context).pop();
                },
                child: new Text("确定")),
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("取消")),
          ],
        );
      },
    );
  }

  //TODO:用dialog 选择模型
  //https://www.jianshu.com/p/dd1ebfaf38e2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建发货单'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '发货模型选择',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _showDialog(_shipModalList);
            },
          ),
        ],
      ),
      body: BlocListener<CreateShipBloc, CreateShipState>(
        bloc: _createShipBloc,
        listener: (context, state) {
          if (state is ShipModalLoadedState) {
            _shipModalList = state.shipModalList;
            _showDialog(state.shipModalList);
          }
          if (state is ShipCreateErrorState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('创建失败'),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is ShipCreateSuccessState) {
            Navigator.pop(context, "success");
          }
        },
        child: BlocBuilder<CreateShipBloc, CreateShipState>(
            bloc: _createShipBloc,
            builder: (event, state) {
              if (state is ShipModalSelectedState) {
                _shipModal = state.shipModal;
              }
              if (_shipModal != null) {
                return new _ShipForm(
                  shipModal: _shipModal,
                  createShipBloc: _createShipBloc,
                );
              } else {
                return Center(
                  child: Text("请选择发货模型"),
                );
              }
            }),
      ),
    );
  }
}
