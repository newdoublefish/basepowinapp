import 'package:flutter/material.dart';
import 'package:manufacture/ui/pages/brand_manage_page.dart';
import 'package:manufacture/ui/pages/product_manager_page.dart';
import 'package:manufacture/ui/pages/search_page.dart';
import 'package:manufacture/ui/pages/search_result_page.dart';
import 'package:manufacture/ui/pages/ship_order_manager_page.dart';
import 'package:manufacture/ui/pages/short_cut_page.dart';
import 'package:manufacture/ui/pages/tech_manage_page.dart';
import 'package:manufacture/ui/pages/trade_manage_page.dart';
import 'package:manufacture/ui/pages/work_fragment.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'user_manager_page.dart';
import 'flow_modal_manager.dart';
import 'organization_manager_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconItem extends StatelessWidget {
  final Icon icon;
  final Color backgroundColor;

  IconItem({@required this.icon, this.backgroundColor}) : assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: ShapeDecoration(
        color: backgroundColor == null
            ? Theme.of(context).accentColor
            : backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      //child: Image.asset(image,fit: BoxFit.cover,),
      child: icon,
    );
  }
}

class ImageItem extends StatelessWidget {
  final String image;

  ImageItem({@required this.image}) : assert(image != null);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: BoxFit.cover,
      width: 60,
      height: 60,
    );
  }
}

class Item extends StatelessWidget {
  Item({Key key, this.name, this.widget, this.iconWidget}) : super(key: key);
  final String name;
  final Widget iconWidget;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    _showDialog() {
      showDialog(
          builder: (context) => new AlertDialog(
                title: new Text('提示'),
                content: new Text('$name建设中'),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: new Text('确定'))
                ],
              ),
          context: context);
    }

    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  child: iconWidget != null
                      ? iconWidget
                      : Image.asset(
                          "images/tool2.png",
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                ),
                onTap: () {
                  //print("${this.route}");
                  //_showDialog();
                  if (widget != null) {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return widget;
                    }));
                  } else {
                    _showDialog();
                  }
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Text(
                  this.name,
                  style: TextStyle(
                    fontSize: 12, /*fontWeight: FontWeight.w600*/
                  ),
                  //style: TextStyle(),
                ),
              ),
            ]));
  }
}

class Category extends StatelessWidget {
  Category({Key key, this.name, this.items, this.maxItemsPerLine = 4})
      : super(key: key);
  final String name;
  final List<Item> items;
  final int maxItemsPerLine;

  Widget _buildText() {
    return Container(
      //child: Text(this.name,style: TextStyle(fontSize: 18),),
      child: Row(
        children: <Widget>[
          //Icon(Icons.build,color: Colors.grey,),
          Text(
            this.name,
            //style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList(List<Widget> widgetList) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgetList,
      ),
    );
  }

  List<Widget> _buildWidgetList() {
    int lineCount = items.length ~/ maxItemsPerLine;
    int extraCount = items.length % maxItemsPerLine;
    if (extraCount > 0) {
      lineCount = lineCount + 1;
    }
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(_buildText());
    for (int i = 0; i < lineCount; i++) {
      if (i * maxItemsPerLine + maxItemsPerLine < items.length) {
        widgetList.add(_buildItemList(items.sublist(
            i * maxItemsPerLine, i * maxItemsPerLine + maxItemsPerLine)));
      } else {
        widgetList.add(
            _buildItemList(items.sublist(i * maxItemsPerLine, items.length)));
      }
    }
    widgetList.add(Divider());
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildWidgetList()),
    );
  }
}

