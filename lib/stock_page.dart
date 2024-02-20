import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:scouting/desviopadrao_page.dart';
import 'package:scouting/estrategias_page.dart';
import 'package:scouting/models/todo.dart';
import 'package:scouting/pivotpointestatistica.dart';
import 'package:scouting/provider/function.dart';
import 'package:scouting/variacao_page.dart';
import 'package:scouting/tendencia_page.dart';
import 'package:scouting/forca_page.dart';

class StockPage extends StatefulWidget {
  StockPage({
    @required this.stockname,
    @required this.assetsPath,
  });

  final String stockname;
  final String assetsPath;

  @override
  _StockPageState createState() =>
      _StockPageState(stockname: stockname, assetsPath: assetsPath);
}

class _StockPageState extends State<StockPage>
    with SingleTickerProviderStateMixin {
  _StockPageState({
    @required this.stockname,
    @required this.assetsPath,
  });
  final String stockname;
  final String assetsPath;

  List<Stock> data;

  TabController tabController;

  //  HttpService httpService = HttpService();
  String url;

  void initState() {
    super.initState();
    // url = HttpService.getUrl(stockname);
    FunctionStock.parseJsonFrom(assetsPath).then((stocks) {
      setState(() {
        _widgetOptions = [
          EstrategiasPage(stockname: stockname, stocks: stocks),
          VariacaoPage(stockname: stockname, stocks: stocks),
          TendenciaPage(stockname: stockname, stocks: stocks),
          PivotPointPage(stockname: stockname, stocks: stocks),
          DesvioPadraoPage(stockname: stockname, stocks: stocks),
          ForcaPage(stockname: stockname, stocks: stocks)
        ];
      });
    });
  }

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.menu,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: stockname,
              child: Image.asset(
                'assets/images/BOV_$stockname.png',
                fit: BoxFit.contain,
                height: 32,
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text('$stockname'))
          ],
        ),
      ),
      body: _widgetOptions.isNotEmpty
          ? SafeArea(
              child: Center(
                  child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
            )))
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.black,
        backgroundColor: AppColors.primary,
        height: 50,
        animationCurve: Curves.fastOutSlowIn,
        items: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_chart,
                size: 30,
                color: AppColors.white,
              ),
              Text(
                'Estratégia',
                style: TextStyle(color: AppColors.white, fontSize: 10),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                size: 30,
                color: AppColors.white,
              ),
              Text(
                'Variação',
                style: TextStyle(color: AppColors.white, fontSize: 10),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                size: 30,
                color: AppColors.white,
              ),
              Text(
                'Tendência',
                style: TextStyle(color: AppColors.white, fontSize: 10),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                size: 30,
                color: AppColors.white,
              ),
              Text(
                'Pivot',
                style: TextStyle(color: AppColors.white, fontSize: 10),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                size: 30,
                color: AppColors.white,
              ),
              Text(
                'Desvio',
                style: TextStyle(color: AppColors.white, fontSize: 10),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                size: 30,
                color: AppColors.white,
              ),
              Text(
                'Força',
                style: TextStyle(color: AppColors.white, fontSize: 10),
              )
            ],
          )
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
