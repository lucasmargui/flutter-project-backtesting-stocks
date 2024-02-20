import 'package:flutter/material.dart';
import 'package:scouting/estatisticapadroes_page.dart';
import 'package:scouting/models/todo.dart';
import 'package:scouting/provider/backtesting.dart';
import 'package:scouting/provider/function.dart';
import 'package:scouting/provider/mapindicadores.dart';
import 'package:scouting/tradegrafico_page.dart';
import 'package:scouting/models/state.dart';

class EstatisticaPage extends StatefulWidget {
  EstatisticaPage({
    @required this.stocks,
    @required this.stockname,
    @required this.buysignals,
    @required this.sellsignals,
  });

  final List<Stock> stocks;
  final String stockname;
  final List<IndicadoresOpcao> buysignals;
  final List<IndicadoresOpcao> sellsignals;

  @override
  _EstatisticaPageState createState() => _EstatisticaPageState(
      stocks: stocks,
      stockname: stockname,
      buysignals: buysignals,
      sellsignals: sellsignals);
}

class _EstatisticaPageState extends State<EstatisticaPage> {
  final List<Stock> stocks;
  final String stockname;
  final List<IndicadoresOpcao> buysignals;
  final List<IndicadoresOpcao> sellsignals;

  _EstatisticaPageState({
    @required this.stocks,
    @required this.stockname,
    @required this.buysignals,
    @required this.sellsignals,
  });

  RangeValues selectedRange;
  int divisions;
  int rangeano;
  List<Trade> tradesData = [];
  List<Trade> tradesFiltered = [];

  // int selectedRangehashcode;

//////////MAP COM POSIÇAO POSIÇAO INDEX DOS INDICADORES/STOCK

  MapIndicadores map;
  Estatistica estatistica;
  StateModel appState;

  @override
  void initState() {
    setState(() {
      var sub = stocks.last.datetime.year - stocks[0].datetime.year;
      divisions = sub > 0 ? sub : 1;
      rangeano = sub > 0 ? sub : 1;
      selectedRange = RangeValues(stocks[0].datetime.year.roundToDouble(),
          stocks.last.datetime.year.roundToDouble());

      print("Lista Stocks Tamanho:${stocks.length}");
      map = GeraMapDataPoint.generateMap(buysignals, sellsignals, stocks);
      print('Map criado');
      tradesData = generateTrades();
      print('tradesData criado');
      tradesFiltered = tradesData;
      print('tradesFiltered ${tradesFiltered.length}');
      estatistica = generateEstatistica();
      //   // dev.debugger();

      //   // selectedRangehashcode = selectedRange.hashCode;
      //   // print("hashcode:$hashCode");
    });

    super.initState();
  }

  List<Trade> generateTrades() {
    Stock tradeEntrada;
    int indexEntrada;

    Stock tradeSaida;
    int indexSaida;

    List<Trade> trades = [];

    bool trade = false;

    for (var i = 1; i < stocks.length; i++) {
      if (i + 1 < stocks.length) {
        ////Se trade for true, significa que ja esta comprado e caira na verificaçao de venda
        ///Se trade for false, significa que ja nao esta comprado e caira na verificaçao de compra

        if (trade) {
          /////////////////////PARTE 1///////////////////////
          ///Armazena uma lista de booleans,se todos forem true singifica que todos os parametros da estrategia foram atendidos
          List sellsignalsboolean = [];
          sellsignals.forEach((indicadoropcao) {
            //Distingue os parametros no array buysignals para poder compara-los dependendo do parametro e adicionar o resultado da comparaçao na lista
            sellsignalsboolean.add(LogicaBackTesting.verificaocondicao(
                indicadoropcao, i, stocks, map, tradeEntrada, indexEntrada));
          });

          /////////////////////PARTE 2///////////////////////
          //Verifica se existe algum boolean que retornou false
          int countbooleansell =
              sellsignalsboolean.where((item) => item == false).length;
          if (countbooleansell == 0) {
            //Se todos SIGNALS retornarem true entao significa que ele realizou a venda entao nao esta mais comprado
            tradeSaida = stocks[i];
            indexSaida = i;
            trades.add(Trade(
                entrada: tradeEntrada,
                indexentrada: indexEntrada,
                saida: tradeSaida,
                indexsaida: indexSaida));
            tradeEntrada = null;
            indexEntrada = null;
            trade = false;
          }
        } else {
          /////////////////////PARTE 1///////////////////////
          ///Armazena uma lista de booleans,se todos forem true singifica que todos os parametros da estrategia foram atendidos e adicionar o resultado da comparaçao na lista
          List buysignalsboolean = [];

          buysignals.forEach((indicadoropcao) {
            //Distingue os parametros no array buysignals para poder compara-los dependendo do parametro
            buysignalsboolean.add(LogicaBackTesting.verificaocondicao(
                indicadoropcao, i, stocks, map, null, null));
          });

          /////////////////////PARTE 2///////////////////////
          //Verifica se existe algum boolean que retornou false, se retorna algum false significa que trade nao é realizado
          int countbooleanbuy =
              buysignalsboolean.where((item) => item == false).length;
          if (countbooleanbuy == 0) {
            trade = true;
            //Verifica o tipo de fechamento, se é pra realizar o trade no dia do fechamento do sinal ou no fechamento do dia seguinte
            tradeEntrada = stocks[i];
            indexEntrada = i;
            // print("compra realizada no index $i");
            // print("///////////////////////// ");
          }
        }
      }
    }

    return trades;
  }

