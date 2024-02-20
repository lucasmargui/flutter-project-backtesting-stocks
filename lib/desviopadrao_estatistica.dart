import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scouting/deviopadrao_grafico.dart';
import 'package:scouting/models/todo.dart';

class DesvioEstatisticaPage extends StatefulWidget {
  DesvioEstatisticaPage({
    @required this.stockname,
    @required this.stocks,
    @required this.desvio,
    @required this.periodo,
  });

  final String stockname;
  final List<Stock> stocks;
  final int desvio;
  final int periodo;

  @override
  _DesvioEstatisticaPageState createState() => _DesvioEstatisticaPageState(
      stockname: stockname, stocks: stocks, desvio: desvio, periodo: periodo);
}

class _DesvioEstatisticaPageState extends State<DesvioEstatisticaPage> {
  String stockname;
  List<Stock> stocks;
  final int desvio;
  final int periodo;
  bool variacao = false;

  List<DesvioEstrategyData> bollingerpointsevent = [];
  List<DesvioEstrategyData> databollingerpointsevent = [];
  Map<String, dynamic> resultadoestatistica;

  final scaffoldState = GlobalKey<ScaffoldState>();

  _DesvioEstatisticaPageState({
    @required this.stockname,
    @required this.stocks,
    @required this.desvio,
    @required this.periodo,
  });

  RangeValues selectedRange;
  int divisions;
  int rangeano;

