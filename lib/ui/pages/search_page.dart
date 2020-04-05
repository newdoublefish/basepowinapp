import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'search_result_page.dart';



class SearchDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchDialog();
}

class _SearchDialog extends State<SearchDialog> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = new TextEditingController();
  String query = "";

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: Theme.of(context).primaryIconTheme,
        textTheme: Theme.of(context).primaryTextTheme,
        brightness: Theme.of(context).primaryColorBrightness,
        leading: IconButton(
          tooltip: 'Back',
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        title: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 5),
          child: TextFormField(
            //focusNode: _focusNode,
            controller: _textEditingController,
            autofocus: true,
            style: Theme.of(context).textTheme.title,
            textInputAction: TextInputAction.search,
            maxLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: MaterialLocalizations.of(context).searchFieldLabel,
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            ),
            onChanged: (String str) {
              setState(() {
                query = str;
              });
            },
          ),
        ),
        actions: <Widget>[
          query.isEmpty
              ? IconButton(
                  tooltip: 'Voice Search',
                    icon: const Icon(Icons.zoom_out_map),
                  onPressed: () async {
                    String barcode = await BarcodeScanner.scan();
                    setState(() {
                      _textEditingController.text = barcode;
                      query = barcode;
                    });
                  },
                )
              : IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _textEditingController.clear();
                      query = "";
                    });
                  },
                ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          ListTile(
            dense: true,
            leading: Text("搜流水"),
            title: Text(query),
            onTap: (){
              if(query.isEmpty == false)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SearchResultPage(
                    searchItem: SearchItem(type: SearchType.FLOW, code: query),
                  );
                }));
              }
              //Navigator.pop(context, SearchItem(type: 0, code: query));
            },
          ),
          ListTile(
            dense: true,
            leading: Text("搜产品"),
            title: Text(query),
            onTap: (){
              if(query.isEmpty == false)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SearchResultPage(
                    searchItem: SearchItem(type: SearchType.PRODUCT, code: query),
                  );
                }));
              }
            },
          ),
          ListTile(
            dense: true,
            leading: Text("搜发货单"),
            title: Text(query),
            onTap: (){
              if(query.isEmpty == false)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SearchResultPage(
                    searchItem: SearchItem(type: SearchType.SHIP, code: query),
                  );
                }));
              }
            },
          ),
          ListTile(
            dense: true,
            leading: Text("搜工艺"),
            title: Text(query),
            onTap: (){
              if(query.isEmpty == false)
              {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SearchResultPage(
                    searchItem: SearchItem(type: SearchType.TECH, code: query),
                  );
                }));
              }
            },
          ),
        ],
      )
    );
  }
}
