import 'package:scouting/models/todo.dart';

import 'dart:math' as math;

class GenerateDataPoint {
  /// To calculate the rendering points of the ATR indicator
  static atr(num period, List<Stock> stocks) {
    num average = 0;
    num highLow = 0;
    num highClose = 0;
    num lowClose = 0;
    num trueRange = 0;
    num tempRange = 0;
    final List<DataPoint> points = [];
    DataPoint point;
    final List<DataPoint> temp = <DataPoint>[];
    num sum = 0;

    for (int i = 0; i < stocks.length; i++) {
      highLow = stocks[i].high - stocks[i].low;
      if (i > 0) {
        highClose = (stocks[i].high - (stocks[i - 1].close ?? 0)).abs();
        lowClose = (stocks[i].low - (stocks[i - 1].close ?? 0)).abs();
      }
      tempRange = math.max(highLow, highClose);
      trueRange = math.max(tempRange, lowClose);
      sum = sum + trueRange;
      if (i >= period && period > 0) {
        average = (temp[temp.length - 1].y * (period - 1) + trueRange) / period;
        point = DataPoint(
            x: stocks[i].datetime, y: average, stock: stocks[i], index: i);
        points.add(point);
      } else {
        average = sum / period;
        if (i == period - 1) {
          point = DataPoint(
              x: stocks[i].datetime, y: average, stock: stocks[i], index: i);
          points.add(point);
        } else {
          point = DataPoint(
              x: stocks[i].datetime, y: 0, stock: stocks[i], index: i);
          points.add(point);
        }
      }
      temp.add(DataPoint(
          x: stocks[i].datetime, y: average, stock: stocks[i], index: i));

      //  print(average);
    }

    return points;
  }

  static emapattern(num period, List<Stock> stocks, int index) {
    num sum = 0;
    num average = 0;
    final num k = 2 / (period + 1);
    if (index - period > 0) {
      int start = index - period;
      for (int i = 0; i < period; i++) {
        sum += stocks[start + i].close ?? 0;
      }
      average = sum / period;
      final num emavalue = (stocks[index].close - average) * k + average;

      return emavalue;
    }
    print("erro emapattern");
    return false;
  }

//////////////////////////////////Inicio calculo Média Exponencial/////////////////////////////////////////
  static List<DataPoint> ema(int period, List<Stock> stocks) {
    final List<DataPoint> points = [];
    DataPoint point;
    if (stocks.length >= period && period > 0) {
      num sum = 0;
      num average = 0;
      final num k = 2 / (period + 1);
      for (int i = 0; i < period; i++) {
        if (i + 1 != period) {
          sum += stocks[i].close ?? 0;
          point = DataPoint(
              x: stocks[i].datetime, y: 0, stock: stocks[i], index: i);
          points.add(point);
        } else {
          average = sum / period;
          point = DataPoint(
              x: stocks[i].datetime, y: average, stock: stocks[i], index: i);
          points.add(point);
        }
      }

      num indexwhile = period;
      while (indexwhile < stocks.length) {
        final num prevAverage = points[indexwhile - 1].y;
        final num yValue =
            (stocks[indexwhile].close - prevAverage) * k + prevAverage;
        point = DataPoint(
            x: stocks[indexwhile].datetime,
            y: yValue,
            stock: stocks[indexwhile],
            index: indexwhile);
        points.add(point);
        indexwhile++;
      }
    }
    // points.forEach((element) {print(element.y);});
    return points;
  }

  static List<num> emabody(int period, List<Stock> stocks) {
    final List<num> points = [];
    if (stocks.length >= period && period > 0) {
      num sum = 0;
      num average = 0;
      final num k = 2 / (period + 1);
      for (int i = 0; i < period; i++) {
        var c_BodyHi = math.max(stocks[i].close, stocks[i].open);
        var c_BodyLo = math.min(stocks[i].close, stocks[i].open);
        var c_Body = c_BodyHi - c_BodyLo;

        if (i + 1 != period) {
          sum += c_Body ?? 0;
          points.add(0);
        } else {
          average = sum / period;
          points.add(average);
        }
      }

      num indexwhile = period;
      while (indexwhile < stocks.length) {
        var c_BodyHi =
            math.max(stocks[indexwhile].close, stocks[indexwhile].open);
        var c_BodyLo =
            math.min(stocks[indexwhile].close, stocks[indexwhile].open);
        var c_Body = c_BodyHi - c_BodyLo;

        final num prevAverage = points[indexwhile - 1];
        final num yValue = (c_Body - prevAverage) * k + prevAverage;
        points.add(yValue);
        indexwhile++;
      }
    }
    // points.forEach((element) {print(element.y);});
    return points;
  }