  Estatistica generateEstatistica() {
    Estatistica estatistica = Estatistica(
        total: tradesFiltered.length,
        gain: 0,
        qtdgain: 0,
        qtddiasgain: 0,
        loss: 0,
        qtdloss: 0,
        qtddiasloss: 0,
        dadosanalisados: 0,
        payoff: 0,
        profit: 0,
        profitporcentagem: 0,
        maximumdrawndown: 0);

    double precoEntrada;
    double precoVenda;
    int differencedays;
    double profit;
    bool drawndown = false;
    double maximumdrawndown = 0.0;
    double somadrawndown = 0.0;

    if (tradesFiltered.isNotEmpty) {
      tradesFiltered.forEach((e) {
        precoEntrada = e.entrada.close;
        precoVenda = e.saida.close;
        differencedays = e.saida.datetime.difference(e.entrada.datetime).inDays;
        profit = FunctionStock.roundDouble((precoVenda - precoEntrada), 2);

        if (precoVenda > precoEntrada) {
          ///////GAIN/////

          if (drawndown == true && somadrawndown < maximumdrawndown) {
            maximumdrawndown = somadrawndown;
            drawndown = false;
            somadrawndown = 0;
          } else {
            drawndown = false;
            somadrawndown = 0;
          }
          estatistica.gain += (precoVenda - precoEntrada);
          estatistica.qtdgain += 1;
          estatistica.qtddiasgain += differencedays;
          estatistica.profit += profit;
          estatistica.profitporcentagem +=
              ((precoVenda - precoEntrada) / precoEntrada) * 100;
        } else {
          //////////Losssssss///////
          somadrawndown += ((precoVenda - precoEntrada) / precoEntrada) * 100;
          drawndown = true;

          estatistica.loss += (precoVenda - precoEntrada);
          estatistica.qtdloss += 1;
          estatistica.qtddiasloss += differencedays;
          estatistica.profit += profit;
          estatistica.profitporcentagem +=
              ((precoVenda - precoEntrada) / precoEntrada) * 100;
        }
      });

      // print("gain:${estatistica.gain}");
      // print("loss:${estatistica.loss}");
      if (estatistica.gain == 0 && estatistica.loss == 0) {
        estatistica.payoff = 0;
      } else if (estatistica.gain > 0 && estatistica.loss == 0) {
        estatistica.payoff =
            FunctionStock.roundDouble((estatistica.gain / 1), 2);
      } else if (estatistica.gain == 0 && estatistica.loss > 0) {
        estatistica.payoff = 0;
      } else {
        estatistica.payoff =
            FunctionStock.roundDouble((estatistica.gain / estatistica.loss), 2);
        estatistica.payoff = estatistica.payoff * -1;
      }
      estatistica.maximumdrawndown =
          FunctionStock.roundDouble(maximumdrawndown, 2);
    }

    return estatistica;
  }

