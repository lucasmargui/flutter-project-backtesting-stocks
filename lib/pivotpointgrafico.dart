import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scouting/models/todo.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PivotPointGraficoPage extends StatefulWidget {
  PivotPointGraficoPage({
    @required this.stocks,
    @required this.stockname,
    @required this.pivotevent,
    @required this.pivotpoint,
  });

  final List<Stock> stocks;
  final String stockname;
  final PivotPointData pivotevent;
  final List<PivotPointData> pivotpoint;

  @override
  _PivotPointGraficoPageState createState() => _PivotPointGraficoPageState(
      stocks: stocks,
      stockname: stockname,
      pivotevent: pivotevent,
      pivotpoint: pivotpoint);
}

class _PivotPointGraficoPageState extends State<PivotPointGraficoPage> {
  final List<Stock> stocks;
  final String stockname;
  final PivotPointData pivotevent;
  final List<PivotPointData> pivotpoint;

  _PivotPointGraficoPageState({
    @required this.stocks,
    @required this.stockname,
    @required this.pivotevent,
    @required this.pivotpoint,
  });

  List<Stock> data = [];

  @override
  void initState() {
    super.initState();
    data = generateData();
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

  DateTime getinterval() {
    double intervalo =
        data.last.datetime.difference(data[0].datetime).inDays / 2;
    DateTime newDate = data[0].datetime.add(Duration(days: intervalo.toInt()));
    return newDate;
  }

  List<Stock> generateData() {
    try {
      List<Stock> list = [];

      int indexof = stocks.indexOf(pivotevent.stock);
      int start = indexof - 2;

      for (int i = 0; i < 2; i++) {
        list.add(stocks[start + i]);
      }

      for (int i = 0; i < 3; i++) {
        list.add(stocks[indexof + i]);
      }

      print(list);

      return list;
    } catch (e) {
      print(e);
      throw Exception("Error on server");
    }
  }

  _buildChart(BuildContext context) {
    return Container(
      height: 400,
      child: SfCartesianChart(
        annotations: <CartesianChartAnnotation>[
          CartesianChartAnnotation(
              widget: Container(
                  padding: EdgeInsets.only(right: 0),
                  child: Text(
                    'R3',
                    style: TextStyle(color: Colors.red[300]),
                  )),
              coordinateUnit: CoordinateUnit.point,
              x: pivotevent.stock.datetime,
              y: pivotevent.pivotpoint.r3),
          CartesianChartAnnotation(
              widget: Container(
                  padding: EdgeInsets.only(right: 0),
                  child: Text(
                    'R2',
                    style: TextStyle(color: Colors.red[200]),
                  )),
              coordinateUnit: CoordinateUnit.point,
              x: pivotevent.stock.datetime,
              y: pivotevent.pivotpoint.r2),
          CartesianChartAnnotation(
              widget: Container(
                  padding: EdgeInsets.only(right: 0),
                  child: Text(
                    'R1',
                    style: TextStyle(color: Colors.red[100]),
                  )),
              coordinateUnit: CoordinateUnit.point,
              x: pivotevent.stock.datetime,
              y: pivotevent.pivotpoint.r1),
          CartesianChartAnnotation(
              widget: Container(
                  padding: EdgeInsets.only(right: 0),
                  child: Text(
                    'S1',
                    style: TextStyle(color: Colors.blue[100]),
                  )),
              coordinateUnit: CoordinateUnit.point,
              x: pivotevent.stock.datetime,
              y: pivotevent.pivotpoint.s1),
          CartesianChartAnnotation(
              widget: Container(
                  padding: EdgeInsets.only(right: 0),
                  child: Text(
                    'S2',
                    style: TextStyle(color: Colors.blue[200]),
                  )),
              coordinateUnit: CoordinateUnit.point,
              x: pivotevent.stock.datetime,
              y: pivotevent.pivotpoint.s2),
          CartesianChartAnnotation(
              widget: Container(
                  padding: EdgeInsets.only(right: 0),
                  child: Text(
                    'S3',
                    style: TextStyle(color: Colors.blue[300]),
                  )),
              coordinateUnit: CoordinateUnit.point,
              x: pivotevent.stock.datetime,
              y: pivotevent.pivotpoint.s3),
          CartesianChartAnnotation(
            widget: Container(
              child: Text(
                '$stockname',
                style: TextStyle(
                    color: Color.fromRGBO(216, 225, 227, 0.15),
                    fontWeight: FontWeight.bold,
                    fontSize: 80),
              ),
            ),
            coordinateUnit: CoordinateUnit.point,
            region: AnnotationRegion.chart,
            x: getinterval(),
            y: (getmax(data) + getmin(data)) / 2,
          )
        ],
        // tooltipBehavior: TooltipBehavior(enable: true, shared: true),
        zoomPanBehavior: ZoomPanBehavior(
            enableDoubleTapZooming: true,
            enablePinching: true,
            // Enables the selection zooming
            enableSelectionZooming: true),
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(
          minimum: getmin(data),
          maximum: getmax(data) * 0.10 + getmax(data),
          numberFormat: NumberFormat.currency(
            locale: 'pt-br',
            symbol: "R\$",
          ),
          title: AxisTitle(
            text: "",
          ),
        ),
        axes: [
          NumericAxis(
            name: "secondyaxis",
            opposedPosition: true,
          )
        ],
        indicators: <TechnicalIndicators<dynamic, dynamic>>[],
        series: <ChartSeries>[
          HiloOpenCloseSeries<Stock, dynamic>(
              enableTooltip: true,
              dataSource: data,
              bullColor: Colors.green,
              xValueMapper: (Stock stock, _) => stock.datetime,
              lowValueMapper: (Stock stock, _) => stock.low,
              highValueMapper: (Stock stock, _) => stock.high,
              openValueMapper: (Stock stock, _) => stock.open,
              closeValueMapper: (Stock stock, _) => stock.close,
              name: "Stock")
        ],
      ),
    );
  }

  _buildPageChart(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildChart(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.menu,
      ),
      body: _buildPageChart(context),
    );
  }
}
