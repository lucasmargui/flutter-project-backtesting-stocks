import 'dart:math';

import 'package:flutter/material.dart';

import 'package:scouting/models/todo.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ForcaPage extends StatefulWidget {
  ForcaPage({
    @required this.stockname,
    @required this.stocks,
  });

  final String stockname;
  final List<Stock> stocks;

  @override
  _ForcaPageState createState() =>
      _ForcaPageState(stockname: stockname, stocks: stocks);
}

class _ForcaPageState extends State<ForcaPage> {
  String stockname;
  List<Stock> stocks;

  _ForcaPageState({
    @required this.stockname,
    @required this.stocks,
  });

  List<Stock> candles;

  RangeValues selectedRange;
  int divisions;
  int rangeano;

  List meses = [
    '',
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ];

  @override
  void initState() {
    super.initState();
    print(stocks[0].datetime.year.toDouble());
    print(stocks.last.datetime.year.toDouble());
    setState(() {
      selectedRange = RangeValues(stocks[0].datetime.year.roundToDouble(),
          stocks.last.datetime.year.roundToDouble());
      divisions = stocks.last.datetime.year - stocks[0].datetime.year;
      rangeano = stocks.last.datetime.year - stocks[0].datetime.year;
      candles = stocks;
    });
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Map<String, List<SazonalidadeForca>> generateDiasFortes() {
    int ano = candles[0].datetime.year;

    Map<num, double> sazonalidademesesnegativos = {
      1: 0.0,
      2: 0.0,
      3: 0.0,
      4: 0.0,
      5: 0.0,
      6: 0.0,
      7: 0.0,
      8: 0.0,
      9: 0.0,
      10: 0.0,
      11: 0.0,
      12: 0.0,
    };

    Map<num, double> sazonalidademesespositivos = {
      1: 0.0,
      2: 0.0,
      3: 0.0,
      4: 0.0,
      5: 0.0,
      6: 0.0,
      7: 0.0,
      8: 0.0,
      9: 0.0,
      10: 0.0,
      11: 0.0,
      12: 0.0,
    };
    try {
      print("ano inicial $ano");
      print("anos $rangeano");

      for (int i = 0; i <= rangeano; i++) {
        List<Stock> filteredporano =
            candles.where((e) => e.datetime.year == ano).toList();
        for (int j = 1; j <= 12; j++) {
          List<Stock> filteredpormes =
              filteredporano.where((e) => e.datetime.month == j).toList();
          filteredpormes.forEach((e) {
            if (e.close > e.open) {
              sazonalidademesespositivos[j] += 1;
            } else {
              sazonalidademesesnegativos[j] += 1;
            }
          });
        }

        ano++;
      }

      List<SazonalidadeForca> sazonalidadenegativalist = [];
      List<SazonalidadeForca> sazonalidadepositivalist = [];

      sazonalidademesesnegativos.forEach((k, v) {
        return sazonalidadenegativalist.add(SazonalidadeForca(meses[k], v));
      });

      sazonalidademesespositivos.forEach((k, v) {
        return sazonalidadepositivalist.add(SazonalidadeForca(meses[k], v));
      });

      Map<String, List<SazonalidadeForca>> sazonalidade = {
        "sazonalidadenegativas": sazonalidadenegativalist,
        "sazonalidadepositivas": sazonalidadepositivalist
      };

      print(sazonalidade);
      return sazonalidade;
    } catch (e) {
      print(e);
      throw Exception("Error on server");
    }
  }

  _buildEstatistica(BuildContext context) {
    Map<String, List<SazonalidadeForca>> data = generateDiasFortes();

    final List<Color> color = <Color>[];
    color.add(Colors.green[50]);
    color.add(Colors.green[200]);
    color.add(Colors.green);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);

    return Container(
        height: 400,
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            enableSideBySideSeriesPlacement: false,
            series: <ChartSeries>[
              AreaSeries<SazonalidadeForca, dynamic>(
                  gradient: gradientColors,
                  dataSource: data["sazonalidadepositivas"],
                  xValueMapper: (SazonalidadeForca sazonal, _) => sazonal.month,
                  yValueMapper: (SazonalidadeForca sazonal, _) =>
                      sazonal.qtddias),
            ]));
  }

  _buildPageMain(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Soma dos dias positivos de cada mês respectivo pelo intervalo de datas",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "Range",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        RangeSlider(
          labels: RangeLabels('${selectedRange.start}', '${selectedRange.end}'),
          min: stocks[0].datetime.year.toDouble(),
          max: stocks.last.datetime.year.toDouble(),
          divisions: divisions,
          values: selectedRange,
          onChanged: (RangeValues value) {
            setState(() {
              selectedRange = RangeValues(
                  value.start.roundToDouble(), value.end.roundToDouble());
              candles = stocks
                  .where((e) =>
                      e.datetime.year >= selectedRange.start.toInt() &&
                      e.datetime.year <= selectedRange.end.toInt())
                  .toList();
              rangeano = (value.end - value.start).toInt();
            });
          },
        ),
        _buildEstatistica(context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: _buildPageMain(context),
    );
  }
}

class SazonalidadeForca {
  SazonalidadeForca(this.month, this.qtddias);
  final String month;
  final double qtddias;
}