  //////////////////////////////////Inicio calculo Acumulaçao/Distribuiçao////////////////////////////////
  static accumulationdistribution(List<Stock> stocks) {
    final List<DataPoint> points = [];
    num sum = 0.0;
    num i = 0;
    num value = 0;
    num high = 0;
    num low = 0;
    num close = 0;
    for (i = 0; i < stocks.length; i++) {
      DataPoint point;
      high = stocks[i].high ?? 0;
      low = stocks[i].low ?? 0;
      close = stocks[i].close ?? 0;
      value = ((close - low) - (high - close)) / (high - low);
      sum = (sum + value * stocks[i].volume).isNaN
          ? sum
          : sum + value * stocks[i].volume;
      point = DataPoint(
          x: stocks[i].datetime, y: sum.toInt(), stock: stocks[i], index: i);
      points.add(point);
      // print("x:${stocks[i].datetime}, y:$sum,stock:${stocks[i]},index: $i");
    }
    print("accumulationdistribution tamanho:${points.length}");
    return points;
  }

//////////////////////////////////Fim calculo Acumulaçao/Distribuiçao////////////////////////////////

//////////////////////////////////Inicio calculo Bollinger/////////////////////////////////////////////
  static List<BollingerPointData> bollinger(
      int desvio, int periodo, List<Stock> stocks) {
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
      final List<BollingerPointData> bollingerPoints = [];

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
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i] - deviations[i - length];
          } else {
            smaPoints[i] = sma;
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i];
          }
          final num range = math.sqrt(deviationSum / (periodo));
          final num lowerBand = smaPoints[i] - (multiplier * range);
          final num upperBand = smaPoints[i] + (multiplier * range);
          if (i + 1 == length) {
            for (int j = 0; j < length - 1; j++) {
              bollingerPoints.add(BollingerPointData(
                index: j,
                midBand: smaPoints[j],
                lowBand: lowerBand,
                upBand: upperBand,
                stock: stocks[j],
              ));
            }
          }

          bollingerPoints.add(BollingerPointData(
            index: i,
            midBand: smaPoints[i],
            lowBand: lowerBand,
            upBand: upperBand,
            stock: stocks[i],
          ));
        } else {
          if (i < periodo - 1) {
            smaPoints[i] = sma;
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i];
          }
        }
      }

      print("bollingerPoints tamanho:${bollingerPoints.length}");
      return bollingerPoints;
    }

    return null;
  }

//////////////////////////////////Fim calculo Bollinger/////////////////////////////////////////////

