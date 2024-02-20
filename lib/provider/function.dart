import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:scouting/models/todo.dart';

class FunctionStock {
  static double getmin(List<Stock> candles) {
    List<int> values = candles.map((Stock candle) {
      return (candle.low).toInt();
    }).toList();

    double lowclose = values.reduce(math.min).toDouble();

    return lowclose;
  }

  static double getmax(List<Stock> candles) {
    List<int> values = candles.map((Stock candle) {
      return (candle.high).round();
    }).toList();

    double highclose = values.reduce(math.max).toDouble();

    return highclose;
  }

  static double roundDouble(double value, int places) {
    double mod = math.pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  static Future<List<Stock>> parseJsonFrom(String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    var stringjson = await rootBundle.loadString(assetsPath);
    List<dynamic> json = jsonDecode(stringjson);
    List<Stock> stockslist = json.map(
      (dynamic item) {
        return Stock.fromJson(item);
      },
    ).toList();
    print('--- Filtrando para dados acima de 2000');
    List<Stock> stockslistfiltered =
        stockslist.where((e) => e.datetime.year >= 2000).toList();
    return stockslistfiltered;
  }

  static Future<List<StockName>> parseJsonNameFromAssets(
      String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    String stringjson = await rootBundle.loadString(assetsPath);
    List<dynamic> json = jsonDecode(stringjson);
    List<StockName> stockslist = json.map(
      (dynamic item) {
        return StockName.fromJson(item);
      },
    ).toList();
    return stockslist;
  }

  static candleInfo(
      List<Stock> stocks, int index, num emaBodyValue, num c_Len) {
    num close = stocks[index].close;
    num open = stocks[index].open;
    num high = stocks[index].high;
    num low = stocks[index].low;

    num c_ShadowPercent = 5.0; // size of shadows
    num c_ShadowEqualsPercent = 100.0;
    num c_DojiBodyPercent = 5.0;
    num c_Factor = 2.0; // shows the numb

    var c_BodyHi = math.max(close, open);
    var c_BodyLo = math.min(close, open);

    var c_BodyHi1 = math.max(stocks[index - 1].close, stocks[index - 1].open);
    var c_BodyLo1 = math.min(stocks[index - 1].close, stocks[index - 1].open);

    var c_Body = c_BodyHi - c_BodyLo;
    var c_BodyAvg = emaBodyValue;

    var c_SmallBody = c_Body < c_BodyAvg;
    var c_LongBody = c_Body > c_BodyAvg;

    // print("c_Body:$c_Body //// c_BodyAvg:$c_BodyAvg");

    var c_UpShadow = high - c_BodyHi;
    var c_DnShadow = c_BodyLo - low;
    var c_HasUpShadow = c_UpShadow > c_ShadowPercent / 100 * c_Body;
    var c_HasDnShadow = c_DnShadow > c_ShadowPercent / 100 * c_Body;

    var c_WhiteBody = open < close;
    var c_BlackBody = open > close;

    var c_Range = high - low;
    var c_IsInsideBar = (c_BodyHi1 > c_BodyHi && c_BodyLo1 < c_BodyLo);
    var c_BodyMiddle = c_Body / 2 + c_BodyLo;
    var c_ShadowEquals = c_UpShadow == c_DnShadow ||
        ((c_UpShadow - c_DnShadow).abs() / c_DnShadow * 100) <
                c_ShadowEqualsPercent &&
            ((c_DnShadow - c_UpShadow).abs() / c_UpShadow * 100) <
                c_ShadowEqualsPercent;
    var c_IsDojiBody =
        c_Range > 0 && c_Body <= c_Range * c_DojiBodyPercent / 100;
    var c_Doji = c_IsDojiBody && c_ShadowEquals;

    // print("c_SmallBody:$c_SmallBody /////////// c_LongBody:$c_LongBody");

    return {
      "c_Factor": c_Factor,
      "c_UpShadow": c_UpShadow,
      "c_DnShadow": c_UpShadow,
      "c_HasUpShadow": c_HasUpShadow,
      "c_HasDnShadow": c_HasDnShadow,
      "close": close,
      "open": open,
      "high": high,
      "low": low,
      "c_Len": c_Len,
      "c_BodyHi": c_BodyHi,
      "c_BodyLo": c_BodyLo,
      "c_Body": c_Body,
      "c_BodyAvg": c_BodyAvg,
      "c_SmallBody": c_SmallBody,
      "c_LongBody": c_LongBody,
      "c_WhiteBody": c_WhiteBody,
      "c_BlackBody": c_BlackBody,
      "c_Range": c_Range,
      "c_IsInsideBar": c_IsInsideBar,
      "c_BodyMiddle": c_BodyMiddle,
      "c_ShadowEquals": c_ShadowEquals,
      "c_IsDojiBody": c_IsDojiBody,
      "c_Doji": c_Doji,
    };
  }
}
