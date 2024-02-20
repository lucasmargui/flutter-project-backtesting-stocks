import 'package:flutter/material.dart';

import 'package:scouting/models/todo.dart';

class EstatisticaPadroesPage extends StatefulWidget {
  EstatisticaPadroesPage({
    @required this.stockname,
    @required this.stocks,
    @required this.trades,
    @required this.buysignals,
    @required this.sellsignals,
  });

  final List<IndicadoresOpcao> buysignals;
  final List<IndicadoresOpcao> sellsignals;
  final String stockname;
  final List<Stock> stocks;
  final List<Trade> trades;

  @override
  _EstatisticaPadroesPageState createState() => _EstatisticaPadroesPageState(
      stockname: stockname,
      stocks: stocks,
      trades: trades,
      buysignals: buysignals,
      sellsignals: sellsignals);
}

class _EstatisticaPadroesPageState extends State<EstatisticaPadroesPage> {
  _EstatisticaPadroesPageState({
    @required this.stockname,
    @required this.stocks,
    @required this.trades,
    @required this.buysignals,
    @required this.sellsignals,
  });

  final List<IndicadoresOpcao> buysignals;
  final List<IndicadoresOpcao> sellsignals;
  final String stockname;
  final List<Stock> stocks;
  final List<Trade> trades;

  final scaffoldState = GlobalKey<ScaffoldState>();

  Map<String, dynamic> resultadoestatistica = {
    "entrada": {
      "cpA": 0,
      "cpAA": 0,
      "cpAB": 0,
      "cpAAA": 0,
      "cpAAB": 0,
      "cpABB": 0,
      "cpABA": 0,
      "cpB": 0,
      "cpBB": 0,
      "cpBA": 0,
      "cpBBB": 0,
      "cpBBA": 0,
      "cpBAA": 0,
      "cpBAB": 0,
    },
    "saida": {
      "cpA": 0,
      "cpAA": 0,
      "cpAB": 0,
      "cpAAA": 0,
      "cpAAB": 0,
      "cpABB": 0,
      "cpABA": 0,
      "cpB": 0,
      "cpBB": 0,
      "cpBA": 0,
      "cpBBB": 0,
      "cpBBA": 0,
      "cpBAA": 0,
      "cpBAB": 0,
    },
  };

  @override
  void initState() {
    setState(() {
      resultadoestatistica = estatisticaData();
    });
    super.initState();
  }

  Map<String, dynamic> estatisticaData() {
    Map<String, dynamic> estatisticapadraoentrada = {
      "cpA": 0,
      "cpAA": 0,
      "cpAB": 0,
      "cpAAA": 0,
      "cpAAB": 0,
      "cpABB": 0,
      "cpABA": 0,
      "cpB": 0,
      "cpBB": 0,
      "cpBA": 0,
      "cpBBB": 0,
      "cpBBA": 0,
      "cpBAA": 0,
      "cpBAB": 0,
    };

    Map<String, dynamic> estatisticapadraosaida = {
      "cpA": 0,
      "cpAA": 0,
      "cpAB": 0,
      "cpAAA": 0,
      "cpAAB": 0,
      "cpABB": 0,
      "cpABA": 0,
      "cpB": 0,
      "cpBB": 0,
      "cpBA": 0,
      "cpBBB": 0,
      "cpBBA": 0,
      "cpBAA": 0,
      "cpBAB": 0,
    };

//  Map estatisticaLowBand = {"eventsBandTotal":0,"closeMaiorProxclose":0, "closeMenorProxclose":0,"variacaocomprafechamento":0,"variacaovendafechamento":0};

    for (int i = 0; i < trades.length; i++) {
      if (trades[i].indexentrada + 3 < stocks.length && i > 3) {
        Stock proxcandleentrada1 = stocks[trades[i].indexentrada + 1];
        Stock proxcandleentrada2 = stocks[trades[i].indexentrada + 2];
        Stock proxcandleentrada3 = stocks[trades[i].indexentrada + 3];
        String key = "";

        if (proxcandleentrada1.close > proxcandleentrada1.open) {
          key += "A";
          estatisticapadraoentrada["cp$key"] += 1;
        } else {
          key += "B";
          estatisticapadraoentrada["cp$key"] += 1;
        }

        if (proxcandleentrada2.close > proxcandleentrada2.open) {
          key += "A";
          estatisticapadraoentrada["cp$key"] += 1;
        } else {
          key += "B";
          estatisticapadraoentrada["cp$key"] += 1;
        }

        if (proxcandleentrada3.close > proxcandleentrada3.open) {
          key += "A";
          estatisticapadraoentrada["cp$key"] += 1;
        } else {
          key += "B";
          estatisticapadraoentrada["cp$key"] += 1;
        }
      }

      Stock antcandlesaida1 = stocks[trades[i].indexsaida - 1];
      Stock antcandlesaida2 = stocks[trades[i].indexsaida - 2];
      Stock antcandlesaida3 = stocks[trades[i].indexsaida - 3];
      String key = "";

      if (antcandlesaida1.close > antcandlesaida1.open) {
        key += "A";
        estatisticapadraosaida["cp$key"] += 1;
      } else {
        key += "B";
        estatisticapadraosaida["cp$key"] += 1;
      }

      if (antcandlesaida2.close > antcandlesaida2.open) {
        key += "A";
        estatisticapadraosaida["cp$key"] += 1;
      } else {
        key += "B";
        estatisticapadraosaida["cp$key"] += 1;
      }

      if (antcandlesaida3.close > antcandlesaida3.open) {
        key += "A";
        estatisticapadraosaida["cp$key"] += 1;
      } else {
        key += "B";
        estatisticapadraosaida["cp$key"] += 1;
      }
    }

    return {
      "entrada": estatisticapadraoentrada,
      "saida": estatisticapadraosaida,
    };
  }