//////////////////////////////////Inicio calculo MACD/////////////////////////////////////////////
  /// To initialise data source of technical indicators
  // ignore:unused_element
  static Map macd(
    num fastPeriod,
    num slowPeriod,
    num period,
    List<Stock> stocks,
  ) {
    // final num fastPeriod = indicator.longPeriod;
    // final num slowPeriod = indicator.shortPeriod;
    final num trigger = period;
    final num length = fastPeriod + trigger;

    List<DataPoint> macdpoints, signalpoints, histogrampoints;

    if (stocks.isNotEmpty &&
        length < stocks.length &&
        slowPeriod <= fastPeriod &&
        slowPeriod > 0 &&
        period > 0 &&
        (length - 2) >= 0) {
      final List<num> shortEMA =
          _calculateEMAValues(slowPeriod, stocks, 'close');
      // print("/////////////////////////SHORT EMA");
      final List<num> longEMA =
          _calculateEMAValues(fastPeriod, stocks, 'close');
      //  print("/////////////////////////longEMA EMA");
      final List<num> macdValues =
          _getMACDVales(fastPeriod, slowPeriod, shortEMA, longEMA);
      macdpoints = _getMACDPoints(macdValues, stocks, fastPeriod);

      final List<num> signalEMA = _calculateEMAValues(trigger, macdpoints, 'y');

      // print("/////////////////////////signalEMA EMA");

      signalpoints = _getSignalPoints(fastPeriod, period, signalEMA, stocks);

      histogrampoints = _getHistogramPoints(
          fastPeriod, period, macdValues, signalEMA, stocks);

      for (int i = 0; i < fastPeriod - 1; i++) {
        macdpoints.insert(
            0,
            DataPoint(
                x: stocks[i].datetime, y: null, stock: stocks[i], index: i));
      }
      for (int i = 0; i < (fastPeriod + period - 2); i++) {
        signalpoints.insert(
            0,
            DataPoint(
                x: stocks[i].datetime, y: null, stock: stocks[i], index: i));
      }
      for (int i = 0; i < (fastPeriod + period - 2); i++) {
        histogrampoints.insert(
            0,
            DataPoint(
                x: stocks[i].datetime, y: null, stock: stocks[i], index: i));
      }

      print("macdCollection:${macdpoints.length}");
      print("signalpoints:${signalpoints.length}");
      print("histogrampoints:${histogrampoints.length}");

      return {
        "macdCollection": macdpoints,
        "signalCollection": signalpoints,
        "histogramCollection": histogrampoints,
      };
    }

    return null;
  }

  static num _getFieldValue(List<dynamic> point, int itr, String valueField) {
    num val;
    if (valueField == 'low') {
      val = point[itr]?.low;
    } else if (valueField == 'high') {
      val = point[itr]?.high;
    } else if (valueField == 'open') {
      val = point[itr]?.open;
    } else if (valueField == 'y') {
      val = point[itr]?.y;
    } else {
      val = point[itr].close;
    }

    ///ignore: unnecessary_statements
    val = val ?? 0;
    return val;
  }

  static List<num> _calculateEMAValues(
    num period,
    List<dynamic> data,
    String valueField,
  ) {
    num sum = 0;
    num initialEMA = 0;
    final List<num> emaValues = <num>[];
    final num emaPercent = 2 / (period + 1);
    for (int i = 0; i < period; i++) {
      sum += _getFieldValue(data, i, valueField);
    }
    initialEMA = sum / period;
    emaValues.add(initialEMA);
    num emaAvg = initialEMA;
    for (int j = period; j < data.length; j++) {
      emaAvg =
          (_getFieldValue(data, j, valueField) - emaAvg) * emaPercent + emaAvg;
      emaValues.add(emaAvg);
      // print(emaAvg);
    }

    return emaValues;
  }

  ///Defines the MACD Points
  static List<DataPoint> _getMACDPoints(
      List<num> macdPoints, List<Stock> stocks, num fastPeriod) {
    // final List<DataPoint> macdCollection = [];

    final List<DataPoint> macdCollection = <DataPoint>[];
    num dataMACDIndexwhile = fastPeriod - 1;
    num macdIndexwhile = 0;

    while (dataMACDIndexwhile < stocks.length) {
      macdCollection.add(DataPoint(
          x: stocks[dataMACDIndexwhile].datetime,
          y: macdPoints[macdIndexwhile],
          stock: stocks[dataMACDIndexwhile],
          index: macdIndexwhile));

      dataMACDIndexwhile++;
      macdIndexwhile++;
    }

    return macdCollection;
  }

  ///Calculates the signal points
  static List<DataPoint> _getSignalPoints(
    num fastPeriod,
    num period,
    List<num> signalEma,
    List<Stock> stocks,
  ) {
    final List<DataPoint> signalCollection = <DataPoint>[];

    num dataSignalIndex = fastPeriod + period - 2;
    num signalIndex = 0;

    while (dataSignalIndex < stocks.length) {
      signalCollection.add(DataPoint(
          x: stocks[dataSignalIndex].datetime,
          y: signalEma[signalIndex],
          stock: stocks[dataSignalIndex],
          index: signalIndex));

      dataSignalIndex++;
      signalIndex++;
    }

    return signalCollection;
  }

  ///Calculates the MACD values
  static List<num> _getMACDVales(
      fastPeriod, slowPeriod, List<num> shortEma, List<num> longEma) {
    final List<num> macdPoints = <num>[];
    final num diff = fastPeriod - slowPeriod;
    for (int i = 0; i < longEma.length; i++) {
      macdPoints.add(shortEma[i + diff] - longEma[i]);
    }
    return macdPoints;
  }

  ///Calculates the Histogram Points
  static List<DataPoint> _getHistogramPoints(
    num fastPeriod,
    num period,
    List<num> macdPoints,
    List<num> signalEma,
    List<Stock> stocks,
  ) {
    // final List<DataPoint> histogramCollection = <DataPoint>[];

    num dataHistogramIndexwhile = fastPeriod + period - 2;
    num histogramIndexwhile = 0;
    final List<DataPoint> histogramCollection = <DataPoint>[];
    while (dataHistogramIndexwhile < stocks.length) {
      histogramCollection.add(DataPoint(
          x: stocks[dataHistogramIndexwhile].datetime,
          y: macdPoints[histogramIndexwhile + (period - 1)] -
              signalEma[histogramIndexwhile],
          stock: stocks[dataHistogramIndexwhile],
          index: histogramIndexwhile));

      dataHistogramIndexwhile++;
      histogramIndexwhile++;
    }

    return histogramCollection;
  }

