import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scouting/models/todo.dart';
import 'package:scouting/widgets/swipebutton.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TendenciaPage extends StatefulWidget {
  TendenciaPage({
    @required this.stockname,
    @required this.stocks,
  });

  final String stockname;
  final List<Stock> stocks;

  @override
  _TendenciaPageState createState() =>
      _TendenciaPageState(stockname: stockname, stocks: stocks);
}

class _TendenciaPageState extends State<TendenciaPage> {
  DateTime dtstart;
  DateTime dtend;
  String stockname;
  List<Stock> stocks;
  bool variacao = false;
  Future<List<Stock>> stocksporano;

  _TendenciaPageState({
    @required this.stockname,
    @required this.stocks,
  });

  @override
  void initState() {
    super.initState();
    dtstart = stocks[0].datetime;
    List<Stock> filtered = stocks
        .where((e) => e.datetime.year == stocks[0].datetime.year)
        .toList();
    stocksporano = generateDataPorAno(filtered, variacao);
  }

  double getmin(List<Stock> candles) {
    List<int> values = candles.map((Stock candle) {
      return (candle.low).toInt();
    }).toList();

    double lowclose = values.reduce(min).toDouble();

    return lowclose;
  }

  double getmax(List<Stock> candles) {
    List<int> values = candles.map((Stock candle) {
      return (candle.high).round();
    }).toList();

    double highclose = values.reduce(max).toDouble();

    return highclose;
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future<List<Stock>> generateDataPorAno(List<Stock> candles, bool v) async {
    try {
      Stock lastclose = candles.last;
      double variacaonominal = lastclose.close - candles[0].close;
      double mediavariacaonominal =
          v ? roundDouble((variacaonominal / candles.length), 2) : 0.0;
      double basemedia = mediavariacaonominal;

      List<Stock> list = candles.map((Stock stock) {
        double open;
        double high;
        double low;
        double close;
        Stock candle;

        if (stock.close > stock.open) {
          high = stock.close - roundDouble((basemedia), 2);
          close = stock.close - roundDouble((basemedia), 2);
          low = stock.open - roundDouble((basemedia), 2);
          open = stock.open - roundDouble((basemedia), 2);
        } else {
          high = stock.open - roundDouble((basemedia), 2);
          close = stock.close - roundDouble((basemedia), 2);
          low = stock.close - roundDouble((basemedia), 2);
          open = stock.open - roundDouble((basemedia), 2);
        }

        candle = Stock(
          open: open,
          high: high,
          low: low,
          close: close,
          volume: stock.volume,
          datetime: stock.datetime,
        );

        basemedia += mediavariacaonominal;
        return candle;
      }).toList();

      return list;
    } catch (e) {
      print(e);
      throw Exception("Error on server");
    }
  }

  void handleReadOnlyInputClick(context, List<Stock> candles) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: YearPicker(
                selectedDate: candles.last.datetime,
                firstDate: stocks[0].datetime,
                lastDate: stocks.last.datetime,
                onChanged: (val) {
                  print(val);
                  setState(() {
                    dtstart = val;
                    List<Stock> filtered = stocks
                        .where((e) => e.datetime.year == val.year)
                        .toList();
                    stocksporano = generateDataPorAno(filtered, variacao);
                  });
                  Navigator.pop(context);
                },
              ),
            ));
  }

  _botaoDataPicker(List<Stock> candles) {
    return TextFormField(
      readOnly: true,
      style: TextStyle(fontSize: 13.0, color: Colors.white),
      decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 13.0),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Pick Year',
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today)),
      onTap: () => handleReadOnlyInputClick(context, candles),
    );
  }

  _buildChart(BuildContext context, List<Stock> candles) {
    return Container(
      height: 380,
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
            enableDoubleTapZooming: true,
            enablePinching: true,
            enableSelectionZooming: true),
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(
          minimum: getmin(candles),
          maximum: getmax(candles),
          numberFormat: NumberFormat.currency(
            locale: 'pt-br',
            symbol: "R\$",
          ),
          title: AxisTitle(
            text: "",
          ),
        ),
        axes: [],
        indicators: <TechnicalIndicators<Stock, dynamic>>[],
        series: <ChartSeries>[
          HiloOpenCloseSeries<Stock, dynamic>(
              enableTooltip: true,
              dataSource: candles,
              xValueMapper: (Stock stock, _) => stock.datetime,
              lowValueMapper: (Stock stock, _) => stock.low,
              highValueMapper: (Stock stock, _) => stock.high,
              openValueMapper: (Stock stock, _) => stock.open,
              closeValueMapper: (Stock stock, _) => stock.close,
              volumeValueMapper: (Stock stock, _) => stock.volume,
              name: "Stock")
        ],
      ),
    );
  }

  swipeFunction(SwipePosition position) async {
    if (position == SwipePosition.SwipeRight) {
      setState(() {
        variacao = true;
        List<Stock> filtered =
            stocks.where((e) => e.datetime.year == dtstart.year).toList();
        stocksporano = generateDataPorAno(filtered, true);
      });
    } else {
      setState(() {
        variacao = false;
        List<Stock> filtered =
            stocks.where((e) => e.datetime.year == dtstart.year).toList();
        stocksporano = generateDataPorAno(filtered, false);
      });
    }
  }

  _buildSwipeButton(BuildContext context) {
    return SwipeDemoApp(function: swipeFunction);
  }

  _buildPageMain(BuildContext context, List<Stock> candles) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSwipeButton(context),
        Text(
          "${dtstart.year}",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        _botaoDataPicker(candles),
        _buildChart(context, candles)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: FutureBuilder(
        future: stocksporano,
        builder: (BuildContext context, AsyncSnapshot<List<Stock>> snapshot) {
          if (snapshot.hasData) {
            return _buildPageMain(context, snapshot.data);
          } else {
            return Column(
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
