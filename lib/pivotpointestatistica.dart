import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scouting/models/todo.dart';
import 'package:scouting/pivotpointgrafico.dart';

class PivotPointPage extends StatefulWidget {
  PivotPointPage({
    @required this.stockname,
    @required this.stocks,
  });

  final String stockname;
  final List<Stock> stocks;
  @override
  _PivotPointPageState createState() =>
      _PivotPointPageState(stockname: stockname, stocks: stocks);
}

class _PivotPointPageState extends State<PivotPointPage> {
  String stockname;
  List<Stock> stocks;

  List<PivotPointData> pivotpointsevent = [];
  List<PivotPointData> datapivotpointsevent = [];
  Map<String, dynamic> resultadoestatistica = {
    "high": {"r3": 0, "r2": 0, "r1": 0, "pivot": 0},
    "low": {"pivot": 0, "s1": 0, "s2": 0, "s3": 0},
    "close": {"r3": 0, "r2": 0, "r1": 0, "pivot": 0, "s1": 0, "s2": 0, "s3": 0},
    "diaseguinte": {
      "r3": {"alta": 0, "baixa": 0},
      "r2": {"alta": 0, "baixa": 0},
      "r1": {"alta": 0, "baixa": 0},
      "pivot": {"alta": 0, "baixa": 0},
      "s1": {"alta": 0, "baixa": 0},
      "s2": {"alta": 0, "baixa": 0},
      "s3": {"alta": 0, "baixa": 0}
    }
  };

  final scaffoldState = GlobalKey<ScaffoldState>();

  _PivotPointPageState({
    @required this.stockname,
    @required this.stocks,
  });

  RangeValues selectedRange;
  int divisions;
  int rangeano;

  @override
  void initState() {
    setState(() {
      pivotpointsevent = prepareData();
      datapivotpointsevent = pivotpointsevent;

      selectedRange = RangeValues(stocks[0].datetime.year.toDouble(),
          stocks.last.datetime.year.toDouble());
      var sub = stocks.last.datetime.year - stocks[0].datetime.year;
      divisions = sub > 0 ? sub : 1;
      rangeano = sub > 0 ? sub : 1;
    });
    estatisticaData(datapivotpointsevent).then((value) => setState(() {
          resultadoestatistica = value;
        }));
    super.initState();
  }

  double roundDouble(double value, int places) {
    if (value == 0) {
      return 0.0;
    } else {
      double mod = pow(10.0, places);
      return ((value * mod).round().toDouble() / mod);
    }
  }

  double _porcentagemcalculo(value, total) {
    if (total == 0) {
      return roundDouble(((value / 1) * 100), 2);
    } else {
      return roundDouble(((value / total) * 100), 2);
    }
  }

  List<PivotPointData> prepareData() {
    //prepare data

    if (stocks.isNotEmpty) {
      final List<PivotPointData> pivotPoints = [];

      for (int i = 1; i < stocks.length; i++) {
        double pontopivot =
            (stocks[i - 1].high + stocks[i - 1].low + stocks[i - 1].close) / 3;
        double r1 = (2 * pontopivot) - stocks[i - 1].low;
        double s1 = (2 * pontopivot) - stocks[i - 1].high;

        double r2 = pontopivot + (r1 - s1);
        double s2 = pontopivot - (r1 - s1);

        double r3 = (pontopivot - s2) + r2;
        double s3 = pontopivot - (r2 - s2);
        // double r3 = (2*pontopivot) + (stocks[i-1].high - (2*stocks[i-1].low));
        // double s3 = (2*pontopivot) - ((2*stocks[i-1].high) - stocks[i-1].low);
        PivotPoint pivotpoint = PivotPoint(
            r3: r3, r2: r2, r1: r1, pivot: pontopivot, s1: s1, s2: s2, s3: s3);

        pivotPoints.add(
            PivotPointData(stock: stocks[i], pivotpoint: pivotpoint, index: i));
      }
      return pivotPoints;
    }

    return null;
  }