//////////////////////////////////Fim calculo MACD/////////////////////////////////////////////
  ///
  ///

//////////////////////////////////Inicio calculo IFR/////////////////////////////////////////////
  static List<dynamic> ifr(int period, List<Stock> stocks) {
    final List<dynamic> signalValues = <dynamic>[];

    if (stocks.isNotEmpty && stocks.length >= period && period > 0) {
      num prevClose = stocks[0].close ?? 0;
      num gain = 0;
      num loss = 0;

      signalValues.add(
          DataPoint(x: stocks[0].datetime, y: 0, stock: stocks[0], index: 0));

      for (int i = 1; i <= period; i++) {
        final num close = stocks[i].close ?? 0.0;
        if (close > prevClose) {
          gain += close - prevClose;
        } else {
          loss += prevClose - close;
        }
        prevClose = close;

        //i tem que ser maior que 1 para poder calcular baseado na posiçao anterior, logo i != periodo pra verificar se é o ultimo elemento do loop
        if (i != period) {
          signalValues.add(DataPoint(
              x: stocks[i].datetime, y: 0, stock: stocks[i], index: i));
        }
      }

      gain = gain / period;
      loss = loss / period;
      signalValues.add(DataPoint(
          x: stocks[period].datetime,
          y: 100 - (100 / (1 + (gain / loss))),
          stock: stocks[period],
          index: period));

      for (int j = period + 1; j < stocks.length; j++) {
        final num close = stocks[j].close;
        if (close > prevClose) {
          gain = (gain * (period - 1) + (close - prevClose)) / period;
          loss = (loss * (period - 1)) / period;
        } else if (close < prevClose) {
          loss = (loss * (period - 1) + (prevClose - close)) / period;
          gain = (gain * (period - 1)) / period;
        }
        prevClose = close;
        signalValues.add(DataPoint(
            x: stocks[j].datetime,
            y: 100 - (100 / (1 + (gain / loss))),
            stock: stocks[j],
            index: j));
      }
    }
    //  signalValues.forEach((e) => print("${e.x} => ${e.index}"));
    print("Ifr tamanho:${signalValues.length}");
    return signalValues;
  }

//////////////////////////////////Fim calculo IFR/////////////////////////////////////////////