  @override
  void initState() {
    setState(() {
      bollingerpointsevent = prepareData();
      databollingerpointsevent = bollingerpointsevent;
      resultadoestatistica = estatisticaData();
      selectedRange = RangeValues(stocks[0].datetime.year.toDouble(),
          stocks.last.datetime.year.toDouble());
      divisions = stocks.last.datetime.year - stocks[0].datetime.year;
      rangeano = stocks.last.datetime.year - stocks[0].datetime.year;
    });
    super.initState();
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  List<DesvioEstrategyData> prepareData() {
    //prepare data

    if (stocks.isNotEmpty && stocks.length >= periodo && periodo > 0) {
      num sum = 0;
      num deviationSum = 0;
      final num multiplier = desvio;
      final num limit = stocks.length;
      final num length = periodo.round();
      // ignore: deprecated_member_use
      final List<num> smaPoints = List<num>(limit);
      // ignore: deprecated_member_use
      final List<num> deviations = List<num>(limit);
      final List<DesvioEstrategyData> bollingerPoints = [];
      final List<DesvioEstrategyData> filteredbollingerPoints = [];

      for (int i = 0; i < length; i++) {
        sum += stocks[i].close ?? 0;
      }
      num sma = sum / periodo;
      for (int i = 0; i < limit; i++) {
        final num y = stocks[i].close ?? 0;
        if (i >= length - 1 && i < limit) {
          if (i - periodo >= 0) {
            final num diff = y - stocks[i - length].close;
            sum = sum + diff;
            sma = sum / (periodo);
            smaPoints[i] = sma;
            deviations[i] = pow(y - sma, 2);
            deviationSum += deviations[i] - deviations[i - length];
          } else {
            smaPoints[i] = sma;
            deviations[i] = pow(y - sma, 2);
            deviationSum += deviations[i];
          }
          final num range = sqrt(deviationSum / (periodo));
          final num lowerBand = smaPoints[i] - (multiplier * range);
          final num upperBand = smaPoints[i] + (multiplier * range);
          if (i + 1 == length) {
            for (int j = 0; j < length - 1; j++) {
              // print("Dentro do for $j");

            }
          }

          bollingerPoints.add(DesvioEstrategyData(
            index: i,
            stock: stocks[i],
            midBand: smaPoints[i],
            lowBand: lowerBand,
            upBand: upperBand,
          ));
        } else {
          if (i < periodo - 1) {
            smaPoints[i] = sma;
            deviations[i] = pow(y - sma, 2);
            deviationSum += deviations[i];
          }
        }
      }

      // bollingerPoints.forEach((element) {
      //   print("datetime:${element.datetime.day}");
      //   print("upband:${element.upBand}");
      //   print("midband:${element.midBand}");
      //   print("lowband:${element.lowBand}");
      // });

      for (int i = 1; i < bollingerPoints.length; i++) {
        if (
            // (bollingerPoints[i].stock.close > bollingerPoints[i].upBand && bollingerPoints[i - 1].stock.close < bollingerPoints[i - 1].upBand)
            (bollingerPoints[i].stock.close > bollingerPoints[i].upBand) ||
                // (bollingerPoints[i].stock.close < bollingerPoints[i].lowBand && bollingerPoints[i - 1].stock.close > bollingerPoints[i - 1].lowBand)
                (bollingerPoints[i].stock.close < bollingerPoints[i].lowBand)) {
          filteredbollingerPoints.add(bollingerPoints[i]);
        }
      }

      print(
          "quantidade bollingerpointseventos:${filteredbollingerPoints.length}");
      return filteredbollingerPoints;
    }

    return null;
  }

  Map<String, dynamic> estatisticaData() {
    Map estatisticaUpBand = {
      "eventsBandTotal": 0,
      "cpA": 0,
      "cpAA": 0,
      "cpAAA": 0,
      "cpAB": 0,
      "cpAAB": 0,
      "cpABB": 0,
      "cpABA": 0,
      "cpB": 0,
      "cpBB": 0,
      "cpBBB": 0,
      "cpBA": 0,
      "cpBBA": 0,
      "cpBAA": 0,
      "cpBAB": 0,
    };

    Map estatisticaLowBand = {
      "eventsBandTotal": 0,
      "cpA": 0,
      "cpAA": 0,
      "cpAAA": 0,
      "cpAB": 0,
      "cpAAB": 0,
      "cpABB": 0,
      "cpABA": 0,
      "cpB": 0,
      "cpBB": 0,
      "cpBBB": 0,
      "cpBA": 0,
      "cpBBA": 0,
      "cpBAA": 0,
      "cpBAB": 0,
    };

    for (int i = 1; i < databollingerpointsevent.length; i++) {
      if (databollingerpointsevent[i].index + 3 < stocks.length) {
        Stock proxcandle1 = stocks[databollingerpointsevent[i].index + 1];
        Stock proxcandle2 = stocks[databollingerpointsevent[i].index + 2];
        Stock proxcandle3 = stocks[databollingerpointsevent[i].index + 3];
        String key = "";
        if (databollingerpointsevent[i].stock.close >
            databollingerpointsevent[i].upBand) {
          estatisticaUpBand["eventsBandTotal"] += 1;

          if (proxcandle1.close > proxcandle1.open) {
            key += "A";
            estatisticaUpBand["cp$key"] += 1;
          } else {
            key += "B";
            estatisticaUpBand["cp$key"] += 1;
          }

          if (proxcandle2.close > proxcandle2.open) {
            key += "A";
            estatisticaUpBand["cp$key"] += 1;
          } else {
            key += "B";
            estatisticaUpBand["cp$key"] += 1;
          }

          if (proxcandle3.close > proxcandle3.open) {
            key += "A";
            estatisticaUpBand["cp$key"] += 1;
          } else {
            key += "B";
            estatisticaUpBand["cp$key"] += 1;
          }
        } else if (databollingerpointsevent[i].stock.close <
            databollingerpointsevent[i].lowBand) {
          estatisticaLowBand["eventsBandTotal"] += 1;
          if (proxcandle1.close > proxcandle1.open) {
            key += "A";
            estatisticaLowBand["cp$key"] += 1;
          } else {
            key += "B";
            estatisticaLowBand["cp$key"] += 1;
          }

          if (proxcandle2.close > proxcandle2.open) {
            key += "A";
            estatisticaLowBand["cp$key"] += 1;
          } else {
            key += "B";
            estatisticaLowBand["cp$key"] += 1;
          }

          if (proxcandle3.close > proxcandle3.open) {
            key += "A";
            estatisticaLowBand["cp$key"] += 1;
          } else {
            key += "B";
            estatisticaLowBand["cp$key"] += 1;
          }
        } else {
          print("pq ta caindo aqui");
        }
      }
    }

    print("EstatisticaUpBand");
    print(estatisticaUpBand);
    print("////////////////");
    print("////////////////");
    print("EstatisticaLowBand");
    print(estatisticaLowBand);

    Map<String, dynamic> estatisticaband = {
      "estatisticaUpBand": estatisticaUpBand,
      "estatisticaLowBand": estatisticaLowBand
    };

    return estatisticaband;
  }

  _buildPadroesGraficos(band) {
    return Column(
      children: [
        Text("Dia seguinte",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Container(
                  height: 60,
                  width: 20,
                  color: Colors.green,
                ),
                Text("${band["cpA"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 60,
                  width: 20,
                  color: Colors.red,
                ),
                Text("${band["cpB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            )
          ],
        ),
        SizedBox(height: 30),
        Text("Dia 2",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 15,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 45,
                      width: 15,
                      color: Colors.green,
                    ),
                  ],
                ),
                Text("${band["cpAA"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 15,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 45,
                      width: 15,
                      color: Colors.red,
                    ),
                  ],
                ),
                Text("${band["cpAB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 15,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 45,
                      width: 15,
                      color: Colors.green,
                    ),
                  ],
                ),
                Text("${band["cpBA"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 15,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 45,
                      width: 15,
                      color: Colors.red,
                    ),
                  ],
                ),
                Text("${band["cpBB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            )
          ],
        ),
        SizedBox(height: 30),
        Text("Dia 3",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                  ],
                ),
                Text("${band["cpAAA"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                  ],
                ),
                Text("${band["cpAAB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                  ],
                ),
                Text("${band["cpABA"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                  ],
                ),
                Text("${band["cpABB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                  ],
                ),
                Text("${band["cpBBA"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                  ],
                ),
                Text("${band["cpBAB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.green,
                    ),
                  ],
                ),
                Text("${band["cpBAA"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.red,
                    ),
                  ],
                ),
                Text("${band["cpBBB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            )
          ],
        ),
      ],
    );
  }

  _buildCardEstatistica(
      BuildContext context, Map<String, dynamic> dataestatistica) {
    return Card(
      child: new Container(
        color: AppColors.primary,
        padding: new EdgeInsets.all(16.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Desvio Padrão",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white)),
            Text(
              "Padrões dos 3 dias seguintes",
              style: TextStyle(color: AppColors.white),
            ),
            Text(
              "Range",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            RangeSlider(
              labels:
                  RangeLabels('${selectedRange.start}', '${selectedRange.end}'),
              min: stocks[0].datetime.year.toDouble(),
              max: stocks.last.datetime.year.toDouble(),
              divisions: divisions,
              values: selectedRange,
              onChanged: (RangeValues value) {
                setState(() {
                  selectedRange = value;
                  rangeano = (value.end - value.start).toInt();

                  databollingerpointsevent = bollingerpointsevent
                      .where((e) =>
                          e.stock.datetime.year >=
                              selectedRange.start.toInt() &&
                          e.stock.datetime.year <= selectedRange.end.toInt())
                      .toList();
                  print(databollingerpointsevent.length);
                  resultadoestatistica = estatisticaData();
                });
              },
            ),
            SizedBox(height: 30),
            Text(
              "Fechamento acima do desvio",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            Text("${dataestatistica["estatisticaUpBand"]["eventsBandTotal"]}",
                style: TextStyle(color: AppColors.white)),
            SizedBox(height: 30),
            _buildPadroesGraficos(dataestatistica["estatisticaUpBand"]),
            SizedBox(height: 30),
            SizedBox(height: 30),
            Text(
              "Fechamento abaixo do desvio",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            Text("${dataestatistica["estatisticaLowBand"]["eventsBandTotal"]}",
                style: TextStyle(color: AppColors.white)),
            SizedBox(height: 30),
            _buildPadroesGraficos(dataestatistica["estatisticaLowBand"])
          ],
        ),
      ),
    );
  }

  _buildListViewEventos(BuildContext context) {
    return databollingerpointsevent.length == 0
        ? Center(
            child: Text(
            'Nenhum evento registrado',
            style: TextStyle(color: AppColors.white, fontSize: 25),
          ))
        : ListView.builder(
            itemCount: databollingerpointsevent.length,
            itemBuilder: (context, index) {
              double upBand =
                  roundDouble(databollingerpointsevent[index].upBand, 2);
              double lowBand =
                  roundDouble(databollingerpointsevent[index].lowBand, 2);
              return index == 0
                  ? _buildCardEstatistica(context, resultadoestatistica)
                  : Card(
                      child: Container(
                        decoration: new BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromRGBO(0, 29, 45, 0.5),
                                Color.fromRGBO(0, 29, 45, 1)
                              ]),
                        ),
                        child: ListTile(
                          leading: ClipOval(
                            child: Image(
                                image: AssetImage('assets/icon/candle.jpg')),
                          ),
                          title: Text(
                              "Data:  ${databollingerpointsevent[index].stock.datetime.day}/${databollingerpointsevent[index].stock.datetime.month}/${databollingerpointsevent[index].stock.datetime.year}",
                              style: TextStyle(
                                  fontSize: 20.0, color: AppColors.white)),
                          subtitle: bollingerpointsevent[index].stock.close >
                                  bollingerpointsevent[index].upBand
                              ? Text(
                                  "Preço R\$\:${databollingerpointsevent[index].stock.close} > Desvio Superior R\$\:$upBand",
                                  style: TextStyle(color: AppColors.white))
                              : Text(
                                  "Preço R\$\:${databollingerpointsevent[index].stock.close} < Desvio Inferior R\$\:$lowBand",
                                  style: TextStyle(color: AppColors.white)),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => DesvioGraficoPage(
                                    desvioevent:
                                        databollingerpointsevent[index],
                                    desvio: desvio,
                                    periodo: periodo,
                                    stocks: stocks,
                                    stockname: stockname),
                                transitionsBuilder: (c, anim, a2, child) =>
                                    FadeTransition(opacity: anim, child: child),
                                transitionDuration: Duration(milliseconds: 400),
                              ),
                            );
                          },
                        ),
                      ),
                    );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      key: scaffoldState,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
      ),
      body: _buildListViewEventos(context),
    );
  }
}
