import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scouting/models/todo.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TradeGraficoPage extends StatefulWidget {
  TradeGraficoPage({
    @required this.stockname,
    @required this.stocks,
    @required this.trade,
    @required this.buysignals,
    @required this.sellsignals,
    @required this.map,
  });

  final String stockname;
  final Trade trade;
  final List<Stock> stocks;
  final List<IndicadoresOpcao> buysignals;
  final List<IndicadoresOpcao> sellsignals;
  final MapIndicadores map;

  @override
  _TradeGraficoPageState createState() => _TradeGraficoPageState(
      stockname: stockname,
      stocks: stocks,
      trade: trade,
      buysignals: buysignals,
      sellsignals: sellsignals,
      map: map);
}

class _TradeGraficoPageState extends State<TradeGraficoPage> {
  final String stockname;
  final Trade trade;
  final List<Stock> stocks;
  final List<IndicadoresOpcao> buysignals;
  final List<IndicadoresOpcao> sellsignals;
  final MapIndicadores map;

  _TradeGraficoPageState({
    @required this.stockname,
    @required this.stocks,
    @required this.trade,
    @required this.buysignals,
    @required this.sellsignals,
    @required this.map,
  });

  IndicadoresOpcao indicadorselecionado;
  List<TechnicalIndicators<dynamic, dynamic>> indicadorchart;
  List<ChartSeries> chartseries;
  List<Stock> data;