//////////////////////////////////Inicio calculo Estocastico/////////////////////////////////////////////

  static List<DataPoint> stochasticCalculation(
    num period,
    num kPeriod,
    List<DataPoint> data,
  ) {
    final List<DataPoint> pointCollection = <DataPoint>[];

    if (data.length >= period + kPeriod && kPeriod > 0) {
      final num count = period + (kPeriod - 1);
      final List<num> temp = <num>[];
      final List<num> values = <num>[];
      for (int i = 0; i < data.length; i++) {
        final num value = data[i].y;
        temp.add(value);
      }
      num length = temp.length;
      while (length >= count) {
        num sum = 0;
        for (int i = period - 1; i < (period + kPeriod - 1); i++) {
          sum = sum + temp[i];
        }
        sum = sum / kPeriod;
        final String _sum = sum.toStringAsFixed(2);
        values.add(double.parse(_sum));
        temp.removeRange(0, 1);
        length = temp.length;
      }
      final num len = count - 1;
      for (int i = 0; i < data.length; i++) {
        if (!(i < len)) {
          pointCollection.add(DataPoint(
              x: data[i].x,
              y: values[i - len],
              stock: data[i].stock,
              index: i));
          data[i].y = values[i - len];
        } else {
          pointCollection.add(
              DataPoint(x: data[i].x, y: null, stock: data[i].stock, index: i));
        }
      }
    }
    print("Estocastico tamanho:${pointCollection.length}");

    return pointCollection;
  }

  /// To return list of stochastic indicator points
  static List<DataPoint> calculatePeriod(
    num period,
    num kPeriod,
    List<Stock> data,
  ) {
    // ignore: deprecated_member_use
    final List<num> lowValue = List<num>(data.length);
    // ignore: deprecated_member_use
    final List<num> highValue = List<num>(data.length);
    // ignore: deprecated_member_use
    final List<num> closeValue = List<num>(data.length);
    final List<DataPoint> modifiedSource = <DataPoint>[];

    for (int j = 0; j < data.length; j++) {
      lowValue[j] = data[j].low ?? 0;
      highValue[j] = data[j].high ?? 0;
      closeValue[j] = data[j].close ?? 0;
    }
    if (data.length > period) {
      final List<num> mins = <num>[];
      final List<num> maxs = <num>[];
      for (int i = 0; i < period - 1; ++i) {
        maxs.add(0);
        mins.add(0);
        modifiedSource.add(DataPoint(
            x: data[i].datetime, y: data[i].close, stock: data[i], index: i));
      }
      num min, max;
      for (int i = period - 1; i < data.length; ++i) {
        for (int j = 0; j < period; ++j) {
          min ??= lowValue[i - j];
          max ??= highValue[i - j];
          min = math.min(min, lowValue[i - j]);
          max = math.max(max, highValue[i - j]);
        }
        maxs.add(max);
        mins.add(min);
        min = null;
        max = null;
      }

      for (int i = period - 1; i < data.length; ++i) {
        num top = 0;
        num bottom = 0;
        top += closeValue[i] - mins[i];
        bottom += maxs[i] - mins[i];
        modifiedSource.add(DataPoint(
            x: data[i].datetime,
            y: (top / bottom) * 100,
            stock: data[i],
            index: i));
      }
    }
    return modifiedSource;
  }

  //////////////////////////////////Fim calculo Estocastico/////////////////////////////////////////////

  //////////////////////////////////Inicio calculo Media movel/////////////////////////////////////////////
  static List<DataPoint> sma(
      int period, List<Stock> stocks, String tipocalculo) {
    if (stocks.isNotEmpty && stocks.length >= period && period > 0) {
      num sum = 0;
      final num limit = stocks.length;
      final num length = period.round();
      // ignore: deprecated_member_use
      final List<DataPoint> smaPoints = List<DataPoint>(limit);

      for (int i = 0; i < length; i++) {
        if (tipocalculo == "close") {
          sum += stocks[i].close ?? 0;
        } else if (tipocalculo == "high") {
          sum += stocks[i].high ?? 0;
        } else if (tipocalculo == "low") {
          sum += stocks[i].low ?? 0;
        }
      }
      num sma = sum / period;
      for (int i = 0; i < limit; i++) {
        num y;

        if (tipocalculo == "close") {
          y = stocks[i].close ?? 0;
        } else if (tipocalculo == "high") {
          y = stocks[i].high ?? 0;
        } else if (tipocalculo == "low") {
          y = stocks[i].low ?? 0;
        }

        if (i >= length - 1 && i < limit) {
          if (i - period >= 0) {
            num diff;

            if (tipocalculo == "close") {
              diff = y - stocks[i - length].close;
            } else if (tipocalculo == "high") {
              diff = y - stocks[i - length].high;
            } else if (tipocalculo == "low") {
              diff = y - stocks[i - length].low;
            }

            sum = sum + diff;
            sma = sum / (period);

            smaPoints[i] = DataPoint(
                x: stocks[i].datetime, y: sma, stock: stocks[i], index: i);
          } else {
            smaPoints[i] = DataPoint(
                x: stocks[i].datetime, y: sma, stock: stocks[i], index: i);
          }
        } else {
          if (i < period - 1) {
            smaPoints[i] = DataPoint(
                x: stocks[i].datetime, y: sma, stock: stocks[i], index: i);
          }
        }
      }

      print("Media tamanho:${smaPoints.length}");
      return smaPoints;
    }
    return null;
  }

  static List<DataPoint> smaIndicator(int period, List<DataPoint> datapoint) {
    if (datapoint.isNotEmpty && datapoint.length >= period && period > 0) {
      ///////////NO ACUMULAÇAO E DISTRIBUIÇAO OCORRE UMA LERDEZA DEVIDO AO TAMANHO DOS NUMEROS

      num sum = 0;
      final num limit = datapoint.length;
      final num length = period.round();
      // ignore: deprecated_member_use
      final List<DataPoint> smaPoints = List<DataPoint>(limit);

      for (int i = 0; i < length; i++) {
        sum += datapoint[i].y ?? 0;
      }
      num sma = sum / period;
      for (int i = 0; i < limit; i++) {
        print(i);
        final num y = datapoint[i].y ?? 0;
        if (i >= length - 1 && i < limit) {
          if (i - period >= 0) {
            final num diff = y - datapoint[i - length].y;
            sum = sum + diff;
            sma = sum / (period);

            smaPoints[i] =
                DataPoint(x: datapoint[i].x, y: sma, stock: null, index: i);
          } else {
            smaPoints[i] =
                DataPoint(x: datapoint[i].x, y: 0, stock: null, index: i);
          }
        } else {
          if (i < period - 1) {
            smaPoints[i] =
                DataPoint(x: datapoint[i].x, y: 0, stock: null, index: i);
          }
        }
      }

      return smaPoints;
    }
    return null;
  }

  //////////////////////////////////Fim calculo Media movel/////////////////////////////////////////////

}