class ToolState extends State<Tool> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //children: _list.map<Widget>((Category c)=>c.buildCategory()).toList(),
        //children: _list,
        children: <Widget>[
          Category(
            name: "快捷操作",
            items: <Item>[
              Item(
                name: '制订单查询',
                iconWidget: IconItem(
                  icon: Icon(
                    Icons.trending_down,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                widget: ShortCutPage(
                  title: "制订单查询",
                  type: SearchType.FLOW,
                ),
              ),
              Item(
                name: '用户管理',
                iconWidget: IconItem(
                    icon: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                ),backgroundColor: Colors.orangeAccent,),
                widget: UserManager(
                    //userRepository: widget.userRepository,
                    ),
              ),
            ],
          ),
          Builder(builder: (context) {
            if (widget.userRepository.user.is_admin == true ||
                widget.userRepository.user.is_superuser == true) {
              return Category(
                name: '管理工具',
                items: <Item>[
                  //Item(name: '发货单管理',image: 'images/tool1.png',route: 'hello', widget: ShipsManager(title: "发货单管理",),),
                  Item(
                    name: '用户管理',
                    iconWidget: IconItem(
                      icon: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.orangeAccent,
                    ),
                    widget: UserManager(
                        //userRepository: widget.userRepository,
                        ),
                  ),
                  Item(
                    name: '项目管理',
                    iconWidget: IconItem(
                      icon: Icon(
                        FontAwesomeIcons.sitemap,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    widget: WorkPage(
                      userRepository: widget.userRepository,
                      canEdit: true,
                    ),
                  ),
                  Item(
                    name: '流程管理',
                    iconWidget: IconItem(
                      icon: Icon(
                        FontAwesomeIcons.projectDiagram,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    widget: FlowModeManager(),
                  ),
                  Item(
                      name: '组织管理',
                      iconWidget: IconItem(
                        icon: Icon(
                          FontAwesomeIcons.layerGroup,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.orangeAccent,
                      ),
                      widget: OrganizationManager()),
                ],
              );
            } else {
              return Container();
            }
          }),
          Builder(builder: (context) {
            if (widget.userRepository.user.is_admin == true ||
                widget.userRepository.user.is_superuser == true) {
              return Category(
                name: '产品信息',
                items: <Item>[
                  Item(
                    name: '品牌管理',
                    iconWidget: IconItem(
                      icon: Icon(
                        Icons.style,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.deepOrange,
                    ),
                    widget: BrandManage(),
                  ),
                  //Item(name: '发货单管理',image: 'images/tool1.png',route: 'hello', widget: ShipsManager(title: "发货单管理",),),
                  Item(
                    name: '产品类型',
                    iconWidget: IconItem(
                      icon: Icon(
                        FontAwesomeIcons.tag,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    widget: TradeManage(
                        //userRepository: widget.userRepository,
                        ),
                  ),
                  Item(
                    name: '产品管理',
                    iconWidget: IconItem(
                      icon: Icon(
                        FontAwesomeIcons.productHunt,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    widget: ProductManagePage(),
                  ),
                  Item(
                    name: '二维码管理',
                    iconWidget: IconItem(
                        icon: Icon(
                      FontAwesomeIcons.qrcode,
                      color: Colors.white,
                    )),
                    widget: TechManagePage(),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
          Builder(builder: (context) {
            if (widget.userRepository.user.is_admin == true ||
                widget.userRepository.user.is_superuser == true) {
              return Category(
                name: "发货信息",
                items: <Item>[
                  Item(
                    name: '发货信息',
                    iconWidget: IconItem(
                      icon: Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    widget: ShipOrderManage(
                        //userRepository: widget.userRepository,
                        ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }
}

class Tool extends StatefulWidget {
  final UserRepository userRepository;

  Tool({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ToolState();
}

class _Notify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 180,
      padding: const EdgeInsets.all(10),
      //child: Image.asset('images/lake.jpg',fit: BoxFit.cover,),
      child: PageView(
        children: <Widget>[
          Image.asset(
            'images/view1.jpg',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'images/view2.jpg',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'images/view3.jpg',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class HomeMainState extends State<HomeMain> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        //backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Image.asset('images/mcmc.png',fit: BoxFit.cover,),
              CircleAvatar(
                backgroundImage: AssetImage('images/logo.jpg'),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Center(
                        child: Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          Text(
                            "搜索...",
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                          ),
                        ],
                      ),
                    )),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchDialog();
                    }));
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {},
              )
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                _Notify(),
                Tool(
                  userRepository: widget.userRepository,
                ),
              ]),
            )
          ],
        ));
  }
}

class HomeMain extends StatefulWidget {
  final UserRepository userRepository;

  HomeMain({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeMainState();
}