  Future<Map<String, Map<String, dynamic>>> estatisticaData(
      List<PivotPointData> listpoint) async {
    Map<String, Map<String, dynamic>> estatisticapivopoint = {
      "high": {"r3": 0, "r2": 0, "r1": 0, "pivot": 0},
      "low": {"pivot": 0, "s1": 0, "s2": 0, "s3": 0},
      "close": {
        "r3": 0,
        "r2": 0,
        "r1": 0,
        "pivot": 0,
        "s1": 0,
        "s2": 0,
        "s3": 0
      },
    };

    Map<String, Map<String, dynamic>> diaseguinte = {
      "r3": {"alta": 0, "baixa": 0},
      "r2": {"alta": 0, "baixa": 0},
      "r1": {"alta": 0, "baixa": 0},
      "pivot": {"alta": 0, "baixa": 0},
      "s1": {"alta": 0, "baixa": 0},
      "s2": {"alta": 0, "baixa": 0},
      "s3": {"alta": 0, "baixa": 0}
    };

    if (listpoint.isNotEmpty) {
      for (int i = 1; i < listpoint.length; i++) {
        Stock stock = listpoint[i].stock;
        PivotPoint pivotpoint = listpoint[i].pivotpoint;
        int posicaostock = listpoint[i].index;
        if (i + 1 < listpoint.length) {
          if (stock.close > pivotpoint.r1 && stock.close < pivotpoint.r2) {
            estatisticapivopoint["close"]["r1"] += 1;

            if (stocks[posicaostock + 1].close >
                stocks[posicaostock + 1].open) {
              diaseguinte["r1"]["alta"] += 1;
            } else {
              diaseguinte["r1"]["baixa"] += 1;
            }
            if (stock.high > pivotpoint.r3) {
              estatisticapivopoint["high"]["r2"] += 1;
              estatisticapivopoint["high"]["r3"] += 1;
            } else if (stock.high > pivotpoint.r2 &&
                stock.high < pivotpoint.r3) {
              estatisticapivopoint["high"]["r2"] += 1;
            }
          } else if (stock.close > pivotpoint.r2 &&
              stock.close < pivotpoint.r3) {
            estatisticapivopoint["close"]["r1"] += 1;
            estatisticapivopoint["close"]["r2"] += 1;
            if (stocks[posicaostock + 1].close >
                stocks[posicaostock + 1].open) {
              diaseguinte["r2"]["alta"] += 1;
            } else {
              diaseguinte["r2"]["baixa"] += 1;
            }
            if (stock.high > pivotpoint.r3) {
              estatisticapivopoint["high"]["r3"] += 1;
            }
          } else if (stock.close > pivotpoint.r3) {
            estatisticapivopoint["close"]["r1"] += 1;
            estatisticapivopoint["close"]["r2"] += 1;
            estatisticapivopoint["close"]["r3"] += 1;
            if (stocks[posicaostock + 1].close >
                stocks[posicaostock + 1].open) {
              diaseguinte["r3"]["alta"] += 1;
            } else {
              diaseguinte["r3"]["baixa"] += 1;
            }
          } else if (stock.close < pivotpoint.s1 &&
              stock.close > pivotpoint.s2) {
            estatisticapivopoint["close"]["s1"] += 1;
            if (stocks[posicaostock + 1].close >
                stocks[posicaostock + 1].open) {
              diaseguinte["s1"]["alta"] += 1;
            } else {
              diaseguinte["s1"]["baixa"] += 1;
            }
            if (stock.low < pivotpoint.s3) {
              estatisticapivopoint["low"]["s2"] += 1;
              estatisticapivopoint["low"]["s3"] += 1;
            } else if (stock.low < pivotpoint.s2 && stock.low > pivotpoint.s3) {
              estatisticapivopoint["low"]["s2"] += 1;
            }
          } else if (stock.close < pivotpoint.s2 &&
              stock.close > pivotpoint.s3) {
            estatisticapivopoint["close"]["s1"] += 1;
            estatisticapivopoint["close"]["s2"] += 1;
            if (stocks[posicaostock + 1].close >
                stocks[posicaostock + 1].open) {
              diaseguinte["s2"]["alta"] += 1;
            } else {
              diaseguinte["s2"]["baixa"] += 1;
            }
            if (stock.low < pivotpoint.s3) {
              estatisticapivopoint["low"]["s3"] += 1;
            }
          } else if (stock.close < pivotpoint.s3) {
            estatisticapivopoint["close"]["s1"] += 1;
            estatisticapivopoint["close"]["s2"] += 1;
            estatisticapivopoint["close"]["s3"] += 1;
            if (stocks[posicaostock + 1].close >
                stocks[posicaostock + 1].open) {
              diaseguinte["s3"]["alta"] += 1;
            } else {
              diaseguinte["s3"]["baixa"] += 1;
            }
          } else {
            if (stock.high > pivotpoint.r1) {
              estatisticapivopoint["high"]["r1"] += 1;
              if (stock.high > pivotpoint.r2) {
                estatisticapivopoint["high"]["r2"] += 1;
                if (stock.high > pivotpoint.r3) {
                  estatisticapivopoint["high"]["r3"] += 1;
                }
              }
            }

            if (stock.low < pivotpoint.s1) {
              estatisticapivopoint["low"]["s1"] += 1;
              if (stock.low < pivotpoint.s2) {
                estatisticapivopoint["low"]["s2"] += 1;
                if (stock.low < pivotpoint.s3) {
                  estatisticapivopoint["low"]["s3"] += 1;
                }
              }
            }
          }
        }
      }
    }
    print(estatisticapivopoint);
    estatisticapivopoint["diaseguinte"] = diaseguinte;
    return estatisticapivopoint;
  }

