import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scouting/models/todo.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class DesvioGraficoPage extends StatefulWidget {
  DesvioGraficoPage({
    @required this.stocks,
    @required this.desvioevent,
    @required this.desvio,
    @required this.periodo,
    @required this.stockname,
  });

  final DesvioEstrategyData desvioevent;
  final int desvio;
  final int periodo;
  final List<Stock> stocks;
  final String stockname;

  @override
  _DesvioGraficoPageState createState() => _DesvioGraficoPageState(
      desvioevent: desvioevent,
      desvio: desvio,
      periodo: periodo,
      stocks: stocks,
      stockname: stockname);
}

class _DesvioGraficoPageState extends State<DesvioGraficoPage> {
  final DesvioEstrategyData desvioevent;
  final List<Stock> stocks;
  final String stockname;

  final int desvio;
  final int periodo;

  double upperLineWidth = 2;
  double lowerLineWidth = 2;

  _DesvioGraficoPageState({
    @required this.stocks,
    @required this.desvioevent,
    @required this.desvio,
    @required this.periodo,
    @required this.stockname,
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

      Stock eventstock =
          stocks.where((e) => e.datetime == desvioevent.stock.datetime).single;
      int indexof = stocks.indexOf(eventstock);
      int start = indexof - periodo;

      for (int i = 0; i < periodo; i++) {
        list.add(stocks[start + i]);
      }

      for (int i = 0; i < periodo; i++) {
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
                  child: const Text(
                'Evento',
                style: TextStyle(color: AppColors.white),
              )),
              coordinateUnit: CoordinateUnit.point,
              x: desvioevent.stock.datetime,
              y: desvioevent.stock.close),
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

        // legend: Legend(
        //   isResponsive: true
        // ),
        indicators: <TechnicalIndicators<dynamic, dynamic>>[
          BollingerBandIndicator<Stock, dynamic>(
              seriesName: "Stock",
              period: periodo,
              standardDeviation: desvio,
              upperLineWidth: upperLineWidth,
              lowerLineWidth: lowerLineWidth)
        ],

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