class GeraMapDataPoint {
  static Map<String, Map<String, dynamic>> generateMapSignals(
      List<IndicadoresOpcao> signals, List<Stock> stocks, String tipo) {
    Map<String, Map<String, dynamic>> mapsignals = {
      "mapSma": {},
      "mapStochastic": {},
      "mapIfr": {},
      "mapMacd": {},
      "mapBollinger": {},
      "mapAcumDist": {},
      "mapEma": {},
      "mapAtr": {}
    };

    signals.forEach((IndicadoresOpcao indicadoropcao) {
      int id = indicadoropcao.id;
      int periodo = indicadoropcao.parametro["periodo"] ?? 0;
      String key = "$id:$periodo";

      switch (indicadoropcao.id) {
        case 1:
          {
            if (!(mapsignals["mapAcumDist"].containsKey(key))) {
              mapsignals["mapAcumDist"][key] =
                  GenerateDataPoint.accumulationdistribution(stocks);
              print("criando datapoints mapAcumDist no periodo $key $tipo");
              if (indicadoropcao.configselecionado.id == "acudis5" ||
                  indicadoropcao.configselecionado.id == "acudis6") {
                String keymodified = "$id:$periodo:media";
                int periodocalculo = indicadoropcao.parametro["periodo"];

                if (!(mapsignals["mapAcumDist"].containsKey(keymodified))) {
                  mapsignals["mapAcumDist"][keymodified] =
                      GenerateDataPoint.smaIndicator(
                          periodocalculo, mapsignals["mapAcumDist"][key]);

                  print(
                      "criando media mapAcumDist no periodo $keymodified $tipo");
                }
              }
            }
          }
          break;

        case 2:
          {}
          break;

        case 3:
          {
            if (!(mapsignals["mapBollinger"].containsKey(key))) {
              int desvio = indicadoropcao.parametro["desvio"];
              int periodo = indicadoropcao.parametro["periodo"];

              mapsignals["mapBollinger"][key] =
                  GenerateDataPoint.bollinger(desvio, periodo, stocks);
              print(
                  "criando datapoints mapBollinger com periodo $key no $tipo");
            }
          }
          break;
        case 4:
          {
            num periodo = indicadoropcao.parametro["periodo"];
            num id = indicadoropcao.id;
            if (!(mapsignals["mapEma"].containsKey(key))) {
              mapsignals["mapEma"][key] =
                  GenerateDataPoint.ema(periodo, stocks);
              print("criando datapoints mapEma com periodo $key no $tipo");

              if (indicadoropcao.configselecionado.id == "ema7" ||
                  indicadoropcao.configselecionado.id == "ema8") {
                num periodolongo = indicadoropcao.parametro["periodolongo"];
                String keymodified = "$id:$periodo:$periodolongo";
                if (!(mapsignals["mapEma"].containsKey(keymodified))) {
                  mapsignals["mapEma"][keymodified] =
                      GenerateDataPoint.ema(periodolongo, stocks);
                }
              }
            }
          }
          break;
        case 5:
          {
            if (!(mapsignals["mapMacd"].containsKey(key))) {
              num fastPeriod = indicadoropcao.parametro["periodolento"];
              num slowPeriod = indicadoropcao.parametro["periodorapido"];
              num period = indicadoropcao.parametro["periodo"];
              mapsignals["mapMacd"][key] = GenerateDataPoint.macd(
                  fastPeriod, slowPeriod, period, stocks);
              print("criando datapoints mapMacd com periodo $key no $tipo");
            }
          }
          break;

        case 6:
          {}
          break;

        case 7:
          {
            if (!(mapsignals["mapIfr"].containsKey(key))) {
              mapsignals["mapIfr"][key] = GenerateDataPoint.ifr(
                  indicadoropcao.parametro["periodo"], stocks);
              print("criando datapoints mapIfr com periodo $key no $tipo");
            }
          }
          break;

        case 8:
          {
            num periodo = indicadoropcao.parametro["periodo"];
            num id = indicadoropcao.id;
            if (!(mapsignals["mapSma"].containsKey(key))) {
              mapsignals["mapSma"][key] =
                  GenerateDataPoint.sma(periodo, stocks, "close");
              print("criando datapoints mapSma com periodo $key no $tipo");

              if (indicadoropcao.configselecionado.id == "media7" ||
                  indicadoropcao.configselecionado.id == "media8") {
                num periodolongo = indicadoropcao.parametro["periodolongo"];
                String keymodified = "$id:$periodo:$periodolongo";
                if (!(mapsignals["mapSma"].containsKey(keymodified))) {
                  mapsignals["mapSma"][keymodified] =
                      GenerateDataPoint.sma(periodolongo, stocks, "close");
                  print(
                      "criando datapoints mapSma medialonga com periodo $keymodified no $tipo");
                }
              }
            }
          }
          break;
        case 9:
          {
            int periodo = indicadoropcao.parametro["periodo"];
            if (!(mapsignals["mapStochastic"].containsKey(key))) {
              mapsignals["mapStochastic"][key] = {};
              List<DataPoint> source = <DataPoint>[];
              List<DataPoint> collection;
              mapsignals["mapStochastic"][key]["source"] = <DataPoint>[];
              mapsignals["mapStochastic"][key]
                  ["periodCollection"] = <DataPoint>[];
              mapsignals["mapStochastic"][key]
                  ["signalCollection"] = <DataPoint>[];

              source = GenerateDataPoint.calculatePeriod(
                  periodo, indicadoropcao.parametro["k"], stocks);

              collection = GenerateDataPoint.stochasticCalculation(
                  periodo, indicadoropcao.parametro["k"], source);

              mapsignals["mapStochastic"][key]["periodCollection"] = collection;

              collection = GenerateDataPoint.stochasticCalculation(
                periodo + indicadoropcao.parametro["k"] - 1,
                indicadoropcao.parametro["d"],
                source,
              );

              mapsignals["mapStochastic"][key]["signalCollection"] = collection;
              mapsignals["mapStochastic"][key]["source"] = source;

              print(
                  "criando datapoints mapStochastic com periodo $key no $tipo");
            }
          }
          break;
        case 12:
          {
            int c_Len = indicadoropcao.parametro['periodo'];
            String keymodified = "$id:$c_Len:body";
            if (!(mapsignals["mapEma"].containsKey(keymodified))) {
              mapsignals["mapEma"][keymodified] =
                  GenerateDataPoint.emabody(c_Len, stocks);
              print(
                  "criando datapoints mapEma com periodo $keymodified no $tipo");
            }
          }
          break;
        case 13:
          {
            List<IndicadoresOpcao> indicadoresopcao =
                indicadoropcao.indicadoresopcoes;
            Map<String, Map<String, dynamic>> multimap =
                GeraMapDataPoint.generateMapSignals(
                    indicadoresopcao, stocks, "MultiCondicional");

            multimap.forEach((key, mapParametros) {
              mapParametros.forEach((keyP, valueP) {
                mapsignals[key][keyP] = valueP;
              });
            });
          }
          break;
        case 14:
          {
            if (indicadoropcao.configselecionado.id == "saida5" ||
                indicadoropcao.configselecionado.id == "saida6") {
              String keymodified = "$id:$periodo:atr";
              if (!(mapsignals["mapAtr"].containsKey(keymodified))) {
                mapsignals["mapAtr"][keymodified] = GenerateDataPoint.atr(
                    indicadoropcao.parametro["periodo"], stocks);
                print(
                    "criando datapoints mapAtr com periodo $keymodified no $tipo");
              }
            } else if (indicadoropcao.configselecionado.id == "saida7") {
              String keymodified = "$id:$periodo:close";
              if (!(mapsignals["mapSma"].containsKey(keymodified))) {
                mapsignals["mapSma"][keymodified] = GenerateDataPoint.sma(
                    indicadoropcao.parametro["periodo"], stocks, "close");
                print(
                    "criando datapoints mapSma com periodo $keymodified no $tipo");
              }
            } else if (indicadoropcao.configselecionado.id == "saida8") {
              String keymodified = "$id:$periodo:high";
              if (!(mapsignals["mapSma"].containsKey(keymodified))) {
                mapsignals["mapSma"][keymodified] = GenerateDataPoint.sma(
                    indicadoropcao.parametro["periodo"], stocks, "high");
                print(
                    "criando datapoints mapSma com periodo $keymodified no $tipo");
              }
            } else if (indicadoropcao.configselecionado.id == "saida9") {
              String keymodified = "$id:$periodo:low";
              if (!(mapsignals["mapSma"].containsKey(keymodified))) {
                mapsignals["mapSma"][keymodified] = GenerateDataPoint.sma(
                    indicadoropcao.parametro["periodo"], stocks, "low");
                print(
                    "criando datapoints mapSma com periodo $keymodified no $tipo");
              }
            }
          }
          break;
      }
    });

    return mapsignals;
  }

