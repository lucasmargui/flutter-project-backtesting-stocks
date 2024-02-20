import 'package:flutter/material.dart';
import 'package:scouting/models/todo.dart';
import 'package:scouting/stock_page.dart';
import 'package:scouting/widgets/transitionpage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scouting/provider/function.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          FunctionStock.parseJsonNameFromAssets('assets/stockjson/stocks.json'),
      builder: (BuildContext context, AsyncSnapshot<List<StockName>> snapshot) {
        if (snapshot.hasData) {
          return buildStockList(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildStockList(List<StockName> data) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.menu,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search(data));
            },
            icon: Icon(
              Icons.search,
              size: 25,
            ),
          )
        ],
        centerTitle: true,
        title: Text('Ações'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return buildStockListItem(data[index]);
        },
      ),
    );
  }

  Widget buildStockListItem(StockName stock) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        if (stock.name == "DOLFUT")
          IconSlideAction(
            caption: 'M5',
            color: Colors.black45,
            icon: Icons.event,
            onTap: () {
              String assetsPath = 'assets/stockjson/M5/${stock.name}.json';
              navigateToStockPage(stock.name, assetsPath);
            },
          )
      ],
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(0, 29, 45, 0.8),
                Color.fromRGBO(0, 29, 45, 1),
              ],
            ),
          ),
          child: ListTile(
            leading: Hero(
              tag: stock.name,
              child: CircleAvatar(
                radius: 30.0,
                child: ClipOval(
                  child: Image(
                    image: AssetImage('assets/images/BOV_${stock.name}.png'),
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            title: Center(
              child: Text(
                stock.name,
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            onTap: () {
              String assetsPath = 'assets/stockjson/${stock.name}.json';
              navigateToStockPage(stock.name, assetsPath);
            },
          ),
        ),
      ),
    );
  }

  void navigateToStockPage(String stockName, String assetsPath) {
    Navigator.push(
      context,
      TransitionPageRoute(
        page: StockPage(stockname: stockName, assetsPath: assetsPath),
      ),
    );
  }
}

class Search extends SearchDelegate<String> {
  final List<StockName> stockList;

  Search(this.stockList);

  List<StockName> get recentList => [
        StockName(name: "VALE3"),
        StockName(name: "ITUB4"),
      ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentList
        : stockList
            .where((stock) =>
                stock.name.toUpperCase().contains(query.toUpperCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final stock = suggestionList[index];
        return ListTile(
          title: Text(stock.name),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            String assetsPath = 'assets/stockjson/${stock.name}.json';
            Navigator.push(
              context,
              TransitionPageRoute(
                page: StockPage(stockname: stock.name, assetsPath: assetsPath),
              ),
            );
          },
        );
      },
    );
  }
}
