import 'package:scouting/models/todo.dart';
import 'dart:math';

import 'package:scouting/provider/function.dart';

class LogicaBackTesting {
  static bool comparacaovalores(valor1, valor2) {
    if (valor1 > valor2) {
      return true;
    } else {
      return false;
    }
  }

  static bool verificaocondicao(
      IndicadoresOpcao indicadoropcao,
      num index,
      List<Stock> stocks,
      MapIndicadores map,
      Stock tradeEntrada,
      int indexEntrada) {
    Map<String, dynamic> mapSma = map.mapSma;
    Map<String, dynamic> mapStochastic = map.mapStochastic;
    Map<String, dynamic> mapIfr = map.mapIfr;
    Map<String, dynamic> mapMacd = map.mapMacd;
    Map<String, dynamic> mapBollinger = map.mapBollinger;
    Map<String, dynamic> mapAcumDist = map.mapAcumDist;
    Map<String, dynamic> mapEma = map.mapEma;
    Map<String, dynamic> mapAtr = map.mapAtr;

    num id = indicadoropcao.id;
    num periodo = indicadoropcao.parametro["periodo"] ?? 0;
    String key = "$id:$periodo";

    switch (indicadoropcao.id) {
      case 1:
        {
          num sequencia = indicadoropcao.parametro["sequencia"];
          if (index > sequencia) {
            DataPoint acumdist = mapAcumDist[key][index];
            DataPoint acumdistanterior = mapAcumDist[key][index - 1];

            switch (indicadoropcao.configselecionado.id) {

              ///AcumDist trending up
              case "acudis1":
                if (index - 1 > sequencia) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    if (mapAcumDist[key][start + i].y >
                        mapAcumDist[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;

              case "acudis2":

                ///AcumDist trending down

                if (index - 1 > sequencia) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    if (mapAcumDist[key][start + i].y <
                        mapAcumDist[key][start + i - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;

              case "acudis3":

                ///AcumDist turn up

                if (index - 1 > sequencia) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i <= sequencia; i++) {
                    if (i != sequencia) {
                      if (mapAcumDist[key][start + i].y <
                          mapAcumDist[key][start + i - 1].y) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    } else {
                      if (mapAcumDist[key][start + i].y >
                          mapAcumDist[key][start + i - 1].y) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }

                break;

              case "acudis4":

                ///AcumDist turn down

                if (index - 1 > sequencia) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i <= sequencia; i++) {
                    if (i != sequencia) {
                      if (mapAcumDist[key][start + i].y >
                          mapAcumDist[key][start + i - 1].y) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    } else {
                      if (mapAcumDist[key][start + i].y <
                          mapAcumDist[key][start + i - 1].y) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
              case "acudis5":
                String keymodified = "$id:$periodo:media";
                DataPoint mediaAD = mapAcumDist[keymodified][index];
                DataPoint mediaADanterior = mapAcumDist[keymodified][index - 1];
                if (index > periodo) {
                  ///Ad cruzou pra cima da media
                  num valor1 = acumdist.y;
                  num valor2 = acumdistanterior.y;
                  num valor3 = mediaAD.y;
                  num valor4 = mediaADanterior.y;

                  return (comparacaovalores(valor4, valor2) &&
                      comparacaovalores(valor1, valor3));
                } else {
                  return false;
                }

                break;
              case "acudis6":
                String keymodified = "$id:$periodo:media";
                DataPoint mediaAD = mapAcumDist[keymodified][index];
                DataPoint mediaADanterior = mapAcumDist[keymodified][index - 1];
                if (index > periodo) {
                  ///Ad cruzou pra baixo da media
                  num valor1 = acumdist.y;
                  num valor2 = acumdistanterior.y;
                  num valor3 = mediaAD.y;
                  num valor4 = mediaADanterior.y;

                  return (comparacaovalores(valor2, valor4) &&
                      comparacaovalores(valor3, valor1));
                } else {
                  return false;
                }

                break;
            }
          } else {
            return false;
          }
        }
        break;

      case 2:
        {}
        break;

      case 3:
        {
          num periodo = indicadoropcao.parametro["periodo"];
          num sequencia = indicadoropcao.parametro["sequencia"];
          if (index - 1 > periodo) {
            BollingerPointData bollingerpoint = mapBollinger[key][index];
            BollingerPointData bollingerpointanterior =
                mapBollinger[key][index - 1];

            switch (indicadoropcao.configselecionado.id) {

              ///Preço acima upperband
              case "bollinger1":
                num valor1 = stocks[index].close;
                num valor2 = bollingerpoint.upBand;

                return comparacaovalores(valor1, valor2);

                break;

              ///Preço abaixo upperband
              case "bollinger2":
                num valor1 = stocks[index].close;
                num valor2 = bollingerpoint.lowBand;

                return comparacaovalores(valor2, valor1);

                break;

              case "bollinger3":

                ///Preço cruza acima upperband
                num valor1 = stocks[index].close;
                num valor2 = stocks[index - 1].close;
                num valor3 = bollingerpoint.upBand;
                num valor4 = bollingerpointanterior.upBand;

                return (comparacaovalores(valor4, valor2) &&
                    comparacaovalores(valor1, valor3));
                break;

              case "bollinger4":

                ///Preço cruza abaixo upperband
                num valor1 = stocks[index].close;
                num valor2 = stocks[index - 1].close;
                num valor3 = bollingerpoint.upBand;
                num valor4 = bollingerpointanterior.upBand;

                return (comparacaovalores(valor2, valor4) &&
                    comparacaovalores(valor3, valor1));

                break;

              case "bollinger5":

                ///Preço cruza acima lowerband
                num valor1 = stocks[index].close;
                num valor2 = stocks[index - 1].close;
                num valor3 = bollingerpoint.lowBand;
                num valor4 = bollingerpointanterior.lowBand;

                return (comparacaovalores(valor1, valor3) &&
                    comparacaovalores(valor4, valor2));

                break;

              ///Preço cruza abaixo lowerband
              case "bollinger6":
                num valor1 = stocks[index].close;
                num valor2 = stocks[index - 1].close;
                num valor3 = bollingerpoint.lowBand;
                num valor4 = bollingerpointanterior.lowBand;

                return (comparacaovalores(valor2, valor4) &&
                    comparacaovalores(valor3, valor1));

                break;

              case "bollinger7":
                if (index > (periodo + sequencia)) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    if (mapBollinger[key][start + i].upBand <
                            mapBollinger[key][(start + i) - 1].upBand &&
                        mapBollinger[key][start + i].lowBand >
                            mapBollinger[key][(start + i) - 1].lowBand) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;

              case "bollinger8":
                if (index > (periodo + sequencia)) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    if (mapBollinger[key][start + i].upBand >
                            mapBollinger[key][(start + i) - 1].upBand &&
                        mapBollinger[key][start + i].lowBand <
                            mapBollinger[key][(start + i) - 1].lowBand) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
            }
          } else {
            return false;
          }
        }
        break;
      case 4:
        {
          num periodo = indicadoropcao.parametro['periodo'];
          num sequencia = indicadoropcao.parametro["sequencia"];
          if ((index - 1) > periodo) {
            num mediapoint = mapEma[key][index].y;
            num mediapointanterior = mapEma[key][index - 1].y;

            switch (indicadoropcao.configselecionado.id) {
              //if(fechamento[i] > media[i])
              case "ema1":
                num valor1 = stocks[index].close;
                num valor2 = mediapoint;
                return comparacaovalores(valor1, valor2);

                break;
              //if(media[i] > fechamento[i])
              case "ema2":
                num valor1 = mediapoint;
                num valor2 = stocks[index].close;
                return comparacaovalores(valor1, valor2);

                break;
              //"if(media[i] > media[i-1])"
              case "ema3":
                List<bool> booleansverify = [];
                int start = index - sequencia;
                for (num i = 0; i < sequencia; i++) {
                  if (mapEma[key][start + i].y >
                      mapEma[key][(start + i) - 1].y) {
                    booleansverify.add(true);
                  } else {
                    booleansverify.add(false);
                  }
                }

                num countbooleanbuy =
                    booleansverify.where((item) => item == false).length;
                if (countbooleanbuy == 0) {
                  return true;
                } else {
                  return false;
                }

                break;
              //"if(media[i-1] > media[i])"
              case "ema4":
                List<bool> booleansverify = [];
                int start = index - sequencia;
                for (num i = 0; i < sequencia; i++) {
                  if (mapEma[key][start + i].y <
                      mapEma[key][(start + i) - 1].y) {
                    booleansverify.add(true);
                  } else {
                    booleansverify.add(false);
                  }
                }

                num countbooleanbuy =
                    booleansverify.where((item) => item == false).length;
                if (countbooleanbuy == 0) {
                  return true;
                } else {
                  return false;
                }

                break;
              case "ema5":
                num valor1 = stocks[index].close;
                num valor2 = mediapointanterior;
                num valor3 = stocks[index - 1].close;
                return (comparacaovalores(valor1, valor2) &&
                    comparacaovalores(valor2, valor3));

                break;
              case "ema6":
                num valor1 = stocks[index].close;
                num valor2 = mediapoint;
                num valor3 = stocks[index - 1].close;
                return (comparacaovalores(valor3, valor2) &&
                    comparacaovalores(valor2, valor1));

                break;
              case "ema7":
                num id = indicadoropcao.id;
                num periodo = indicadoropcao.parametro["periodo"];
                num periodolongo = indicadoropcao.parametro["periodolongo"];
                String medialonga = "$id:$periodo:$periodolongo";

                if (index > periodolongo) {
                  num valor1 = mediapoint;
                  num valor2 = mapEma[medialonga][index].y;
                  num valor3 = mediapointanterior;
                  num valor4 = mapEma[medialonga][index - 1].y;

                  return (comparacaovalores(valor1, valor2) &&
                      comparacaovalores(valor4, valor3));
                } else {
                  return false;
                }

                break;
              case "ema8":
                num id = indicadoropcao.id;
                num periodo = indicadoropcao.parametro["periodo"];
                num periodolongo = indicadoropcao.parametro["periodolongo"];
                String medialonga = "$id:$periodo:$periodolongo";
                if (index > periodolongo) {
                  num valor1 = mediapoint;
                  num valor2 = mapEma[medialonga][index].y;

                  num valor3 = mediapointanterior;
                  num valor4 = mapEma[medialonga][index - 1].y;

                  return (comparacaovalores(valor3, valor4) &&
                      comparacaovalores(valor2, valor1));
                } else {
                  return false;
                }

                break;
              case "ema9":
                /////Média virou para baixo após sequência de trending up
                List<bool> booleansverify = [];
                int start = index - sequencia;
                for (num i = 0; i <= sequencia; i++) {
                  if (i != sequencia) {
                    if (mapEma[key][start + i].y >
                        mapEma[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  } else {
                    if (mapEma[key][start + i].y <
                        mapEma[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }
                }

                num countbooleanbuy =
                    booleansverify.where((item) => item == false).length;
                if (countbooleanbuy == 0) {
                  // for (num i = 0; i <= sequencia; i++) {
                  //    print(mapEma[key][start + i].y);
                  //  }
                  //  print("//////////////////");
                  return true;
                } else {
                  return false;
                }
                break;
              case "ema10":

                /////Média virou para cima após sequência de trending down
                List<bool> booleansverify = [];
                int start = index - sequencia;
                for (num i = 0; i <= sequencia; i++) {
                  if (i != sequencia) {
                    if (mapEma[key][start + i].y <
                        mapEma[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  } else {
                    if (mapEma[key][start + i].y >
                        mapEma[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }
                }

                num countbooleanbuy =
                    booleansverify.where((item) => item == false).length;
                if (countbooleanbuy == 0) {
                  //  for (num i = 0; i <= sequencia; i++) {
                  //    print(mapEma[key][start + i].y);
                  //  }
                  //  print("//////////////////");
                  return true;
                } else {
                  return false;
                }

                break;
            }
          }
        }
        break;
      case 5:
        {
          num sequencia = indicadoropcao.parametro["sequencia"];
          num periodo = indicadoropcao.parametro["periodo"];
          num fastPeriod = indicadoropcao.parametro["periodolento"];
          num len = fastPeriod + periodo - 2;

          if ((index - 1) > len) {
            DataPoint macdCollection = mapMacd[key]["macdCollection"][index];
            DataPoint signalCollection =
                mapMacd[key]["signalCollection"][index];
            DataPoint histogramCollection =
                mapMacd[key]["histogramCollection"][index];

            DataPoint macdCollectionanterior =
                mapMacd[key]["macdCollection"][index - 1];
            DataPoint signalCollectionanterior =
                mapMacd[key]["signalCollection"][index - 1];
            DataPoint histogramCollectionanterior =
                mapMacd[key]["histogramCollection"][index - 1];

            switch (indicadoropcao.configselecionado.id) {
              //Macd cruzou acima signal line
              case "macd1":
                num valor1 = macdCollection.y;

                num valor2 = signalCollection.y;

                num valor3 = macdCollectionanterior.y;

                num valor4 = signalCollectionanterior.y;

                return (comparacaovalores(valor1, valor2) &&
                    comparacaovalores(valor4, valor3));

                break;
              //Macd cruzou abaixo signal line
              case "macd2":
                num valor1 = macdCollection.y;

                num valor2 = signalCollection.y;

                num valor3 = macdCollectionanterior.y;

                num valor4 = signalCollectionanterior.y;

                return (comparacaovalores(valor3, valor4) &&
                    comparacaovalores(valor2, valor1));
                break;
              //Macd cruzou acima de zero

              case "macd3":
                num valor1 = histogramCollection.y;

                return comparacaovalores(valor1, 0);

                break;
              //Macd cruzou abaixo de zero
              case "macd4":
                num valor1 = histogramCollection.y;

                return comparacaovalores(0, valor1);
                break;
              //Macd cruzou abaixo de zero
              case "macd5":
                /////Exaustao de compra apos (n) periodos
                if ((index > len + sequencia)) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i <= sequencia; i++) {
                    DataPoint macdPoint =
                        mapMacd[key]["macdCollection"][start + i];
                    DataPoint signalPoint =
                        mapMacd[key]["signalCollection"][start + i];
                    DataPoint histogramPoint =
                        mapMacd[key]["histogramCollection"][start + i];

                    DataPoint histogramPoint1 =
                        mapMacd[key]["histogramCollection"][(start + i) - 1];

                    if (i != sequencia) {
                      if (macdPoint.y > 0 &&
                          signalPoint.y > 0 &&
                          histogramPoint.y > 0) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    } else {
                      if (macdPoint.y > 0 &&
                          signalPoint.y > 0 &&
                          histogramPoint.y < 0) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
              //Macd cruzou abaixo de zero
              case "macd6":
                /////Exaustao de venda apos (n) periodos
                if ((index > len + sequencia)) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i <= sequencia; i++) {
                    DataPoint macdPoint =
                        mapMacd[key]["macdCollection"][start + i];
                    DataPoint signalPoint =
                        mapMacd[key]["signalCollection"][start + i];
                    DataPoint histogramPoint =
                        mapMacd[key]["histogramCollection"][start + i];

                    DataPoint histogramPoint1 =
                        mapMacd[key]["histogramCollection"][(start + i) - 1];

                    if (i != sequencia) {
                      if (macdPoint.y < 0 &&
                          signalPoint.y < 0 &&
                          histogramPoint.y < 0) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    } else {
                      if (macdPoint.y < 0 &&
                          signalPoint.y < 0 &&
                          histogramPoint.y > 0) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    for (num i = 0; i <= sequencia; i++) {
                      print(
                          "MacdPoint:${mapMacd[key]["macdCollection"][start + i].y}/////signalPoint:${mapMacd[key]["signalCollection"][start + i].y}/////histogramPoint:${mapMacd[key]["histogramCollection"][start + i].y}");
                    }
                    print("//////////////////");
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
              case "macd7":
                /////Histogram sequencia de alta
                if ((index > len + sequencia)) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    DataPoint histogramPoint =
                        mapMacd[key]["histogramCollection"][start + i];

                    DataPoint histogramPoint1 =
                        mapMacd[key]["histogramCollection"][(start + i) - 1];
                    if (histogramPoint.y > histogramPoint1.y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
              case "macd8":
                /////Histogram sequencia de queda
                if ((index > len + sequencia)) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    DataPoint histogramPoint =
                        mapMacd[key]["histogramCollection"][start + i];
                    DataPoint histogramPoint1 =
                        mapMacd[key]["histogramCollection"][(start + i) - 1];

                    if (histogramPoint.y < histogramPoint1.y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
              case "macd9":
                /////Histogram sequencia de alta acima de 0
                if ((index > len + sequencia)) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    DataPoint histogramPoint =
                        mapMacd[key]["histogramCollection"][start + i];
                    DataPoint histogramPoint1 =
                        mapMacd[key]["histogramCollection"][(start + i) - 1];

                    if (histogramPoint.y > histogramPoint1.y &&
                        histogramPoint.y > 0) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
              case "macd10":
                /////Histogram sequencia de queda abaixo de 0
                if ((index > len + sequencia)) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    DataPoint histogramPoint =
                        mapMacd[key]["histogramCollection"][start + i];
                    DataPoint histogramPoint1 =
                        mapMacd[key]["histogramCollection"][(start + i) - 1];

                    if (histogramPoint.y < histogramPoint1.y &&
                        histogramPoint.y < 0) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
            }
          } else {
            return false;
          }
        }
        break;

      case 6:
        {}
        break;

      case 7:
        {
          num periodo = indicadoropcao.parametro["periodo"];

          if (index - 1 > periodo) {
            DataPoint datapoint = mapIfr[key][index];
            DataPoint datapointanterior = mapIfr[key][index - 1];

            switch (indicadoropcao.configselecionado.id) {
              //Entrou na zona de sobrecompra
              //y anterior menor que valor de sobrecompra e y atual maior que valor de zombrecompra
              case "ifr1":
                num valor1 = datapointanterior.y;

                num valor2 = indicadoropcao.parametro['sobrecomprado'];

                num valor3 = datapoint.y;

                return (comparacaovalores(valor2, valor1) &&
                    comparacaovalores(valor3, valor2));

                break;
              //Saiu da Zona de Sobrecompra
              //y anterior maior que valor de sobrecompra e y atual menor que valor de zombrecompra
              case "ifr2":
                num valor1 = datapointanterior.y;
                num valor2 = indicadoropcao.parametro['sobrecomprado'];
                num valor3 = datapoint.y;
                // if(comparacaovalores(valor1, valor2) &&
                //     comparacaovalores(valor2, valor3)){
                //       print("Sobrecomprado:${datapoint.x}:::::::: Valor anterior:$valor1///Valor Atual:$valor3 ");
                //     }
                return (comparacaovalores(valor1, valor2) &&
                    comparacaovalores(valor2, valor3));
                break;
              //Entro na zona de sobrevenda
              //y anterior maior que valor de sobrevenda e y atual menor que valor de sobrevenda
              case "ifr3":
                num valor1 = datapointanterior.y;
                num valor2 = indicadoropcao.parametro['sobrevendido'];
                num valor3 = datapoint.y;

                if (comparacaovalores(valor1, valor2) &&
                    comparacaovalores(valor2, valor3)) {
                  print(
                      "Sobrecomprado:${datapoint.x}:::::::: Valor anterior:$valor1///Valor Atual:$valor3 ");
                }

                return (comparacaovalores(valor1, valor2) &&
                    comparacaovalores(valor2, valor3));
                break;
              //Saiu da zona de sobrevenda
              //y anterior menor que valor de sobrevenda e y atual maior que valor de sobrevenda
              case "ifr4":
                num valor1 = datapointanterior.y;

                num valor2 = indicadoropcao.parametro['sobrevendido'];

                num valor3 = datapoint.y;

                return (comparacaovalores(valor2, valor1) &&
                    comparacaovalores(valor3, valor2));
                break;
              case "ifr5":
                num valor1 = datapoint.y;

                num valor2 = indicadoropcao.parametro['sobrecomprado'];

                return comparacaovalores(valor1, valor2);
                break;
              case "ifr6":
                num valor1 = datapoint.y;

                num valor2 = indicadoropcao.parametro['sobrevendido'];

                return comparacaovalores(valor2, valor1);
                break;
            }
          } else {
            return false;
          }
        }
        break;

      case 8:
        {
          num periodo = indicadoropcao.parametro['periodo'];
          num sequencia = indicadoropcao.parametro["sequencia"];

          if ((index - 1) > periodo) {
            num mediapoint = mapSma[key][index].y;
            num mediapointanterior = mapSma[key][index - 1].y;

            switch (indicadoropcao.configselecionado.id) {
              //if(fechamento[i] > media[i])
              case "media1":
                num valor1 = stocks[index].close;
                num valor2 = mediapoint;
                return comparacaovalores(valor1, valor2);

                break;
              //if(media[i] > fechamento[i])
              case "media2":
                num valor1 = mediapoint;
                num valor2 = stocks[index].close;
                return comparacaovalores(valor1, valor2);

                break;
              //"if(media[i] > media[i-1])"
              case "media3":
                List<bool> booleansverify = [];
                int start = index - sequencia;
                for (num i = 0; i < sequencia; i++) {
                  if (mapSma[key][start + i].y >
                      mapSma[key][(start + i) - 1].y) {
                    booleansverify.add(true);
                  } else {
                    booleansverify.add(false);
                  }
                }

                num countbooleanbuy =
                    booleansverify.where((item) => item == false).length;
                if (countbooleanbuy == 0) {
                  return true;
                } else {
                  return false;
                }

                break;
              //"if(media[i-1] > media[i])"
              case "media4":
                List<bool> booleansverify = [];
                int start = index - sequencia;
                for (num i = 0; i < sequencia; i++) {
                  if (mapSma[key][start + i].y <
                      mapSma[key][(start + i) - 1].y) {
                    booleansverify.add(true);
                  } else {
                    booleansverify.add(false);
                  }
                }

                num countbooleanbuy =
                    booleansverify.where((item) => item == false).length;
                if (countbooleanbuy == 0) {
                  return true;
                } else {
                  return false;
                }
                break;
              case "media5":
                num valor1 = stocks[index].close;
                num valor2 = mediapointanterior;
                num valor3 = stocks[index - 1].close;
                return (comparacaovalores(valor1, valor2) &&
                    comparacaovalores(valor2, valor3));

                break;
              case "media6":
                num valor1 = stocks[index].close;
                num valor2 = mediapoint;
                num valor3 = stocks[index - 1].close;
                return (comparacaovalores(valor3, valor2) &&
                    comparacaovalores(valor2, valor1));

                break;
              case "media7":
                num id = indicadoropcao.id;
                num periodo = indicadoropcao.parametro["periodo"];
                num periodolongo = indicadoropcao.parametro["periodolongo"];
                String medialonga = "$id:$periodo:$periodolongo";
                if (index > periodolongo) {
                  num valor1 = mediapoint;
                  num valor2 = mapSma[medialonga][index].y;
                  num valor3 = mediapointanterior;
                  num valor4 = mapSma[medialonga][index - 1].y;

                  return (comparacaovalores(valor1, valor2) &&
                      comparacaovalores(valor4, valor3));
                } else {
                  return false;
                }

                break;
              case "media8":
                num id = indicadoropcao.id;
                num periodo = indicadoropcao.parametro["periodo"];
                num periodolongo = indicadoropcao.parametro["periodolongo"];
                String medialonga = "$id:$periodo:$periodolongo";

                if (index > periodolongo) {
                  num valor1 = mediapoint;
                  num valor2 = mapSma[medialonga][index].y;

                  num valor3 = mediapointanterior;
                  num valor4 = mapSma[medialonga][index - 1].y;

                  return (comparacaovalores(valor3, valor4) &&
                      comparacaovalores(valor2, valor1));
                } else {
                  return false;
                }

                break;

              case "media9":
                /////Média virou para baixo após sequência de trending up
                List<bool> booleansverify = [];
                int start = index - sequencia;
                for (num i = 0; i <= sequencia; i++) {
                  if (i != sequencia) {
                    if (mapSma[key][start + i].y >
                        mapSma[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  } else {
                    if (mapSma[key][start + i].y <
                        mapSma[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }
                }

                num countbooleanbuy =
                    booleansverify.where((item) => item == false).length;
                if (countbooleanbuy == 0) {
                  // for (num i = 0; i <= sequencia; i++) {
                  //    print(mapEma[key][start + i].y);
                  //  }
                  //  print("//////////////////");
                  return true;
                } else {
                  return false;
                }
                break;
              case "media10":

                /////Média virou para cima após sequência de trending down
                List<bool> booleansverify = [];
                int start = index - sequencia;
                for (num i = 0; i <= sequencia; i++) {
                  if (i != sequencia) {
                    if (mapSma[key][start + i].y <
                        mapSma[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  } else {
                    if (mapSma[key][start + i].y >
                        mapSma[key][(start + i) - 1].y) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }
                }

                num countbooleanbuy =
                    booleansverify.where((item) => item == false).length;
                if (countbooleanbuy == 0) {
                  //  for (num i = 0; i <= sequencia; i++) {
                  //    print(mapEma[key][start + i].y);
                  //  }
                  //  print("//////////////////");
                  return true;
                } else {
                  return false;
                }

                break;
            }
          }
        }
        break;

      case 9:
        {
          num periodo = indicadoropcao.parametro["periodo"];
          num sequencia = indicadoropcao.parametro['sequencia'];
          num sobrecomprado = indicadoropcao.parametro['sobrecomprado'];
          num sobrevendido = indicadoropcao.parametro['sobrevendido'];
          num k = indicadoropcao.parametro["k"];

          if (index - 1 > periodo) {
            DataPoint datapoint = mapStochastic[key]["periodCollection"][index];
            DataPoint datapointanterior =
                mapStochastic[key]["periodCollection"][index - 1];

            switch (indicadoropcao.configselecionado.id) {
              //Entrou na zona de sobrecompra
              //y anterior menor que valor de sobrecompra e y atual maior que valor de zombrecompra

              //Sobrecomprado e SobreVendido sao valores fixos entao nao preciso pegar o valor anterior para comparar

              case "stochastic1":
                num valor1 = datapointanterior.y;

                num valor2 = sobrecomprado;

                num valor3 = datapoint.y;

                return (comparacaovalores(valor2, valor1) &&
                    comparacaovalores(valor3, valor2));

                break;
              //Saiu da Zona de Sobrecompra
              //y anterior maior que valor de sobrecompra e y atual menor que valor de zombrecompra
              case "stochastic2":
                num valor1 = datapointanterior.y;
                num valor2 = sobrecomprado;
                num valor3 = datapoint.y;

                return (comparacaovalores(valor1, valor2) &&
                    comparacaovalores(valor2, valor3));
                break;
              //Entro na zona de sobrevenda
              //y anterior maior que valor de sobrevenda e y atual menor que valor de sobrevenda
              case "stochastic3":
                num valor1 = datapointanterior.y;
                num valor2 = sobrevendido;
                num valor3 = datapoint.y;

                return (comparacaovalores(valor1, valor2) &&
                    comparacaovalores(valor2, valor3));
                break;
              //Saiu da zona de sobrevenda
              //y anterior menor que valor de sobrevenda e y atual maior que valor de sobrevenda
              case "stochastic4":
                num valor1 = datapointanterior.y;

                num valor2 = sobrevendido;

                num valor3 = datapoint.y;

                return (comparacaovalores(valor2, valor1) &&
                    comparacaovalores(valor3, valor2));
                break;
              case "stochastic5":
                num valor1 = datapoint.y;

                num valor2 = sobrecomprado;

                return comparacaovalores(valor1, valor2);
                break;
              case "stochastic6":
                num valor1 = datapoint.y;

                num valor2 = sobrevendido;

                return comparacaovalores(valor2, valor1);
                break;
              case "stochastic7":
                if (index > (periodo + sequencia)) {
                  /////Sobrecomprado ha (n) periodos
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    DataPoint stochasticpoint =
                        mapStochastic[key]["periodCollection"][start + i];

                    if (stochasticpoint.y > sobrecomprado) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
              case "stochastic8":
                if (index > (periodo + sequencia)) {
                  /////Sobrecomprado ha (n) periodos
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 0; i < sequencia; i++) {
                    DataPoint stochasticpoint =
                        mapStochastic[key]["periodCollection"][start + i];

                    if (stochasticpoint.y < sobrevendido) {
                      booleansverify.add(true);
                    } else {
                      booleansverify.add(false);
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
                break;
              case "stochastic9":
                if (index - 1 > (periodo + k - 1)) {
                  DataPoint signalpoint =
                      mapStochastic[key]["signalCollection"][index];
                  DataPoint signalpointanterior =
                      mapStochastic[key]["signalCollection"][index - 1];
                  num valor1 = datapoint.y;
                  num valor2 = datapointanterior.y;
                  num valor3 = signalpoint.y;
                  num valor4 = signalpointanterior.y;

                  return (comparacaovalores(valor4, valor2) &&
                      (comparacaovalores(valor1, valor3)));
                } else {
                  return false;
                }
                break;
              case "stochastic10":
                if (index - 1 > (periodo + k - 1)) {
                  DataPoint signalpoint =
                      mapStochastic[key]["signalCollection"][index];
                  DataPoint signalpointanterior =
                      mapStochastic[key]["signalCollection"][index - 1];

                  num valor1 = datapoint.y;
                  num valor2 = datapointanterior.y;
                  num valor3 = signalpoint.y;
                  num valor4 = signalpointanterior.y;

                  return (comparacaovalores(valor2, valor4) &&
                      (comparacaovalores(valor3, valor1)));
                } else {
                  return false;
                }
                break;
            }
          } else {
            return false;
          }
        }
        break;

      case 10:
        {
          num sequencia = indicadoropcao.parametro['sequencia'];
          num periodo = indicadoropcao.parametro['periodo'];
          num preco = indicadoropcao.parametro['preco'];
          num posicao = indicadoropcao.parametro['posicao'];
          switch (indicadoropcao.configselecionado.id) {
            case "candle1":
              {
                /////Sequencia de alta
                ///
                if (index > sequencia) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 1; i <= sequencia; i++) {
                    Stock stock = stocks[start + i];
                    Stock stockanterior = stocks[(start + i) - 1];
                    if (i != 1) {
                      if (stockanterior.close > stockanterior.open &&
                          stock.close > stockanterior.close &&
                          stock.high > stockanterior.high &&
                          stock.low > stockanterior.low) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    } else {
                      if (stock.close > stock.open) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    //  for (num i = 0; i <= sequencia; i++) {
                    //    print(mapEma[key][start + i].y);
                    //  }
                    //  print("//////////////////");
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              }
              break;
            case "candle2":
              {
                /////Sequencia de alta
                ///
                if (index > sequencia) {
                  List<bool> booleansverify = [];
                  int start = index - sequencia;
                  for (num i = 1; i <= sequencia; i++) {
                    Stock stock = stocks[start + i];
                    Stock stockanterior = stocks[(start + i) - 1];

                    if (i != 1) {
                      if (stockanterior.close < stockanterior.open &&
                          stock.close < stockanterior.close &&
                          stock.high < stockanterior.high &&
                          stock.low <= stockanterior.low) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    } else {
                      if (stock.close < stock.open) {
                        booleansverify.add(true);
                      } else {
                        booleansverify.add(false);
                      }
                    }
                  }

                  num countbooleanbuy =
                      booleansverify.where((item) => item == false).length;
                  if (countbooleanbuy == 0) {
                    //  for (num i = 0; i <= sequencia; i++) {
                    //    print(mapEma[key][start + i].y);
                    //  }
                    //  print("//////////////////");
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              }
              break;
            case 'candle3':
              {
                if (index > sequencia + posicao) {
                  num stockposition = (index - posicao) - sequencia;

                  Stock stockanterior = stocks[stockposition];
                  Stock stock = stocks[(index - posicao)];

                  return comparacaovalores(stock.close, stockanterior.close);
                }
              }
              break;
            case 'candle4':
              {
                if (index > sequencia + posicao) {
                  num stockposition = (index - posicao) - sequencia;

                  Stock stockanterior = stocks[stockposition];
                  Stock stock = stocks[(index - posicao)];

                  return comparacaovalores(stockanterior.close, stock.close);
                }
              }
              break;
            case 'candle5':
              {
                if (index > sequencia + posicao) {
                  num stockposition = (index - posicao) - sequencia;

                  Stock stockanterior = stocks[stockposition];
                  Stock stock = stocks[(index - posicao)];

                  return comparacaovalores(stock.close, stockanterior.high);
                }
              }
              break;
            case 'candle6':
              {
                if (index > sequencia + posicao) {
                  num stockposition = (index - posicao) - sequencia;

                  Stock stockanterior = stocks[stockposition];
                  Stock stock = stocks[(index - posicao)];

                  return comparacaovalores(stockanterior.high, stock.close);
                }
              }
              break;
            case 'candle7':
              {
                if (index > sequencia + posicao) {
                  num stockposition = (index - posicao) - sequencia;

                  Stock stockanterior = stocks[stockposition];
                  Stock stock = stocks[(index - posicao)];

                  return comparacaovalores(stock.close, stockanterior.low);
                }
              }
              break;
            case 'candle8':
              {
                if (index > sequencia + posicao) {
                  num stockposition = (index - posicao) - sequencia;

                  Stock stockanterior = stocks[stockposition];
                  Stock stock = stocks[(index - posicao)];
                  // print("stockanterior:$stockposition/////stockatual:$index");
                  return comparacaovalores(stockanterior.low, stock.close);
                }
              }
              break;
            case 'candle9':
              {
                num valor1 = stocks[index].close;
                num valor2 = preco;
                return comparacaovalores(valor1, valor2);
              }
              break;
            case 'candle10':
              {
                num valor1 = stocks[index].close;
                num valor2 = preco;
                return comparacaovalores(valor2, valor1);
              }
              break;
            case 'candle11':
              {
                if (index > 1) {
                  num valor1 = stocks[index].close;
                  num valor2 = preco;
                  num valor3 = stocks[index - 1].close;

                  return (comparacaovalores(valor2, valor3) &&
                      comparacaovalores(valor1, valor2));
                } else {
                  return false;
                }
              }
              break;
            case 'candle12':
              {
                if (index > 1) {
                  num valor1 = stocks[index].close;
                  num valor2 = preco;
                  num valor3 = stocks[index - 1].close;

                  return (comparacaovalores(valor3, valor2) &&
                      comparacaovalores(valor2, valor1));
                } else {
                  return false;
                }
              }
              break;
          }
        }
        break;
      case 11:
        num dia = indicadoropcao.parametro['dia'];
        num mes = indicadoropcao.parametro['mes'];
        num diainicio = indicadoropcao.parametro['diainicio'];
        num mesinicio = indicadoropcao.parametro['mesinicio'];
        num diafim = indicadoropcao.parametro['diafim'];
        num mesfim = indicadoropcao.parametro['mesfim'];
        switch (indicadoropcao.configselecionado.id) {
          case "data1":
            {
              if (stocks[index].datetime.day >= dia) {
                return true;
              } else {
                return false;
              }
            }
            break;
          case "data2":
            {
              if (stocks[index].datetime.day <= dia) {
                return true;
              } else {
                return false;
              }
            }
            break;
          case "data3":
            {
              if (stocks[index].datetime.day >= dia &&
                  stocks[index].datetime.month >= mes) {
                return true;
              } else {
                return false;
              }
            }
            break;
          case "data4":
            {
              if (stocks[index].datetime.day <= dia &&
                  stocks[index].datetime.month <= mes) {
                return true;
              } else {
                return false;
              }
            }
            break;
          case "data5":
            {
              if (stocks[index].datetime.day >= diainicio &&
                  stocks[index].datetime.month >= mesinicio &&
                  stocks[index].datetime.day <= diafim &&
                  stocks[index].datetime.month <= mesfim) {
                return true;
              } else {
                return false;
              }
            }
            break;
          case "data6":
            {
              if (index > 0) {
                if (index + 1 < stocks.length) {
                  if (stocks[index - 1].datetime.day >
                          stocks[index].datetime.day &&
                      stocks[index].datetime.day <
                          stocks[index + 1].datetime.day) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              } else {
                return false;
              }
            }
            break;
          case "data7":
            //Gambiarra pra nao ter q fazer um loop toda vez
            {
              if (index > 0) {
                if (index + 1 < stocks.length && index > 0) {
                  if (stocks[index - 1].datetime.day <
                          stocks[index].datetime.day &&
                      stocks[index].datetime.day >
                          stocks[index + 1].datetime.day) {
                    return true;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              } else {
                return false;
              }
            }
            break;
        }
        break;
      case 12:
        {
          num id = indicadoropcao.id;
          num c_Len =
              indicadoropcao.parametro['periodo']; // ema depth for bodyAvg
          String keymodified = "$id:$c_Len:body";

          switch (indicadoropcao.configselecionado.id) {
            case "cpattern1":
              {
                if (index - 1 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyanterior = mapEma[keymodified][index - 1];
                  // print("Fechamento:${stocks[index].close} EmaValue:${emapoint.y}");
                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyanterior, c_Len);
                  //C_EngulfingBearish =    C_BlackBody   and   C_LongBody   and C_WhiteBody[1]  and C_SmallBody[1] and close   <= open[1] and   open  >= close[1] and ( close          < open[1]          or          open >        close[1] )
                  var c_EngulfingBearish = candle["c_BlackBody"] &&
                      candle["c_LongBody"] &&
                      candle1["c_WhiteBody"] &&
                      candle1["c_SmallBody"] &&
                      candle["close"] <= candle1["open"] &&
                      candle["open"] >= candle1["close"] &&
                      (candle["close"] < candle1["open"] ||
                          candle["open"] > candle1["close"]);

                  return c_EngulfingBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern2":
              {
                if (index - 1 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyanterior = mapEma[keymodified][index - 1];
                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyanterior, c_Len);
                  //C_EngulfingBullish = C_WhiteBody and C_LongBody and C_BlackBody[1] and C_SmallBody[1] and close >= open[1] and open <= close[1] and ( close > open[1] or open < close[1] )

                  var c_EngulfingBullish = candle["c_WhiteBody"] &&
                      candle["c_LongBody"] &&
                      candle1["c_BlackBody"] &&
                      candle1["c_SmallBody"] &&
                      candle["close"] >= candle1["open"] &&
                      candle["open"] <= candle1["close"] &&
                      (candle["close"] > candle1["open"] ||
                          candle["open"] < candle1["close"]);

                  return c_EngulfingBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern3":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  //c_AbandonedBabyBearish = C_WhiteBody[2] and C_IsDojiBody[1] and high[2] < low[1] and C_BlackBody and low[1] > high

                  var c_AbandonedBabyBearish = candle2["c_WhiteBody"] &&
                      candle1["c_IsDojiBody"] &&
                      candle2["high"] < candle1["low"] &&
                      candle["c_BlackBody"] &&
                      candle1["low"] > candle["high"];

                  return c_AbandonedBabyBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern4":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  //C_AbandonedBabyBullish =  C_BlackBody[2] and C_IsDojiBody[1] and low[2] > high[1] and C_WhiteBody and high[1] < low

                  var c_AbandonedBabyBullish = candle2["c_BlackBody"] &&
                      candle1["c_IsDojiBody"] &&
                      candle2["low"] > candle1["high"] &&
                      candle["c_WhiteBody"] &&
                      candle1["high"] > candle["low"];

                  return c_AbandonedBabyBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern5":
              {
                if (index - 1 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);

                  ///                      C_WhiteBody[1] and C_LongBody[1] and C_IsDojiBody and C_BodyLo > C_BodyHi[1]
                  var c_DojiStarBearish = candle1["c_WhiteBody"] &&
                      candle1["c_LongBody"] &&
                      candle["c_IsDojiBody"] &&
                      candle["c_BodyLo"] > candle1["c_BodyHi"];

                  return c_DojiStarBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern6":
              {
                if (index - 1 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  //                      C_BlackBody[1] and C_LongBody[1] and C_IsDojiBody and C_BodyHi < C_BodyLo[1]
                  var c_DojiStarBullish = candle1["c_BlackBody"] &&
                      candle1["c_LongBody"] &&
                      candle["c_IsDojiBody"] &&
                      candle["c_BodyHi"] < candle1["c_BodyLo"];

                  return c_DojiStarBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern7":
              {
                if (index > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);

                  //C_IsDojiBody and C_UpShadow <= C_Body
                  var c_DragonflyDojiBullish = candle["c_IsDojiBody"] &&
                      candle["c_UpShadow"] <= candle["c_Body"];

                  return c_DragonflyDojiBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern8":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  //if C_LongBody[2] and C_IsDojiBody[1] and C_LongBody and C_WhiteBody[2] and C_BodyLo[1] > C_BodyHi[2] and C_BlackBody and C_BodyLo <= C_BodyMiddle[2] and C_BodyLo > C_BodyLo[2] and C_BodyLo[1] > C_BodyHi

                  var c_EveningDojiStarBearish = candle2["c_LongBody"] &&
                      candle1["c_IsDojiBody"] &&
                      candle["c_LongBody"] &&
                      candle2["c_WhiteBody"] &&
                      candle1["c_BodyLo"] > candle2["c_BodyHi"] &&
                      candle["c_BlackBody"] &&
                      candle["c_BodyLo"] <= candle2["c_BodyMiddle"] &&
                      candle["c_BodyLo"] > candle2["c_BodyLo"] &&
                      candle1["c_BodyLo"] > candle["c_BodyHi"];

                  return c_EveningDojiStarBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern9":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  //C_LongBody[2] and C_SmallBody[1] and C_LongBody
                  //C_WhiteBody[2] and C_BodyLo[1] > C_BodyHi[2] and C_BlackBody and C_BodyLo <= C_BodyMiddle[2] and C_BodyLo > C_BodyLo[2] and C_BodyLo[1] > C_BodyHi

                  if (candle2["c_LongBody"] &&
                      candle1["c_SmallBody"] &&
                      candle["c_LongBody"]) {
                    var c_EveningStarBearish = candle2["c_WhiteBody"] &&
                        candle1["c_BodyLo"] > candle2["c_BodyHi"] &&
                        candle["c_BlackBody"] &&
                        candle["c_BodyLo"] <= candle2["c_BodyMiddle"] &&
                        candle["c_BodyLo"] > candle2["c_BodyLo"] &&
                        candle1["c_BodyLo"] > candle["c_BodyHi"];
                    return c_EveningStarBearish;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              }
              break;
            case "cpattern10":
              {
                if (index - 4 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];
                  num emabodyvalue3 = mapEma[keymodified][index - 4];
                  num emabodyvalue4 = mapEma[keymodified][index - 4];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  Map candle3 = FunctionStock.candleInfo(
                      stocks, index - 3, emabodyvalue3, c_Len);
                  Map candle4 = FunctionStock.candleInfo(
                      stocks, index - 4, emabodyvalue4, c_Len);
                  //C_FallingThreeMethodsBearish =   (C_LongBody[4] and C_BlackBody[4])                and (C_SmallBody[3] and C_WhiteBody[3] and open[3]>low[4] and close[3]<high[4])                                                 and (C_SmallBody[2] and C_WhiteBody[2] and open[2]>low[4] and close[2]<high[4])                                                 and (C_SmallBody[1] and C_WhiteBody[1] and open[1]>low[4] and close[1]<high[4])                                                 and (C_LongBody and C_BlackBody and close<close[4])
                  var c_FallingThreeMethodsBearish =
                      (candle4["c_LongBody"] && candle4["c_BlackBody"]) &&
                          (candle3["c_SmallBody"] &&
                              candle3["c_WhiteBody"] &&
                              candle3["open"] > candle4["low"] &&
                              candle3["close"] < candle4["high"]) &&
                          (candle2["c_SmallBody"] &&
                              candle2["c_WhiteBody"] &&
                              candle2["open"] > candle4["low"] &&
                              candle2["close"] < candle4["high"]) &&
                          (candle1["c_SmallBody"] &&
                              candle1["c_WhiteBody"] &&
                              candle1["open"] > candle4["low"] &&
                              candle1["close"] < candle4["high"]) &&
                          (candle["c_LongBody"] &&
                              candle["c_BlackBody"] &&
                              candle["close"] < candle4["close"]);

                  return c_FallingThreeMethodsBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern11":
              {
                if (index > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  // C_IsDojiBody and C_DnShadow <= C_Body
                  var c_GravestoneDojiBearish = candle["c_IsDojiBody"] &&
                      candle["c_DnShadow"] <= candle["c_Body"];

                  return c_GravestoneDojiBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern12":
              {
                if (index > c_Len) {
                  var hl2 = (stocks[index].high + stocks[index].low) / 2;
                  num emabodyvalue = mapEma[keymodified][index];
                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  // if C_SmallBody and C_Body > 0 and C_BodyLo > hl2 and C_DnShadow >= C_Factor * C_Body and not C_HasUpShadow
                  var c_HammerBullish = candle["c_SmallBody"] &&
                      candle["c_Body"] > 0 &&
                      candle["c_BodyLo"] > hl2 &&
                      candle["c_DnShadow"] >=
                          candle["c_Factor"] * candle["c_Body"] &&
                      !candle["c_HasUpShadow"];

                  return c_HammerBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern13":
              {
                if (index > c_Len) {
                  var hl2 = (stocks[index].high + stocks[index].low) / 2;
                  num emabodyvalue = mapEma[keymodified][index];
                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  // C_SmallBody and C_Body > 0 and C_BodyHi < hl2 and C_UpShadow >= C_Factor * C_Body and not C_HasDnShadow
                  var c_InvertedHammerBullish = candle["c_SmallBody"] &&
                      candle["c_Body"] > 0 &&
                      candle["c_BodyHi"] < hl2 &&
                      candle["c_UpShadow"] >=
                          candle["c_Factor"] * candle["c_Body"] &&
                      !candle["c_HasDnShadow"];

                  return c_InvertedHammerBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern14":
              {
                if (index > c_Len) {
                  var hl2 = (stocks[index].high + stocks[index].low) / 2;
                  num emabodyvalue = mapEma[keymodified][index];
                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  // C_SmallBody and C_Body > 0 and C_BodyLo > hl2 and C_DnShadow >= C_Factor * C_Body and not C_HasUpShadow
                  var c_HangingManBearish = candle["c_SmallBody"] &&
                      candle["c_Body"] > 0 &&
                      candle["c_BodyLo"] > hl2 &&
                      candle["c_DnShadow"] >=
                          candle["c_Factor"] * candle["c_Body"] &&
                      !candle["c_HasUpShadow"];

                  return c_HangingManBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern15":
              {
                if (index > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  var c_MarubozuShadowPercentBearish = 5.0;
                  // C_BlackBody and C_LongBody and C_UpShadow <= C_MarubozuShadowPercentBearish/100*C_Body and C_DnShadow <= C_MarubozuShadowPercentBearish/100*C_Body and C_BlackBody
                  var c_MarubozuBlackBearish = candle["c_BlackBody"] &&
                      candle["c_LongBody"] &&
                      candle["c_UpShadow"] <=
                          c_MarubozuShadowPercentBearish /
                              100 *
                              candle["c_Body"] &&
                      candle["c_DnShadow"] <=
                          c_MarubozuShadowPercentBearish /
                              100 *
                              candle["c_Body"] &&
                      candle["c_BlackBody"];

                  return c_MarubozuBlackBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern16":
              {
                if (index > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  var c_MarubozuShadowPercentWhite = 5.0;
                  // C_MarubozuWhiteBullish = C_WhiteBody and C_LongBody and C_UpShadow <= C_MarubozuShadowPercentWhite/100*C_Body and C_DnShadow <= C_MarubozuShadowPercentWhite/100*C_Body and C_WhiteBody
                  var c_MarubozuWhiteBullish = candle["c_WhiteBody"] &&
                      candle["c_LongBody"] &&
                      candle["c_UpShadow"] <=
                          c_MarubozuShadowPercentWhite /
                              100 *
                              candle["c_Body"] &&
                      candle["c_DnShadow"] <=
                          c_MarubozuShadowPercentWhite /
                              100 *
                              candle["c_Body"] &&
                      candle["c_WhiteBody"];

                  return c_MarubozuWhiteBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern17":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  //if C_LongBody[2] and C_SmallBody[1] and C_LongBody
                  // C_BlackBody[2] and C_BodyHi[1] < C_BodyLo[2] and C_WhiteBody and C_BodyHi >= C_BodyMiddle[2] and C_BodyHi < C_BodyHi[2] and C_BodyHi[1] < C_BodyLo

                  if (candle2["c_LongBody"] &&
                      candle1["c_SmallBody"] &&
                      candle["c_LongBody"]) {
                    var c_MorningStarBullish = candle2["c_BlackBody"] &&
                        candle1["c_BodyHi"] < candle2["c_BodyLo"] &&
                        candle["c_WhiteBody"] &&
                        candle["c_BodyHi"] >= candle2["c_BodyMiddle"] &&
                        candle["c_BodyHi"] < candle2["c_BodyHi"] &&
                        candle1["c_BodyHi"] < candle["c_BodyLo"];
                    return c_MorningStarBullish;
                  } else {
                    return false;
                  }
                } else {
                  return false;
                }
              }
              break;
            case "cpattern18":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  //C_LongBody[2] and C_IsDojiBody[1] and C_LongBody  and C_BlackBody[2] and C_BodyHi[1] < C_BodyLo[2] and C_WhiteBody and C_BodyHi >= C_BodyMiddle[2] and C_BodyHi < C_BodyHi[2] and C_BodyHi[1] < C_BodyLo

                  var c_MorningDojiStarBullish = candle2["c_LongBody"] &&
                      candle1["c_IsDojiBody"] &&
                      candle["c_LongBody"] &&
                      candle2["c_BlackBody"] &&
                      candle1["c_BodyHi"] < candle2["c_BodyLo"] &&
                      candle["c_WhiteBody"] &&
                      candle["c_BodyHi"] >= candle2["c_BodyMiddle"] &&
                      candle["c_BodyHi"] < candle2["c_BodyHi"] &&
                      candle1["c_BodyHi"] < candle["c_BodyLo"];
                  return c_MorningDojiStarBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern19":
              {
                if (index - 4 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];
                  num emabodyvalue3 = mapEma[keymodified][index - 3];
                  num emabodyvalue4 = mapEma[keymodified][index - 4];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  Map candle3 = FunctionStock.candleInfo(
                      stocks, index - 3, emabodyvalue3, c_Len);
                  Map candle4 = FunctionStock.candleInfo(
                      stocks, index - 4, emabodyvalue4, c_Len);

                  var c_RisingThreeMethodsBullish =
                      (candle4["c_LongBody"] && candle4["c_WhiteBody"]) &&
                          (candle3["c_SmallBody"] &&
                              candle3["c_BlackBody"] &&
                              candle3["open"] < candle4["high"] &&
                              candle3["close"] > candle4["low"]) &&
                          (candle2["c_SmallBody"] &&
                              candle2["c_BlackBody"] &&
                              candle2["open"] < candle4["high"] &&
                              candle2["close"] > candle4["low"]) &&
                          (candle1["c_SmallBody"] &&
                              candle1["c_BlackBody"] &&
                              candle1["open"] < candle4["high"] &&
                              candle1["close"] > candle4["low"]) &&
                          (candle["c_LongBody"] &&
                              candle["c_WhiteBody"] &&
                              candle["close"] > candle4["close"]);
                  return c_RisingThreeMethodsBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern20":
              {
                if (index > c_Len) {
                  var hl2 = (stocks[index].high + stocks[index].low) / 2;
                  num emabodyvalue = mapEma[keymodified][index];
                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);

                  var c_ShootingStarBearish = candle["c_SmallBody"] &&
                      candle["c_Body"] > 0 &&
                      candle["c_BodyHi"] < hl2 &&
                      candle["c_UpShadow"] >=
                          candle["c_Factor"] * candle["c_Body"] &&
                      !candle["c_HasDnShadow"];

                  return c_ShootingStarBearish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern21":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);

                  var c_3WSld_ShadowPercent = 5.0;
                  var c_3WSld_HaveNotUpShadow =
                      candle["c_Range"] * c_3WSld_ShadowPercent / 100 >
                          candle["c_UpShadow"];
                  var c_3WSld_HaveNotUpShadow1 =
                      candle1["c_Range"] * c_3WSld_ShadowPercent / 100 >
                          candle1["c_UpShadow"];
                  var c_3WSld_HaveNotUpShadow2 =
                      candle2["c_Range"] * c_3WSld_ShadowPercent / 100 >
                          candle2["c_UpShadow"];

                  if (candle["c_LongBody"] &&
                      candle1["c_LongBody"] &&
                      candle2["c_LongBody"]) {
                    if (candle["c_WhiteBody"] &&
                        candle1["c_WhiteBody"] &&
                        candle2["c_WhiteBody"]) {
                      var c_ThreeWhiteSoldiersBullish =
                          candle["close"] > candle1["close"] &&
                              candle1["close"] > candle2["close"] &&
                              candle["open"] < candle1["close"] &&
                              candle["open"] > candle1["open"] &&
                              candle1["open"] < candle2["close"] &&
                              candle1["open"] > candle2["open"] &&
                              c_3WSld_HaveNotUpShadow &&
                              c_3WSld_HaveNotUpShadow1 &&
                              c_3WSld_HaveNotUpShadow2;
                      return c_ThreeWhiteSoldiersBullish;
                    }
                  }
                  return false;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern22":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);

                  var c_3WSld_ShadowPercent = 5.0;
                  var c_3BCrw_HaveNotDnShadow =
                      candle["c_Range"] * c_3WSld_ShadowPercent / 100 >
                          candle["c_DnShadow"];
                  var c_3BCrw_HaveNotDnShadow1 =
                      candle1["c_Range"] * c_3WSld_ShadowPercent / 100 >
                          candle1["c_DnShadow"];
                  var c_3BCrw_HaveNotDnShadow2 =
                      candle2["c_Range"] * c_3WSld_ShadowPercent / 100 >
                          candle2["c_DnShadow"];

                  if (candle["c_LongBody"] &&
                      candle1["c_LongBody"] &&
                      candle2["c_LongBody"]) {
                    if (candle["c_BlackBody"] &&
                        candle1["c_BlackBody"] &&
                        candle2["c_BlackBody"]) {
                      var c_ThreeBlackCrowsBearish =
                          candle["close"] < candle1["close"] &&
                              candle1["close"] < candle2["close"] &&
                              candle["open"] > candle1["close"] &&
                              candle["open"] < candle1["open"] &&
                              candle1["open"] > candle2["close"] &&
                              candle1["open"] < candle2["open"] &&
                              c_3BCrw_HaveNotDnShadow &&
                              c_3BCrw_HaveNotDnShadow1 &&
                              c_3BCrw_HaveNotDnShadow2;
                      return c_ThreeBlackCrowsBearish;
                    }
                  }
                  return false;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern23":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);
                  //if (not C_IsDojiBody or (C_HasUpShadow and C_HasDnShadow)) and abs(low-low[1]) <= C_BodyAvg*0.05 and C_BlackBody[1] and C_WhiteBody and C_LongBody[1]

                  var c_TweezerBottomBullish = (!candle["c_IsDojiBody"] ||
                          (candle["c_HasUpShadow"] &&
                              candle["c_HasDnShadow"])) &&
                      (candle["low"] - candle1["low"]).abs() <=
                          candle["c_BodyAvg"] * 0.05 &&
                      candle1["c_BlackBody"] &&
                      candle["c_WhiteBody"] &&
                      candle1["c_LongBody"];

                  return c_TweezerBottomBullish;
                } else {
                  return false;
                }
              }
              break;
            case "cpattern24":
              {
                if (index - 2 > c_Len) {
                  num emabodyvalue = mapEma[keymodified][index];
                  num emabodyvalue1 = mapEma[keymodified][index - 1];
                  num emabodyvalue2 = mapEma[keymodified][index - 2];

                  Map candle = FunctionStock.candleInfo(
                      stocks, index, emabodyvalue, c_Len);
                  Map candle1 = FunctionStock.candleInfo(
                      stocks, index - 1, emabodyvalue1, c_Len);
                  Map candle2 = FunctionStock.candleInfo(
                      stocks, index - 2, emabodyvalue2, c_Len);

                  var c_TweezerTopBearish = (!candle["c_IsDojiBody"] ||
                          (candle["c_HasUpShadow"] &&
                              candle["c_HasDnShadow"])) &&
                      (candle["high"] - candle1["high"]).abs() <=
                          candle["c_BodyAvg"] * 0.05 &&
                      candle1["c_WhiteBody"] &&
                      candle["c_BlackBody"] &&
                      candle1["c_LongBody"];

                  return c_TweezerTopBearish;
                } else {
                  return false;
                }
              }
              break;
          }
        }
        break;
      case 13:
        {
          /////////////////MULTICONDICIONAL BASEADA NA MESMA LOGICA QUE NA ESTRATEGIA
          ///////////////////POREM COM UMA LOGICA UM POUCO DIFERENTE

          ///Na logica da estrategia nao pode haver um false na lista de condiçoes booleanas, ja no caso da multicondicional
          ///é usado o operador logico or |, ou seja, um deles sendo uma condiçao verdadeira ja é o suficiente

          List condicaoboolean = [];
          indicadoropcao.indicadoresopcoes.forEach((indicadoropcaosingle) {
            condicaoboolean.add(LogicaBackTesting.verificaocondicao(
                indicadoropcaosingle,
                index,
                stocks,
                map,
                tradeEntrada,
                indexEntrada));
          });

          int countbooleansell =
              condicaoboolean.where((item) => item == true).length;
          if (countbooleansell > 0) {
            return true;
          } else {
            return false;
          }
        }
        break;
      case 14:
        {
          switch (indicadoropcao.configselecionado.id) {
            case "saida1":
              {
                /////Saida após n periodos
                num periodo = indicadoropcao.parametro["periodo"];
                num valor1 = index;
                num valor2 = indexEntrada + periodo;

                return comparacaovalores(valor1, valor2);
              }
              break;
            case "saida2":
              {
                /////Saida após primeiro candle no lucro
                num valor1 = tradeEntrada.close;
                num valor2 = stocks[index].close;

                return comparacaovalores(valor2, valor1);
              }
              break;
            case "saida3":
              {
                // ((ultimodia - primeirodia) / primeirodia) * 100;
                //% porcentagem de gain
                num porcentagem = ((stocks[index].close - tradeEntrada.close) /
                        tradeEntrada.close) *
                    100;

                num valor1 = porcentagem;
                num valor2 = indicadoropcao.parametro["gain"];

                return comparacaovalores(valor1, valor2);
              }
              break;
            case "saida4":
              {
                // ((ultimodia - primeirodia) / primeirodia) * 100;
                //% porcentagem de loss
                num porcentagem = ((stocks[index].close - tradeEntrada.close) /
                        tradeEntrada.close) *
                    100;

                num valor1 = porcentagem;
                num valor2 = indicadoropcao.parametro["loss"] * -1;

                return comparacaovalores(valor2, valor1);
              }
              break;
            case "saida5":
              {
                ///stop gain atr
                if (index > periodo) {
                  String keymodified = "$id:$periodo:atr";
                  num constanteAtr = indicadoropcao.parametro["fatorAtr"];
                  num stockanterior = stocks[index - 1].close;
                  num valueAtr = mapAtr[keymodified][index - 1].y;
                  num valor1 = stockanterior + (valueAtr * constanteAtr);
                  num valor2 = stocks[index].close;

                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida6":
              {
                ////stop loss atr
                if (index > periodo) {
                  String keymodified = "$id:$periodo:atr";
                  num constanteAtr = indicadoropcao.parametro["fatorAtr"];
                  num stockanterior = stocks[index - 1].close;
                  num valueAtr = mapAtr[keymodified][index - 1].y;
                  num valor1 = stockanterior - (valueAtr * constanteAtr);
                  num valor2 = stocks[index].close;

                  return comparacaovalores(valor1, valor2);
                } else {
                  return false;
                }
              }
              break;
            case "saida7":
              {
                ////stop média fechamentos
                if (index > periodo) {
                  String keymodified = "$id:$periodo:close";
                  num valor1 = stocks[index].close;
                  num valor2 = mapSma[keymodified][index].y;
                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida8":
              {
                ////stop gain na média da máximas
                if (index > periodo) {
                  String keymodified = "$id:$periodo:high";
                  num valor1 = stocks[index].close;
                  num valor2 = mapSma[keymodified][index].y;
                  return comparacaovalores(valor1, valor2);
                } else {
                  return false;
                }
              }
              break;
            case "saida9":
              {
                ////stop loss na média da minimas
                if (index > periodo) {
                  String keymodified = "$id:$periodo:low";
                  num valor1 = stocks[index].close;
                  num valor2 = mapSma[keymodified][index].y;
                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida10":
              {
                ////Stop loss no fechamento (n) periodos anteriores
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[index - periodo].close;
                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida11":
              {
                ////Stop loss na minima (n) periodos anteriores
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[index - periodo].low;
                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida12":
              {
                ////Stop loss na maxima (n) periodos anteriores
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[index - periodo].high;
                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida13":
              {
                ////Stop gain na minima (n) periodos anteriores
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[index - periodo].high;
                  return comparacaovalores(valor1, valor2);
                } else {
                  return false;
                }
              }
              break;
            case "saida14":
              {
                ////Stop gain na maxima (n) periodos anteriores
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[index - periodo].high;
                  return comparacaovalores(valor1, valor2);
                } else {
                  return false;
                }
              }
              break;
            case "saida15":
              {
                ////Stop fixo no fechamento (n) periodos anteriores após entrada
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[indexEntrada - periodo].close;
                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida16":
              {
                ////Stop loss fixo na minima (n) periodos anteriores após entrada
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[indexEntrada - periodo].low;
                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida17":
              {
                ////Stop loss fixo na maxima (n) periodos anteriores após entrada
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[indexEntrada - periodo].high;
                  return comparacaovalores(valor2, valor1);
                } else {
                  return false;
                }
              }
              break;
            case "saida18":
              {
                ////Stop gain fixo na minima (n) periodos anteriores após entrada
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[indexEntrada - periodo].high;
                  return comparacaovalores(valor1, valor2);
                } else {
                  return false;
                }
              }
              break;
            case "saida19":
              {
                ////Stop gain fixo na maxima (n) periodos anteriores após entrada
                if (index > periodo) {
                  num valor1 = stocks[index].close;
                  num valor2 = stocks[indexEntrada - periodo].high;
                  return comparacaovalores(valor1, valor2);
                } else {
                  return false;
                }
              }
              break;
          }
        }
        break;
    }

    return false;
  }
}