  static MapIndicadores generateMap(List<IndicadoresOpcao> buysignals,
      List<IndicadoresOpcao> sellsignals, stocks) {
    MapIndicadores map = MapIndicadores(
        mapSma: {},
        mapStochastic: {},
        mapIfr: {},
        mapMacd: {},
        mapBollinger: {},
        mapAcumDist: {},
        mapEma: {},
        mapAtr: {});

    Map<String, Map<String, dynamic>> mapsignals = {
      "mapSma": {},
      "mapStochastic": {},
      "mapIfr": {},
      "mapMacd": {},
      "mapBollinger": {},
      "mapAcumDist": {},
      "mapEma": {},
      "mapAtr": {}
    };

    Map<String, Map<String, dynamic>> buymap =
        generateMapSignals(buysignals, stocks, "buysignals");
    Map<String, Map<String, dynamic>> sellmap =
        generateMapSignals(sellsignals, stocks, "sellsignals");

    buymap.forEach((key, mapParametros) {
      mapParametros.forEach((keyP, valueP) {
        mapsignals[key][keyP] = valueP;
      });
    });

    sellmap.forEach((key, mapParametros) {
      mapParametros.forEach((keyP, valueP) {
        mapsignals[key][keyP] = valueP;
      });
    });

    map = MapIndicadores(
        mapSma: mapsignals["mapSma"],
        mapStochastic: mapsignals["mapStochastic"],
        mapIfr: mapsignals["mapIfr"],
        mapMacd: mapsignals["mapMacd"],
        mapBollinger: mapsignals["mapBollinger"],
        mapAcumDist: mapsignals["mapAcumDist"],
        mapEma: mapsignals["mapEma"],
        mapAtr: mapsignals["mapAtr"]);
    return map;
  }
}