  @override
  void initState() {
    print("Entrada: ${trade.entrada.close}");
    print("Saida: ${trade.saida.close}");

    setState(() {
      data = generateData();
      chartseries = <ChartSeries>[
        HiloOpenCloseSeries<Stock, dynamic>(
            isVisibleInLegend: false,
            enableTooltip: true,
            dataSource: data,
            xValueMapper: (Stock stock, _) => stock.datetime,
            lowValueMapper: (Stock stock, _) => stock.low,
            highValueMapper: (Stock stock, _) => stock.high,
            openValueMapper: (Stock stock, _) => stock.open,
            closeValueMapper: (Stock stock, _) => stock.close,
            volumeValueMapper: (Stock stock, _) => stock.volume,
            name: "Stock"),
      ];
    });

    super.initState();
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

  List<Stock> createIntervalStock(calculolimite) {
    List<Stock> list = [];
    int indexofentrada = trade.indexentrada;
    int indexofsaida = trade.indexsaida;

    int loopstart;
    int loopend;
    int start;
    int end;

    if (indexofentrada > calculolimite) {
      loopstart = calculolimite;
      start = indexofentrada - calculolimite;
    } else {
      loopstart = indexofentrada;
      start = indexofentrada;
    }

    if ((indexofsaida + 10) < stocks.length) {
      loopend = 10;
      end = indexofsaida;
    } else {
      loopend = stocks.length - indexofsaida;
      end = indexofsaida;
    }

    for (int i = 0; i <= loopstart; i++) {
      list.add(stocks[start + i]);
    }

    var tradeduracao = indexofsaida - indexofentrada;

    for (int i = 1; i < tradeduracao; i++) {
      list.add(stocks[indexofentrada + i]);
    }

    for (int i = 0; i < loopend; i++) {
      list.add(stocks[end + i]);
    }

    print(list);

    return list;
  }

  List<DataPoint> createIntervalStockMedia(calculolimite, map) {
    List<DataPoint> list = [];
    int indexofentrada = trade.indexentrada;
    int indexofsaida = trade.indexsaida;

    int start;
    int end;

    if ((indexofsaida + 10) < stocks.length) {
      end = (indexofsaida) + 10;
    } else {
      end = indexofsaida;
    }

    if (indexofentrada <= 20) {
      start = 0;
    } else {
      start = indexofentrada - 20;
    }

    List<DataPoint> sublistSma = map.sublist(start, end);
    List<Stock> sublistDatetime = stocks.sublist(start, end);

    for (int i = 0; i < sublistSma.length; i++) {
      list.add(DataPoint(
          stock: null,
          index: null,
          x: sublistDatetime[i].datetime,
          y: sublistSma[i].y));
    }

    return list;
  }

  changeIndicatorSelected(IndicadoresOpcao indicadoropcao) {
    int id = indicadoropcao.id;
    int periodo = indicadoropcao.parametro["periodo"] ?? 0;
    String key = "$id:$periodo";

    switch (indicadoropcao.id) {
      case 1:
        {
          List<DataPoint> listpointAd =
              createIntervalStockMedia(20, map.mapAcumDist[key]);

          setState(() {
            if (indicadoropcao.configselecionado.id == "acudis5" ||
                indicadoropcao.configselecionado.id == "acudis6") {
              String keymodified = "$id:$periodo:media";
              List<DataPoint> listpointmedia =
                  createIntervalStockMedia(20, map.mapAcumDist[keymodified]);

              chartseries = [
                HiloOpenCloseSeries<Stock, dynamic>(
                    isVisibleInLegend: false,
                    enableTooltip: true,
                    dataSource: data,
                    xValueMapper: (Stock stock, _) => stock.datetime,
                    lowValueMapper: (Stock stock, _) => stock.low,
                    highValueMapper: (Stock stock, _) => stock.high,
                    openValueMapper: (Stock stock, _) => stock.open,
                    closeValueMapper: (Stock stock, _) => stock.close,
                    volumeValueMapper: (Stock stock, _) => stock.volume,
                    name: "Stock"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: listpointmedia,
                    width: 2,
                    yAxisName: 'secondyaxis',
                    color: Colors.yellow,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    name: "Média A/D"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: listpointAd,
                    yAxisName: 'secondyaxis',
                    color: Colors.blue,
                    width: 2,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    name: "A/D"),
              ];

              indicadorchart = [];
              indicadorselecionado = indicadoropcao;
            } else {
              chartseries = [
                HiloOpenCloseSeries<Stock, dynamic>(
                    isVisibleInLegend: false,
                    enableTooltip: true,
                    dataSource: data,
                    xValueMapper: (Stock stock, _) => stock.datetime,
                    lowValueMapper: (Stock stock, _) => stock.low,
                    highValueMapper: (Stock stock, _) => stock.high,
                    openValueMapper: (Stock stock, _) => stock.open,
                    closeValueMapper: (Stock stock, _) => stock.close,
                    volumeValueMapper: (Stock stock, _) => stock.volume,
                    name: "Stock"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: listpointAd,
                    yAxisName: 'secondyaxis',
                    color: Colors.blue,
                    width: 4,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    name: "A/D")
              ];
            }

            indicadorchart = [];
            indicadorselecionado = indicadoropcao;
          });
        }
        break;
      case 2:
        {}
        break;
      case 3:
        {
          int periodo = indicadoropcao.parametro["periodo"];
          int sequencia = indicadoropcao.parametro["periodo"];
          List<Stock> list = createIntervalStock((periodo + sequencia));

          {
            setState(() {
              chartseries = [
                HiloOpenCloseSeries<Stock, dynamic>(
                    isVisibleInLegend: false,
                    enableTooltip: true,
                    dataSource: list,
                    xValueMapper: (Stock stock, _) => stock.datetime,
                    lowValueMapper: (Stock stock, _) => stock.low,
                    highValueMapper: (Stock stock, _) => stock.high,
                    openValueMapper: (Stock stock, _) => stock.open,
                    closeValueMapper: (Stock stock, _) => stock.close,
                    name: "Stock"),
              ];

              indicadorchart = [
                BollingerBandIndicator<Stock, dynamic>(
                    seriesName: "Stock",
                    period: indicadoropcao.parametro["periodo"],
                    standardDeviation: indicadoropcao.parametro["desvio"],
                    name: "Bollinger Bands")
              ];
              indicadorselecionado = indicadoropcao;
            });
          }
          break;
        }
        break;
      case 4:
        {
          if (indicadoropcao.configselecionado.id == "ema7" ||
              indicadoropcao.configselecionado.id == "ema8") {
            num periodo = indicadoropcao.parametro["periodo"];
            num periodolongo = indicadoropcao.parametro["periodolongo"];
            String medialonga = "$id:$periodo:$periodolongo";
            String mediacurta = key;

            List<DataPoint> datapointsmedialonga =
                createIntervalStockMedia(20, map.mapEma[medialonga]);
            List<DataPoint> datapointsmediacurta =
                createIntervalStockMedia(20, map.mapEma[mediacurta]);

            // [green, blue]
            setState(() {
              chartseries = [
                HiloOpenCloseSeries<Stock, dynamic>(
                    isVisibleInLegend: false,
                    enableTooltip: true,
                    dataSource: data,
                    xValueMapper: (Stock stock, _) => stock.datetime,
                    lowValueMapper: (Stock stock, _) => stock.low,
                    highValueMapper: (Stock stock, _) => stock.high,
                    openValueMapper: (Stock stock, _) => stock.open,
                    closeValueMapper: (Stock stock, _) => stock.close,
                    name: "Stock"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: datapointsmedialonga,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    color: Colors.red,
                    width: 4.0,
                    name: "Média E. longa"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: datapointsmediacurta,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    color: Colors.blueAccent,
                    width: 2.0,
                    name: "Média E. curta")
              ];

              indicadorchart = [];

              indicadorselecionado = indicadoropcao;
            });
          } else {
            List<DataPoint> list =
                createIntervalStockMedia(20, map.mapEma[key]);
            // [green, blue]
            setState(() {
              chartseries = [
                HiloOpenCloseSeries<Stock, dynamic>(
                    isVisibleInLegend: false,
                    enableTooltip: true,
                    dataSource: data,
                    xValueMapper: (Stock stock, _) => stock.datetime,
                    lowValueMapper: (Stock stock, _) => stock.low,
                    highValueMapper: (Stock stock, _) => stock.high,
                    openValueMapper: (Stock stock, _) => stock.open,
                    closeValueMapper: (Stock stock, _) => stock.close,
                    name: "Stock"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: list,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    name: "Média exponencial")
              ];

              indicadorchart = [];

              indicadorselecionado = indicadoropcao;
            });
          }
        }
        break;
      case 5:
        {
          int period = indicadoropcao.parametro["periodo"];
          int fastPeriod = indicadoropcao.parametro["periodolento"];
          int len = fastPeriod + period - 2;
          List<Stock> list = createIntervalStock(len * 2);

          setState(() {
            chartseries = [
              HiloOpenCloseSeries<Stock, dynamic>(
                  isVisibleInLegend: false,
                  enableTooltip: true,
                  dataSource: list,
                  xValueMapper: (Stock stock, _) => stock.datetime,
                  lowValueMapper: (Stock stock, _) => stock.low,
                  highValueMapper: (Stock stock, _) => stock.high,
                  openValueMapper: (Stock stock, _) => stock.open,
                  closeValueMapper: (Stock stock, _) => stock.close,
                  name: "Stock"),
            ];

            indicadorchart = [
              MacdIndicator<dynamic, dynamic>(
                  seriesName: 'Stock',
                  period: indicadoropcao.parametro["periodo"],
                  shortPeriod: indicadoropcao.parametro["periodorapido"],
                  longPeriod: indicadoropcao.parametro["periodolento"],
                  yAxisName: "secondyaxis",
                  name: "Macd")
            ];
            indicadorselecionado = indicadoropcao;
          });
        }
        break;
      case 6:
        {}
        break;
      case 7:
        {
          setState(() {
            chartseries = [
              HiloOpenCloseSeries<Stock, dynamic>(
                  isVisibleInLegend: false,
                  enableTooltip: true,
                  dataSource: data,
                  xValueMapper: (Stock stock, _) => stock.datetime,
                  lowValueMapper: (Stock stock, _) => stock.low,
                  highValueMapper: (Stock stock, _) => stock.high,
                  openValueMapper: (Stock stock, _) => stock.open,
                  closeValueMapper: (Stock stock, _) => stock.close,
                  name: "Stock"),
            ];

            indicadorchart = [
              RsiIndicator<dynamic, dynamic>(
                  seriesName: 'Stock',
                  period: indicadoropcao.parametro["periodo"],
                  overbought:
                      indicadoropcao.parametro["sobrecomprado"].toDouble(),
                  oversold: indicadoropcao.parametro["sobrevendido"].toDouble(),
                  yAxisName: "secondyaxis",
                  name: "Ifr")
            ];
            indicadorselecionado = indicadoropcao;
          });
        }
        break;
      case 8:
        {
          if (indicadoropcao.configselecionado.id == "media7" ||
              indicadoropcao.configselecionado.id == "media8") {
            num periodo = indicadoropcao.parametro["periodo"];
            num periodolongo = indicadoropcao.parametro["periodolongo"];
            String medialonga = "$id:$periodo:$periodolongo";
            String mediacurta = key;

            List<DataPoint> datapointsmedialonga =
                createIntervalStockMedia(20, map.mapSma[medialonga]);
            List<DataPoint> datapointsmediacurta =
                createIntervalStockMedia(20, map.mapSma[mediacurta]);

            // [green, blue]
            setState(() {
              chartseries = [
                HiloOpenCloseSeries<Stock, dynamic>(
                    isVisibleInLegend: false,
                    enableTooltip: true,
                    dataSource: data,
                    xValueMapper: (Stock stock, _) => stock.datetime,
                    lowValueMapper: (Stock stock, _) => stock.low,
                    highValueMapper: (Stock stock, _) => stock.high,
                    openValueMapper: (Stock stock, _) => stock.open,
                    closeValueMapper: (Stock stock, _) => stock.close,
                    name: "Stock"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: datapointsmedialonga,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    color: Colors.red,
                    width: 4.0,
                    name: "Média longa"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: datapointsmediacurta,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    color: Colors.blueAccent,
                    width: 2.0,
                    name: "Média curta")
              ];

              indicadorchart = [];

              indicadorselecionado = indicadoropcao;
            });
          } else {
            List<DataPoint> list =
                createIntervalStockMedia(20, map.mapSma[key]);
            // [green, blue]
            setState(() {
              chartseries = [
                HiloOpenCloseSeries<Stock, dynamic>(
                    isVisibleInLegend: false,
                    enableTooltip: true,
                    dataSource: data,
                    xValueMapper: (Stock stock, _) => stock.datetime,
                    lowValueMapper: (Stock stock, _) => stock.low,
                    highValueMapper: (Stock stock, _) => stock.high,
                    openValueMapper: (Stock stock, _) => stock.open,
                    closeValueMapper: (Stock stock, _) => stock.close,
                    name: "Stock"),
                LineSeries<DataPoint, dynamic>(
                    dataSource: list,
                    xValueMapper: (DataPoint point, _) => point.x,
                    yValueMapper: (DataPoint point, _) => point.y,
                    name: "Média")
              ];

              indicadorchart = [];

              indicadorselecionado = indicadoropcao;
            });
          }
        }
        break;
      case 9:
        {
          setState(() {
            chartseries = [
              HiloOpenCloseSeries<Stock, dynamic>(
                  isVisibleInLegend: false,
                  enableTooltip: true,
                  dataSource: data,
                  xValueMapper: (Stock stock, _) => stock.datetime,
                  lowValueMapper: (Stock stock, _) => stock.low,
                  highValueMapper: (Stock stock, _) => stock.high,
                  openValueMapper: (Stock stock, _) => stock.open,
                  closeValueMapper: (Stock stock, _) => stock.close,
                  name: "Stock"),
            ];

            indicadorchart = [
              StochasticIndicator<dynamic, dynamic>(
                  seriesName: 'Stock',
                  kPeriod: indicadoropcao.parametro["k"],
                  dPeriod: indicadoropcao.parametro["d"],
                  period: indicadoropcao.parametro["periodo"],
                  periodLineWidth: 5.0,
                  yAxisName: "secondyaxis",
                  name: "Estocástico")
            ];
            indicadorselecionado = indicadoropcao;
          });
        }
        break;
      case 14:
        {
          switch (indicadoropcao.configselecionado.id) {
            case "saida5":
              String keymodified = "$id:$periodo:atr";
              num constanteAtr = indicadoropcao.parametro["fatorAtr"];
              print(map.mapAtr[keymodified].runtimeType);
              List<DataPoint> mapAtrList = map.mapAtr[keymodified];
              List<DataPoint> newlist = [];

              for (int i = 0; i < mapAtrList.length; i++) {
                if (i == 0) {
                  DataPoint element = mapAtrList[i];
                  DataPoint deslocado = mapAtrList[i];
                  newlist.add(DataPoint(
                      x: element.x,
                      y: (deslocado.stock.close + (deslocado.y * constanteAtr)),
                      stock: deslocado.stock,
                      index: deslocado.index));
                } else {
                  DataPoint element = mapAtrList[i];
                  DataPoint deslocado = mapAtrList[i - 1];
                  newlist.add(DataPoint(
                      x: element.x,
                      y: (deslocado.stock.close + (deslocado.y * constanteAtr)),
                      stock: deslocado.stock,
                      index: deslocado.index));
                }
              }

              List<DataPoint> list = createIntervalStockMedia(20, newlist);
              // [green, blue]
              setState(() {
                chartseries = [
                  HiloOpenCloseSeries<Stock, dynamic>(
                      isVisibleInLegend: false,
                      enableTooltip: true,
                      dataSource: data,
                      xValueMapper: (Stock stock, _) => stock.datetime,
                      lowValueMapper: (Stock stock, _) => stock.low,
                      highValueMapper: (Stock stock, _) => stock.high,
                      openValueMapper: (Stock stock, _) => stock.open,
                      closeValueMapper: (Stock stock, _) => stock.close,
                      name: "Stock"),
                  LineSeries<DataPoint, dynamic>(
                      dataSource: list,
                      xValueMapper: (DataPoint point, _) => point.x,
                      yValueMapper: (DataPoint point, _) => point.y)
                ];

                indicadorchart = [];

                indicadorselecionado = indicadoropcao;
              });
              break;
            case "saida6":
              String keymodified = "$id:$periodo:atr";
              num constanteAtr = indicadoropcao.parametro["fatorAtr"];
              List<DataPoint> mapAtrList = map.mapAtr[keymodified];
              List<DataPoint> newlist = [];

              for (int i = 0; i < mapAtrList.length; i++) {
                if (i == 0) {
                  DataPoint element = mapAtrList[i];
                  DataPoint deslocado = mapAtrList[i];
                  newlist.add(DataPoint(
                      x: element.x,
                      y: (deslocado.stock.close - (deslocado.y * constanteAtr)),
                      stock: deslocado.stock,
                      index: deslocado.index));
                } else {
                  DataPoint element = mapAtrList[i];
                  DataPoint deslocado = mapAtrList[i - 1];
                  newlist.add(DataPoint(
                      x: element.x,
                      y: (deslocado.stock.close - (deslocado.y * constanteAtr)),
                      stock: deslocado.stock,
                      index: deslocado.index));
                }
              }

              List<DataPoint> list = createIntervalStockMedia(20, newlist);
              // [green, blue]
              setState(() {
                chartseries = [
                  HiloOpenCloseSeries<Stock, dynamic>(
                      isVisibleInLegend: false,
                      enableTooltip: true,
                      dataSource: data,
                      xValueMapper: (Stock stock, _) => stock.datetime,
                      lowValueMapper: (Stock stock, _) => stock.low,
                      highValueMapper: (Stock stock, _) => stock.high,
                      openValueMapper: (Stock stock, _) => stock.open,
                      closeValueMapper: (Stock stock, _) => stock.close,
                      name: "Stock"),
                  LineSeries<DataPoint, dynamic>(
                      dataSource: list,
                      xValueMapper: (DataPoint point, _) => point.x,
                      yValueMapper: (DataPoint point, _) => point.y,
                      name: "Atr")
                ];

                indicadorchart = [];

                indicadorselecionado = indicadoropcao;
              });
              break;
            case "saida7":
              String keymodified = "$id:$periodo:close";
              List<DataPoint> list =
                  createIntervalStockMedia(20, map.mapSma[keymodified]);
              // [green, blue]
              setState(() {
                chartseries = [
                  HiloOpenCloseSeries<Stock, dynamic>(
                      isVisibleInLegend: false,
                      enableTooltip: true,
                      dataSource: data,
                      xValueMapper: (Stock stock, _) => stock.datetime,
                      lowValueMapper: (Stock stock, _) => stock.low,
                      highValueMapper: (Stock stock, _) => stock.high,
                      openValueMapper: (Stock stock, _) => stock.open,
                      closeValueMapper: (Stock stock, _) => stock.close,
                      name: "Stock"),
                  LineSeries<DataPoint, dynamic>(
                      dataSource: list,
                      xValueMapper: (DataPoint point, _) => point.x,
                      yValueMapper: (DataPoint point, _) => point.y,
                      name: "Média")
                ];

                indicadorchart = [];

                indicadorselecionado = indicadoropcao;
              });
              break;
            case "saida8":
              String keymodified = "$id:$periodo:high";
              List<DataPoint> list =
                  createIntervalStockMedia(20, map.mapSma[keymodified]);
              // [green, blue]
              setState(() {
                chartseries = [
                  HiloOpenCloseSeries<Stock, dynamic>(
                      isVisibleInLegend: false,
                      enableTooltip: true,
                      dataSource: data,
                      xValueMapper: (Stock stock, _) => stock.datetime,
                      lowValueMapper: (Stock stock, _) => stock.low,
                      highValueMapper: (Stock stock, _) => stock.high,
                      openValueMapper: (Stock stock, _) => stock.open,
                      closeValueMapper: (Stock stock, _) => stock.close,
                      name: "Stock"),
                  LineSeries<DataPoint, dynamic>(
                      dataSource: list,
                      xValueMapper: (DataPoint point, _) => point.x,
                      yValueMapper: (DataPoint point, _) => point.y,
                      name: "Média")
                ];

                indicadorchart = [];

                indicadorselecionado = indicadoropcao;
              });
              break;
            case "saida9":
              String keymodified = "$id:$periodo:low";
              List<DataPoint> list =
                  createIntervalStockMedia(20, map.mapSma[keymodified]);
              // [green, blue]
              setState(() {
                chartseries = [
                  HiloOpenCloseSeries<Stock, dynamic>(
                      isVisibleInLegend: false,
                      enableTooltip: true,
                      dataSource: data,
                      xValueMapper: (Stock stock, _) => stock.datetime,
                      lowValueMapper: (Stock stock, _) => stock.low,
                      highValueMapper: (Stock stock, _) => stock.high,
                      openValueMapper: (Stock stock, _) => stock.open,
                      closeValueMapper: (Stock stock, _) => stock.close,
                      name: "Stock"),
                  LineSeries<DataPoint, dynamic>(
                      dataSource: list,
                      xValueMapper: (DataPoint point, _) => point.x,
                      yValueMapper: (DataPoint point, _) => point.y,
                      name: "Média")
                ];

                indicadorchart = [];

                indicadorselecionado = indicadoropcao;
              });
              break;
          }
        }
        break;
    }
  }

  List<Stock> generateData() {
    try {
      List<Stock> list = createIntervalStock(20);
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
          legend: Legend(
              toggleSeriesVisibility: true,
              textStyle: TextStyle(color: AppColors.white),
              // Visibility of legend
              isVisible: true),
          annotations: <CartesianChartAnnotation>[
            CartesianChartAnnotation(
                widget: Container(
                    child: const Text(
                  'Buy',
                  style: TextStyle(color: AppColors.white),
                )),
                coordinateUnit: CoordinateUnit.point,
                x: trade.entrada.datetime,
                y: trade.entrada.close),
            CartesianChartAnnotation(
                widget: Container(
                    child: const Text(
                  'Sell',
                  style: TextStyle(color: AppColors.white),
                )),
                coordinateUnit: CoordinateUnit.point,
                x: trade.saida.datetime,
                y: trade.saida.close),
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
              y: (getmax(data) * 1.10 + getmin(data)) / 2,
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
            maximum: getmax(data) * 1.10,
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
          indicators: indicadorchart,
          series: chartseries),
    );
  }

  List<Widget> _buildCondicao(signals, type) {
    Text text;
    if (type == "buy") {
      text = Text(
        "Compra condição",
        style: TextStyle(color: AppColors.white, fontSize: 15),
      );
    } else {
      text = Text(
        "Venda condição",
        style: TextStyle(color: AppColors.white, fontSize: 15),
      );
    }
    List<Widget> listcondicao = [text];
    signals.forEach((IndicadoresOpcao indicadoropcao) {
      if (indicadoropcao.id == 13) {
        int len = indicadoropcao.indicadoresopcoes.length;
        String texto = "ou";
        for (int i = 0; i < len; i++) {
          if (i + 1 == len) {
            texto = "";
          }
          IndicadoresOpcao opcao = indicadoropcao.indicadoresopcoes[i];
          listcondicao.add(Text(
            "${opcao.configselecionado.title} $texto",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.white, fontSize: 12),
          ));
        }
      } else {
        listcondicao.add(Text(
          "${indicadoropcao.configselecionado.title}",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.white, fontSize: 12),
        ));
      }
    });
    return listcondicao;
  }

  _buildCheckBoxItem(indicadoropcao) {
    return Card(
      child: Container(
        color: Colors.black,
        child: CheckboxListTile(
            checkColor: Colors.white,
            title: Text(
              "${indicadoropcao.name}:${indicadoropcao.parametro["periodo"]}",
              style: TextStyle(color: AppColors.white),
            ),
            value: indicadorselecionado == indicadoropcao,
            onChanged: (val) {
              setState(() {
                if (val) {
                  changeIndicatorSelected(indicadoropcao);
                }
              });
            }),
      ),
    );
  }

  List<Widget> _buildCheckBoxList(List<IndicadoresOpcao> signals) {
    List<Widget> checkboxes = [];

    signals.forEach((IndicadoresOpcao indicadoropcao) {
      // print(indicadoropcao.configselecionado.title);
      if (indicadoropcao.id == 13) {
        indicadoropcao.indicadoresopcoes
            .forEach((IndicadoresOpcao indicadoropcaoM) {
          if (indicadoropcaoM.configselecionado.checkbox) {
            checkboxes.add(_buildCheckBoxItem(indicadoropcaoM));
          } else {
            checkboxes.add(Container());
          }
        });
      } else {
        if (indicadoropcao.configselecionado.checkbox) {
          checkboxes.add(_buildCheckBoxItem(indicadoropcao));
        } else {
          checkboxes.add(Container());
        }
      }
    });

    return checkboxes;
  }

  _buildPageChart(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(children: _buildCheckBoxList(buysignals)),
                  ),
                  Flexible(
                    child: Column(children: _buildCheckBoxList(sellsignals)),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildChart(context),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Column(children: _buildCondicao(buysignals, "buy")),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child:
                        Column(children: _buildCondicao(sellsignals, "sell")),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildPageChart(context),
      ),
    );
  }
}