  _buildPadroesGraficos(key) {
    Text title;
    Text subtitle;
    Text dia1;
    Text dia2;
    Text dia3;
    List<Widget> condicoes = [];

    if (key == "entrada") {
      title = Text(
        "Compra",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white),
      );
      subtitle = Text(
        "Padrões dos 3 dias seguintes",
        style: TextStyle(color: AppColors.white),
      );
      dia1 = Text("Dia seguinte",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white));
      dia2 = Text("Dia 2",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white));
      dia3 = Text("Dia 3",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white));
      buysignals.forEach((e) {
        if (e.id != 13) {
          condicoes.add(Text(e.configselecionado.title,
              style: TextStyle(color: AppColors.white)));
        } else {
          e.indicadoresopcoes.forEach((emulti) {
            condicoes.add(Text(emulti.configselecionado.title,
                style: TextStyle(color: AppColors.white)));
          });
        }
      });
    } else {
      title = Text(
        "Saida",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.white),
      );
      subtitle = Text(
        "Padrões dos 3 dias prévios",
        style: TextStyle(color: AppColors.white),
      );
      dia1 = Text("Dia anterior",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white));
      dia2 = Text("2 Dias prévios",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white));
      dia3 = Text("3 Dias prévios",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.white));

      sellsignals.forEach((e) {
        if (e.id != 13) {
          condicoes.add(Text(e.configselecionado.title,
              style: TextStyle(color: AppColors.white)));
        } else {
          e.indicadoresopcoes.forEach((emulti) {
            condicoes.add(Text(emulti.configselecionado.title,
                style: TextStyle(color: AppColors.white)));
          });
        }
      });
    }

    return Column(
      children: [
        title,
        Column(
          children: condicoes,
        ),
        subtitle,
        SizedBox(height: 10),
        dia1,
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
                Text("${resultadoestatistica[key]["cpA"]}",
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
                Text("${resultadoestatistica[key]["cpB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            )
          ],
        ),
        SizedBox(height: 30),
        dia2,
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
                Text("${resultadoestatistica[key]["cpAA"]}",
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
                Text("${resultadoestatistica[key]["cpAB"]}",
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
                Text("${resultadoestatistica[key]["cpBA"]}",
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
                Text("${resultadoestatistica[key]["cpBB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            )
          ],
        ),
        SizedBox(height: 30),
        dia3,
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
                Text("${resultadoestatistica[key]["cpAAA"]}",
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
                Text("${resultadoestatistica[key]["cpAAB"]}",
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
                Text("${resultadoestatistica[key]["cpABA"]}",
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
                Text("${resultadoestatistica[key]["cpABB"]}",
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
                Text("${resultadoestatistica[key]["cpBBA"]}",
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
                Text("${resultadoestatistica[key]["cpBAB"]}",
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
                Text("${resultadoestatistica[key]["cpBAA"]}",
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
                Text("${resultadoestatistica[key]["cpBBB"]}",
                    style: TextStyle(color: AppColors.white)),
              ],
            )
          ],
        ),
      ],
    );
  }

  _buildCardEstatistica(BuildContext context) {
    return Card(
      child: new Container(
        color: AppColors.primary,
        padding: new EdgeInsets.all(16.0),
        child: ListView(
          children: [
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildPadroesGraficos("entrada"),
                SizedBox(height: 40),
                _buildPadroesGraficos("saida"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        key: scaffoldState,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/BOV_$stockname.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('$stockname'))
            ],
          ),
          backgroundColor: AppColors.menu,
        ),
        body: _buildCardEstatistica(context));
  }
}