  Widget _buildDiaSeguinte(diaseguinte, total) {
    return Row(
      children: [
        Column(
          children: [
            Text("${diaseguinte["alta"]}",
                style: TextStyle(color: AppColors.white, fontSize: 10)),
            Container(
              height: 40,
              width: 15,
              color: Colors.green,
            ),
            Text("${_porcentagemcalculo(diaseguinte["alta"], total)}%",
                style: TextStyle(color: AppColors.white)),
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            Text("${diaseguinte["baixa"]}",
                style: TextStyle(color: AppColors.white, fontSize: 10)),
            Container(
              height: 40,
              width: 15,
              color: Colors.red,
            ),
            Text("${_porcentagemcalculo(diaseguinte["baixa"], total)}%",
                style: TextStyle(color: AppColors.white)),
          ],
        )
      ],
    );
  }

  Widget _buildTitleDiaSeguinte(point) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text("$point", style: TextStyle(color: AppColors.white)),
    );
  }

  _buildCardEstatistica(
      BuildContext context, Map<String, dynamic> estatisticapivopoint) {
    int r3 = estatisticapivopoint["high"]["r3"];
    int r2 = estatisticapivopoint["high"]["r2"];
    int r1 = estatisticapivopoint["high"]["r1"];

    int s3 = estatisticapivopoint["low"]["s3"];
    int s2 = estatisticapivopoint["low"]["s2"];
    int s1 = estatisticapivopoint["low"]["s1"];

    int totalr3 = estatisticapivopoint["close"]["r3"] + r3;
    int totalr2 = estatisticapivopoint["close"]["r2"] + r2;
    int totalr1 = estatisticapivopoint["close"]["r1"] + r1;
    int totals3 = estatisticapivopoint["close"]["s3"] + s3;
    int totals2 = estatisticapivopoint["close"]["s2"] + s2;
    int totals1 = estatisticapivopoint["close"]["s1"] + s1;

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
              onChangeEnd: (RangeValues value) {},
              onChanged: (RangeValues value) async {
                setState(() {
                  selectedRange = RangeValues(
                      value.start.roundToDouble(), value.end.roundToDouble());
                  rangeano = value.end.round() - value.start.round();

                  datapivotpointsevent = pivotpointsevent
                      .where((e) =>
                          e.stock.datetime.year >=
                              selectedRange.start.toInt() &&
                          e.stock.datetime.year <= selectedRange.end.toInt())
                      .toList();
                });

                estatisticaData(datapivotpointsevent)
                    .then((value) => setState(() {
                          resultadoestatistica = value;
                        }));
              },
            ),
            SizedBox(height: 30),
            Text(
              "Fechamento/Toque",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            Text(
              "nos pontos de pivot",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                    Text("R3", style: TextStyle(color: AppColors.white)),
                    Text("R2", style: TextStyle(color: AppColors.white)),
                    Text("R1", style: TextStyle(color: AppColors.white)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Fechamento Acima",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                    Text("${estatisticapivopoint["close"]["r3"]}",
                        style: TextStyle(color: AppColors.white)),
                    Text("${estatisticapivopoint["close"]["r2"]}",
                        style: TextStyle(color: AppColors.white)),
                    Text("${estatisticapivopoint["close"]["r1"]}",
                        style: TextStyle(color: AppColors.white)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Toque",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                    Text("${estatisticapivopoint["high"]["r3"]}",
                        style: TextStyle(color: AppColors.white)),
                    Text("${estatisticapivopoint["high"]["r2"]}",
                        style: TextStyle(color: AppColors.white)),
                    Text("${estatisticapivopoint["high"]["r1"]}",
                        style: TextStyle(color: AppColors.white)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                    Text("S3", style: TextStyle(color: AppColors.white)),
                    Text("S2", style: TextStyle(color: AppColors.white)),
                    Text("S1", style: TextStyle(color: AppColors.white)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Fechamento Abaixo",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                    Text("${estatisticapivopoint["close"]["s3"]}",
                        style: TextStyle(color: AppColors.white)),
                    Text("${estatisticapivopoint["close"]["s2"]}",
                        style: TextStyle(color: AppColors.white)),
                    Text("${estatisticapivopoint["close"]["s1"]}",
                        style: TextStyle(color: AppColors.white)),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Toque",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                    Text("${estatisticapivopoint["low"]["s3"]}",
                        style: TextStyle(color: AppColors.white)),
                    Text("${estatisticapivopoint["low"]["s2"]}",
                        style: TextStyle(color: AppColors.white)),
                    Text("${estatisticapivopoint["low"]["s1"]}",
                        style: TextStyle(color: AppColors.white)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Resistência/Suporte",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            Text("Cálculo baseado após ultrapassar/romper um ponto de pivot",
                style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 15),
            Text(
              "Resistência",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            Column(
              children: [
                Text(
                    "R3 serviu como resistência:${_porcentagemcalculo(r3, totalr3)}%",
                    style: TextStyle(color: AppColors.white)),
                Text(
                    "R2 serviu como resistência:${_porcentagemcalculo(r2, totalr2)}%",
                    style: TextStyle(color: AppColors.white)),
                Text(
                    "R1 serviu como resistência:${_porcentagemcalculo(r1, totalr1)}%",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Suporte",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            Column(
              children: [
                Text(
                    "S3 serviu como suporte:${_porcentagemcalculo(s3, totals3)}%",
                    style: TextStyle(color: AppColors.white)),
                Text(
                    "S2 serviu como suporte:${_porcentagemcalculo(s2, totals2)}%",
                    style: TextStyle(color: AppColors.white)),
                Text(
                    "S1 serviu como suporte:${_porcentagemcalculo(s1, totals1)}%",
                    style: TextStyle(color: AppColors.white)),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Estatistica dia seguinte",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            Text(
              "Com base no fechamento acima/abaixo dos pontos de pivot",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    _buildTitleDiaSeguinte('R3'),
                    _buildDiaSeguinte(estatisticapivopoint["diaseguinte"]["r3"],
                        estatisticapivopoint["close"]["r3"]),
                    _buildTitleDiaSeguinte('R2'),
                    _buildDiaSeguinte(estatisticapivopoint["diaseguinte"]["r2"],
                        estatisticapivopoint["close"]["r2"]),
                    _buildTitleDiaSeguinte('R1'),
                    _buildDiaSeguinte(estatisticapivopoint["diaseguinte"]["r1"],
                        estatisticapivopoint["close"]["r1"]),
                  ],
                ),
                Column(
                  children: [
                    _buildTitleDiaSeguinte('S3'),
                    _buildDiaSeguinte(estatisticapivopoint["diaseguinte"]["s3"],
                        estatisticapivopoint["close"]["s3"]),
                    _buildTitleDiaSeguinte('S2'),
                    _buildDiaSeguinte(estatisticapivopoint["diaseguinte"]["s2"],
                        estatisticapivopoint["close"]["s2"]),
                    _buildTitleDiaSeguinte('S1'),
                    _buildDiaSeguinte(estatisticapivopoint["diaseguinte"]["s1"],
                        estatisticapivopoint["close"]["s1"]),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemEvento(PivotPointData point) {
    List<Widget> listrow = [];

    if (point.stock.close < point.pivotpoint.s1) {
      TextStyle style = TextStyle(fontSize: 12.0, color: Colors.blue[100]);

      listrow.add(
        Text("S1: ${roundDouble(point.pivotpoint.s1, 2)}", style: style),
      );
      if (point.stock.close < point.pivotpoint.s2) {
        listrow.add(
          Text("S2: ${roundDouble(point.pivotpoint.s2, 2)}", style: style),
        );
        if (point.stock.close < point.pivotpoint.s3) {
          listrow.add(
            Text("S3: ${roundDouble(point.pivotpoint.s3, 2)}", style: style),
          );
        }
      }
    } else if (point.stock.close > point.pivotpoint.r1) {
      TextStyle style = TextStyle(fontSize: 12.0, color: Colors.red[100]);
      listrow.add(
        Text("R1: ${roundDouble(point.pivotpoint.r1, 2)}", style: style),
      );
      if (point.stock.close > point.pivotpoint.r2) {
        listrow.add(
          Text("R2: ${roundDouble(point.pivotpoint.r2, 2)}", style: style),
        );
        if (point.stock.close > point.pivotpoint.r3) {
          listrow.add(
            Text("R3: ${roundDouble(point.pivotpoint.r3, 2)}", style: style),
          );
        }
      }
    }

    return listrow;
  }

  _buildListViewEventos(BuildContext context) {
    List<PivotPointData> filteredevents = datapivotpointsevent
        .where((e) =>
            e.stock.close < e.pivotpoint.s1 || e.stock.close > e.pivotpoint.r1)
        .toList();

    return filteredevents.length == 0
        ? Center(
            child: Text(
            'Nenhum evento registrado',
            style: TextStyle(color: AppColors.white, fontSize: 25),
          ))
        : ListView.builder(
            itemCount: filteredevents.length,
            itemBuilder: (context, index) {
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
                          title: Column(
                            children: [
                              Text(
                                "Fechamento",
                                style: TextStyle(
                                    fontSize: 12.0, color: AppColors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "${filteredevents[index].stock.close}",
                                style: TextStyle(
                                    fontSize: 20.0, color: AppColors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _buildItemEvento(filteredevents[index]),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      PivotPointGraficoPage(
                                          pivotpoint: filteredevents,
                                          pivotevent: filteredevents[index],
                                          stocks: stocks,
                                          stockname: stockname),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  transitionDuration:
                                      Duration(milliseconds: 400),
                                ));
                          },
                        ),
                      ),
                    );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return _buildListViewEventos(context);
  }
}