  _buildEstatistica() {
    String estatisticagain =
        "${FunctionStock.roundDouble((estatistica.qtdgain / estatistica.total), 2)}";
    String diasgain = estatistica.qtddiasgain == 0 && estatistica.qtdgain == 0
        ? "0"
        : "${FunctionStock.roundDouble((estatistica.qtddiasgain / estatistica.qtdgain), 2)}";

    String estatisticaloss =
        "${FunctionStock.roundDouble((estatistica.qtdloss / estatistica.total), 2)}";
    String diasloss = estatistica.qtddiasloss == 0 && estatistica.qtdloss == 0
        ? "0"
        : "${FunctionStock.roundDouble((estatistica.qtddiasloss / estatistica.qtdloss), 2)}";

    String payoff = estatistica.gain == 0 || estatistica.loss == 0
        ? "..."
        : "${FunctionStock.roundDouble(estatistica.payoff, 2)}";

    return Card(
      color: AppColors.primary,
      child: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Periodo do calculo",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            RaisedButton(
                color: Colors.black,
                elevation: 5,
                padding: EdgeInsets.all(20.0),
                onPressed: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => EstatisticaPadroesPage(
                          stockname: stockname,
                          stocks: stocks,
                          trades: tradesFiltered,
                          buysignals: buysignals,
                          sellsignals: sellsignals,
                        ),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 400),
                      ),
                    ),
                child: Text(
                  'Padrão dos 3 periodos pós entrada e antes saida',
                  style: TextStyle(color: AppColors.white, fontSize: 13),
                )),
            SizedBox(
              height: 30,
            ),
            Text(
              "Intervalo de trades",
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
                  selectedRange = RangeValues(
                      value.start.roundToDouble(), value.end.roundToDouble());

                  tradesFiltered = tradesData
                      .where((e) =>
                          e.entrada.datetime.year >=
                              selectedRange.start.toInt() &&
                          e.saida.datetime.year <= selectedRange.end.toInt())
                      .toList();
                  estatistica = generateEstatistica();
                  rangeano = (value.end - value.start).toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Gain:${estatistica.qtdgain}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white)),
                    Text("$estatisticagain%",
                        style: TextStyle(color: AppColors.white)),
                    SizedBox(height: 30),
                    Text("Média por trade",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white)),
                    Text("$diasgain dias",
                        style: TextStyle(color: AppColors.white)),
                    SizedBox(height: 30),
                    Text("Payoff",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white)),
                    Text("$payoff", style: TextStyle(color: AppColors.white)),
                    SizedBox(height: 30),
                    Text("Drawndown Máximo",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white)),
                    Text("${estatistica.maximumdrawndown}%",
                        style: TextStyle(color: AppColors.white)),
                  ],
                ),
                Column(
                  children: [
                    Text("Loss:${estatistica.qtdloss}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white)),
                    Text("$estatisticaloss%",
                        style: TextStyle(color: AppColors.white)),
                    SizedBox(height: 30),
                    Text("Média por trade",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white)),
                    Text("$diasloss dias",
                        style: TextStyle(color: AppColors.white)),
                    SizedBox(height: 30),
                    Text("Profit",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white)),
                    Text(
                        "R\$\:${FunctionStock.roundDouble(estatistica.profit, 2)}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white)),
                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Text("Resultado",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white)),
                Text(
                    "${FunctionStock.roundDouble(estatistica.profitporcentagem, 2)}%",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildCard(index, precoEntrada, precoSaida, dtstart, dtend) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          tradesFiltered.removeAt(index);
          estatistica = generateEstatistica();
        });
      },
      child: Card(
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
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/icon/candle.jpg'),
            ),
            title: Text("Entrada: $dtstart - $dtend",
                style: TextStyle(fontSize: 18.0, color: AppColors.white)),
            subtitle: Text(
              "Compra R\$\:$precoEntrada || Venda R\$\:$precoSaida = R\$\:${FunctionStock.roundDouble((precoSaida - precoEntrada), 2)} ",
              style: TextStyle(color: AppColors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => TradeGraficoPage(
                      stockname: stockname,
                      stocks: stocks,
                      trade: tradesFiltered[index],
                      buysignals: buysignals,
                      sellsignals: sellsignals,
                      map: map),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 400),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildMainPage(BuildContext context) {
    return tradesFiltered.isNotEmpty
        ? ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: tradesFiltered.length,
            itemBuilder: (context, index) {
              DateTime dateEntrada = tradesFiltered[index].entrada.datetime;
              DateTime dateSaida = tradesFiltered[index].saida.datetime;

              double precoEntrada = tradesFiltered[index].entrada.close;
              double precoSaida = tradesFiltered[index].saida.close;

              String dtstart =
                  "${dateEntrada.day}/${dateEntrada.month}/${dateEntrada.year}";
              String dtend =
                  "${dateSaida.day}/${dateSaida.month}/${dateSaida.year}";

              return index == 0
                  ? Column(
                      children: [
                        _buildEstatistica(),
                        _buildCard(
                            index, precoEntrada, precoSaida, dtstart, dtend)
                      ],
                    )
                  : _buildCard(index, precoEntrada, precoSaida, dtstart, dtend);
            },
          )
        : Center(
            child: Card(
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Nenhum trade registrado",
                    style: TextStyle(color: AppColors.primary, fontSize: 20),
                  ),
                )),
          );
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
              Image.asset(
                'assets/images/BOV_$stockname.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('$stockname'))
            ],
          ),
        ),
        body: tradesFiltered.isNotEmpty
            ? _buildMainPage(context)
            : Center(child: CircularProgressIndicator()));
  }
}
