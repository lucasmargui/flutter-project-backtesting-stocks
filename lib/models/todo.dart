import 'package:flutter/material.dart';

class Stock {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final DateTime datetime;

  Stock({
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
    this.datetime,
  });

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return value.toDouble();
    } else {
      return value;
    }
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      open: checkDouble(json['open']),
      high: checkDouble(json['high']),
      low: checkDouble(json['low']),
      close: checkDouble(json['close']),
      volume: checkDouble(json['volume']),
      datetime: DateTime.parse(json["datetime"]),
    );
  }
}

class StockName {
  final String name;

  StockName({
    this.name,
  });

  factory StockName.fromJson(Map<String, dynamic> json) {
    return StockName(
      name: json['name'],
    );
  }
}

class DesvioEstrategyData {
  DesvioEstrategyData(
      {this.index, this.stock, this.midBand, this.lowBand, this.upBand});
  int index;
  Stock stock;
  num midBand;
  num lowBand;
  num upBand;
  bool visible;
}

class AppColors {
  AppColors._();
  static const Color primary = Color.fromRGBO(0, 29, 45, 1);
  static const Color white = Colors.white;
  static const Color menu = Colors.black;
}

class IndicadoresOpcao {
  IndicadoresOpcao({
    this.id,
    this.name,
    this.description,
    this.config,
    this.configselecionado,
    this.indicadoresopcoes,
    this.parametro,
  });
  final int id;
  final String name;
  final String description;
  final List<Condicional> config;
  Condicional configselecionado;
  List<IndicadoresOpcao> indicadoresopcoes;
  Map<String, num> parametro;

  static List<IndicadoresOpcao> get list {
    return [
      IndicadoresOpcao(
        id: 1,
        name: 'A/D',
        description: 'some description',
        config: [
          Condicional(
              id: "acudis1",
              title: "Acum/Dist sequência de alta",
              checkbox: true),
          Condicional(
              id: "acudis2",
              title: "Acum/Dist sequência de baixa",
              checkbox: true),
          Condicional(
              id: "acudis3",
              title: "Acum/Dist virou para cima após sequência de queda",
              checkbox: true),
          Condicional(
              id: "acudis4",
              title: "Acum/Dist virou para baixo após sequência de alta",
              checkbox: true),
          Condicional(
              id: "acudis5",
              title: "Acum/Dist cruzou para cima da média",
              checkbox: true),
          Condicional(
              id: "acudis6",
              title: "Acum/Dist cruzou para baixo da média",
              checkbox: true),
        ],
        configselecionado: Condicional(
            id: "acudis1",
            title: "Acum/Dist sequência de alta",
            checkbox: true),
        parametro: {"sequencia": 0, "periodo": 0},
      ),
      // IndicadoresOpcao(
      //   id:2,
      //   name: 'True range',
      //   description: 'some description',
      //   config: null,
      // ),
      IndicadoresOpcao(
        id: 3,
        name: 'Bollinger',
        description: 'some description',
        config: [
          Condicional(
              id: "bollinger1", title: "Preço acima upperband", checkbox: true),
          Condicional(
              id: "bollinger2",
              title: "Preço abaixo lowerband",
              checkbox: true),
          Condicional(
              id: "bollinger3",
              title: "Preço cruza para cima da upperband",
              checkbox: true),
          Condicional(
              id: "bollinger4",
              title: "Preço cruza para baixo da upperband",
              checkbox: true),
          Condicional(
              id: "bollinger5",
              title: "Preço cruza para cima da lowerband",
              checkbox: true),
          Condicional(
              id: "bollinger6",
              title: "Preço cruza para baixo da lowerband",
              checkbox: true),
          Condicional(
              id: "bollinger7", title: "Bollinger contraindo", checkbox: true),
          Condicional(
              id: "bollinger8", title: "Bollinger expandindo", checkbox: true),
        ],
        configselecionado: Condicional(
            id: "bollinger1", title: "Preço acima upperband", checkbox: true),
        parametro: {"desvio": 2, "periodo": 20, "sequencia": 0},
      ),
      IndicadoresOpcao(
        id: 4,
        name: 'Média Exp',
        description: 'some description',
        config: [
          Condicional(
              id: "ema1",
              title: "Preço maior que média exponencial",
              checkbox: true),
          Condicional(
              id: "ema2",
              title: "Preço menor que média exponencial",
              checkbox: true),
          Condicional(
              id: "ema3",
              title: "Sequência de altas consecutivas da média exponencial",
              checkbox: true),
          Condicional(
              id: "ema4",
              title: "Sequência de baixas consecutivas da média exponencial",
              checkbox: true),
          Condicional(
              id: "ema5",
              title: "Preço cruzou pra cima da média exponencial",
              checkbox: true),
          Condicional(
              id: "ema6",
              title: "Preço cruzou pra baixo da média exponencial",
              checkbox: true),
          Condicional(
              id: "ema7",
              title: "Média exponencial curta cruza média longa pra cima",
              checkbox: true),
          Condicional(
              id: "ema8",
              title: "Média exponencial curta cruza média longa pra baixo",
              checkbox: true),
          Condicional(
              id: "ema9",
              title:
                  "Média exponencial virou para baixo após sequência de altas consecutivas da média",
              checkbox: true),
          Condicional(
              id: "ema10",
              title:
                  "Média exponencial virou para cima após sequência de baixas consecutivas da média",
              checkbox: true),
        ],
        configselecionado: Condicional(
            id: "ema1",
            title: "Preço maior que média exponencial",
            checkbox: true),
        parametro: {"periodo": 20, "periodolongo": 50, "sequencia": 0},
      ),
      IndicadoresOpcao(
        id: 5,
        name: 'MACD',
        description: 'some description',
        config: [
          Condicional(
              id: "macd1",
              title: "Macd cruzou acima signal line",
              checkbox: true),
          Condicional(
              id: "macd2",
              title: "Macd cruzou abaixo signal line",
              checkbox: true),
          Condicional(id: "macd3", title: "Macd acima de zero", checkbox: true),
          Condicional(
              id: "macd4", title: "Macd abaixo de zero", checkbox: true),
          Condicional(
              id: "macd5",
              title: "Exaustão de compra após (n)periodos",
              checkbox: true),
          Condicional(
              id: "macd6",
              title: "Exaustao de venda após (n)periodos",
              checkbox: true),
          Condicional(
              id: "macd7",
              title: "Histogram sequência de alta",
              checkbox: true),
          Condicional(
              id: "macd8",
              title: "Histogram sequência de queda",
              checkbox: true),
          Condicional(
              id: "macd9",
              title: "Histogram sequência de alta acima de 0",
              checkbox: true),
          Condicional(
              id: "macd10",
              title: "Histogram sequência de queda abaixo de 0",
              checkbox: true),
        ],
        configselecionado: Condicional(
            id: "macd1",
            title: "Macd cruzou acima signal line",
            checkbox: true),
        parametro: {
          "periodorapido": 12,
          "periodolento": 26,
          "periodo": 9,
          "sequencia": 0
        },
      ),
      // IndicadoresOpcao(
      //   id:6,
      //   name: 'Momentum',
      //   description: 'some description',
      //   config: null,
      // ),
      IndicadoresOpcao(
        id: 7,
        name: 'IFR',
        description: 'some description',
        config: [
          Condicional(
              id: "ifr1",
              title: "Entrou na zona de sobrecompra",
              checkbox: true),
          Condicional(
              id: "ifr2", title: "Saiu da zona de sobrecompra", checkbox: true),
          Condicional(
              id: "ifr3",
              title: "Entrou na zona de sobrevenda",
              checkbox: true),
          Condicional(
              id: "ifr4", title: "Saiu da zona de sobrevenda", checkbox: true),
          Condicional(id: "ifr5", title: "Sobrecomprado", checkbox: true),
          Condicional(id: "ifr6", title: "Sobrevendido", checkbox: true),
        ],
        configselecionado: Condicional(
            id: "ifr1", title: "Entrou na zona de sobrecompra", checkbox: true),
        parametro: {"sobrecomprado": 80, "sobrevendido": 20, "periodo": 14},
      ),
      IndicadoresOpcao(
        id: 8,
        name: 'Média',
        description: 'some description',
        config: [
          Condicional(
              id: "media1", title: "Preço maior que média ", checkbox: true),
          Condicional(
              id: "media2", title: "Preço menor que média", checkbox: true),
          Condicional(
              id: "media3",
              title: "Sequência de altas consecutivas da média",
              checkbox: true),
          Condicional(
              id: "media4",
              title: "Sequência de baixas consecutivas da média",
              checkbox: true),
          Condicional(
              id: "media5",
              title: "Preço cruzou pra cima da média",
              checkbox: true),
          Condicional(
              id: "media6",
              title: "Preço cruzou pra baixo da média",
              checkbox: true),
          Condicional(
              id: "media7",
              title: "Média curta cruza média longa pra cima",
              checkbox: true),
          Condicional(
              id: "media8",
              title: "Média curta cruza média longa pra baixo",
              checkbox: true),
          Condicional(
              id: "media9",
              title:
                  "Média virou para baixo após sequência de altas consecutivas da média",
              checkbox: true),
          Condicional(
              id: "media10",
              title:
                  "Média virou para cima após sequência de baixas consecutivas da média",
              checkbox: true),
        ],
        configselecionado: Condicional(
            id: "media1", title: "Preço maior que média ", checkbox: true),
        parametro: {"periodo": 20, "periodolongo": 50, "sequencia": 0},
      ),
      IndicadoresOpcao(
        id: 9,
        name: 'Estocástico',
        description: 'some description',
        config: [
          Condicional(
              id: "stochastic1",
              title: "Entrou na zona de sobrecompra",
              checkbox: true),
          Condicional(
              id: "stochastic2",
              title: "Saiu da zona de sobrecompra",
              checkbox: true),
          Condicional(
              id: "stochastic3",
              title: "Entrou na zona de sobrevenda",
              checkbox: true),
          Condicional(
              id: "stochastic4",
              title: "Saiu da zona de sobrevenda",
              checkbox: true),
          Condicional(
              id: "stochastic5", title: "Sobrecomprado", checkbox: true),
          Condicional(id: "stochastic6", title: "Sobrevendido", checkbox: true),
          Condicional(
              id: "stochastic7",
              title: "Sobrecomprado há (n) periodos",
              checkbox: true),
          Condicional(
              id: "stochastic8",
              title: "Sobrevendido há (n) periodos",
              checkbox: true),
          Condicional(
              id: "stochastic9",
              title: "Estocástico cruzou para cima do signal line",
              checkbox: true),
          Condicional(
              id: "stochastic10",
              title: "Estocástico cruzou para baixo do signal line",
              checkbox: true),
        ],
        configselecionado: Condicional(
            id: "stochastic1",
            title: "Entrou na zona de sobrecompra",
            checkbox: true),
        parametro: {
          "k": 3,
          "d": 3,
          "sobrecomprado": 80,
          "sobrevendido": 20,
          "periodo": 14,
          "sequencia": 0
        },
      ),
      IndicadoresOpcao(
        id: 10,
        name: 'Candles',
        description: 'some description',
        config: [
          Condicional(
              id: "candle1",
              title: "Candle sequência de alta",
              checkbox: false),
          Condicional(
              id: "candle2",
              title: "Candle sequência de baixa",
              checkbox: false),
          Condicional(
              id: "candle3",
              title: "Fechamento maior que fechamento (n)periodos",
              checkbox: false),
          Condicional(
              id: "candle4",
              title: "Fechamento menor que fechamento (n)periodos",
              checkbox: false),
          Condicional(
              id: "candle5",
              title: "Fechamento maior que máxima (n)periodos",
              checkbox: false),
          Condicional(
              id: "candle6",
              title: "Fechamento menor que máxima (n)periodos",
              checkbox: false),
          Condicional(
              id: "candle7",
              title: "Fechamento maior que mínima (n)periodos",
              checkbox: false),
          Condicional(
              id: "candle8",
              title: "Fechamento menor que mínima (n)periodos",
              checkbox: false),
          Condicional(
              id: "candle9",
              title: "Preço esta acima de um valor",
              checkbox: false),
          Condicional(
              id: "candle10",
              title: "Preço esta abaixo de um valor",
              checkbox: false),
          Condicional(
              id: "candle11",
              title: "Preço cruzou um valor para cima",
              checkbox: false),
          Condicional(
              id: "candle12",
              title: "Preço cruzou um valor para baixo",
              checkbox: false),
        ],
        configselecionado: Condicional(
            id: "candle1", title: "Candle sequência de alta", checkbox: false),
        parametro: {"periodo": 0, "preco": 0.0, "sequencia": 0, "posicao": 0},
      ),
      IndicadoresOpcao(
        id: 11,
        name: 'Data',
        description: 'some description',
        config: [
          Condicional(id: "data1", title: "Depois do Dia", checkbox: false),
          Condicional(id: "data2", title: "Antes do Dia", checkbox: false),
          Condicional(
              id: "data3", title: "A partir dessa Data", checkbox: false),
          Condicional(id: "data4", title: "Antes dessa Data", checkbox: false),
          Condicional(
              id: "data5", title: "Intervalo de datas", checkbox: false),
          Condicional(id: "data6", title: "Começo mês", checkbox: false),
          Condicional(id: "data7", title: "Final mês", checkbox: false),
        ],
        configselecionado:
            Condicional(id: "data1", title: "Depois do Dia", checkbox: false),
        parametro: {
          "mesinicio": 1,
          "diainicio": 1,
          "mesfim": 1,
          "diafim": 1,
          "mes": 1,
          "dia": 1
        },

        ///parametro: {"dia":1},
        ///parametro: {"mes":1 "dia":1},
        //////parametro: {"mesinicio":1 "diainicio":1,"mesfim":1, "diafim":1,"mes":1, "dia":1},
      ),
      IndicadoresOpcao(
        id: 12,
        name: 'Candlestick',
        description: 'some description',
        config: [
          Condicional(
              id: "cpattern1", title: "Engolfo de baixa", checkbox: false),
          Condicional(
              id: "cpattern2", title: "Engolfo de alta", checkbox: false),
          Condicional(
              id: "cpattern3",
              title: "Abandoned baby de baixa",
              checkbox: false),
          Condicional(
              id: "cpattern4",
              title: "Abandoned baby de alta",
              checkbox: false),
          Condicional(
              id: "cpattern5", title: "Doji star de baixa", checkbox: false),
          Condicional(
              id: "cpattern6", title: "Doji star de alta", checkbox: false),
          Condicional(
              id: "cpattern7", title: "Dragonfly doji - alta", checkbox: false),
          Condicional(
              id: "cpattern8",
              title: "Estrela da noite doji - baixa",
              checkbox: false),
          Condicional(
              id: "cpattern9",
              title: "Estrela da noite - baixa",
              checkbox: false),
          Condicional(
              id: "cpattern10",
              title: "Falling Three Methods - baixa",
              checkbox: false),
          Condicional(
              id: "cpattern11",
              title: "Gravestone doji - baixa",
              checkbox: false),
          Condicional(
              id: "cpattern12", title: "Martelo - alta", checkbox: false),
          Condicional(
              id: "cpattern13",
              title: "Martelo Invertido - alta",
              checkbox: false),
          Condicional(
              id: "cpattern14", title: "Enforcado - baixa", checkbox: false),
          Condicional(
              id: "cpattern15", title: "Marobuzu - baixa", checkbox: false),
          Condicional(
              id: "cpattern16", title: "Marobuzu - alta", checkbox: false),
          Condicional(
              id: "cpattern17",
              title: "Estrela da manhã - alta",
              checkbox: false),
          Condicional(
              id: "cpattern18",
              title: "Estrela da manhã doji - alta",
              checkbox: false),
          Condicional(
              id: "cpattern19",
              title: "Rising Three Methods - alta",
              checkbox: false),
          Condicional(
              id: "cpattern20",
              title: "Shooting Star - baixa",
              checkbox: false),
          Condicional(
              id: "cpattern21",
              title: "Three White Soldiers - alta",
              checkbox: false),
          Condicional(
              id: "cpattern22",
              title: "Three Black Crows - baixa",
              checkbox: false),
          Condicional(
              id: "cpattern23",
              title: "Tweezer Bottom - alta",
              checkbox: false),
          Condicional(
              id: "cpattern24", title: "Tweezer Top - baixa", checkbox: false),
        ],
        configselecionado: Condicional(
            id: "cpattern1", title: "Engolfo de baixa", checkbox: false),
        parametro: {
          "periodo": 14,
        },
      ),
      IndicadoresOpcao(
        id: 13,
        name: 'MultiCondicional',
        description: 'some description',
        indicadoresopcoes: [],
        parametro: {
          "periodo": 0,
        },
      ),
      IndicadoresOpcao(
        id: 14,
        name: 'Saída',
        description: 'some description',
        config: [
          Condicional(
              id: "saida1", title: "Saida após (n) periodos", checkbox: false),
          Condicional(
              id: "saida2",
              title: "Saida após primeiro candle no lucro",
              checkbox: false),
          Condicional(id: "saida3", title: "Stop gain %", checkbox: false),
          Condicional(id: "saida4", title: "Stop loss %", checkbox: false),
          Condicional(id: "saida5", title: "Stop gain Atr", checkbox: true),
          Condicional(id: "saida6", title: "Stop loss Atr", checkbox: true),
          Condicional(
              id: "saida7",
              title: "Stop na média dos fechamentos",
              checkbox: true),
          Condicional(
              id: "saida8",
              title: "Stop gain na média das máximas",
              checkbox: true),
          Condicional(
              id: "saida9",
              title: "Stop loss na média das minimas",
              checkbox: true),
          Condicional(
              id: "saida10",
              title: "Stop móvel no fechamento (n) periodos anteriores",
              checkbox: false),
          Condicional(
              id: "saida11",
              title: "Stop loss móvel na minima (n) periodos anteriores",
              checkbox: false),
          Condicional(
              id: "saida12",
              title: "Stop loss móvel na maxima (n) periodos anteriores",
              checkbox: false),
          Condicional(
              id: "saida13",
              title: "Stop gain móvel na minima (n) periodos anteriores",
              checkbox: false),
          Condicional(
              id: "saida14",
              title: "Stop gain móvel na maxima (n) periodos anteriores",
              checkbox: false),
          Condicional(
              id: "saida15",
              title:
                  "Stop fixo no fechamento (n) periodos anteriores após entrada",
              checkbox: false),
          Condicional(
              id: "saida16",
              title:
                  "Stop loss fixo na minima (n) periodos anteriores após entrada",
              checkbox: false),
          Condicional(
              id: "saida17",
              title:
                  "Stop loss fixo na maxima (n) periodos anteriores após entrada",
              checkbox: false),
          Condicional(
              id: "saida18",
              title:
                  "Stop gain fixo na minima (n) periodos anteriores após entrada",
              checkbox: false),
          Condicional(
              id: "saida19",
              title:
                  "Stop gain fixo na maxima (n) periodos anteriores após entrada",
              checkbox: false),
        ],
        configselecionado: Condicional(
            id: "saida1", title: "Saida após (n) periodos", checkbox: false),
        parametro: {"periodo": 0, "gain": 0.0, "loss": 0.0, "fatorAtr": 2},
      ),
    ];
  }
}

class Condicional {
  Condicional({
    this.id,
    this.title,
    this.checkbox,
  });
  final String id;
  final String title;
  final bool checkbox;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    return (other is Condicional) &&
        other.id == id &&
        other.title == title &&
        other.checkbox == checkbox;
  }
}

class Trade {
  Trade({
    this.entrada,
    this.saida,
    this.indexentrada,
    this.indexsaida,
  });
  final Stock entrada;
  final Stock saida;
  final int indexentrada;
  final int indexsaida;
}

class Estatistica {
  Estatistica({
    this.total,
    this.gain,
    this.loss,
    this.qtdgain,
    this.qtdloss,
    this.qtddiasgain,
    this.qtddiasloss,
    this.dadosanalisados,
    this.payoff,
    this.profit,
    this.profitporcentagem,
    this.maximumdrawndown,
  });
  int total;
  double gain;
  double loss;
  int qtdgain;
  int qtdloss;
  int qtddiasgain;
  int qtddiasloss;
  int dadosanalisados;
  double payoff;
  double profit;
  double profitporcentagem;
  double maximumdrawndown;
}

class PivotPointData {
  PivotPointData({this.stock, this.pivotpoint, this.index});
  Stock stock;
  PivotPoint pivotpoint;
  int index;
}

class PivotPoint {
  PivotPoint({
    this.r3,
    this.r2,
    this.r1,
    this.pivot,
    this.s1,
    this.s2,
    this.s3,
  });
  double r3;
  double r2;
  double r1;
  double pivot;
  double s1;
  double s2;
  double s3;
}

class MapIndicadores {
  MapIndicadores(
      {@required this.mapSma,
      @required this.mapStochastic,
      @required this.mapIfr,
      @required this.mapMacd,
      @required this.mapBollinger,
      @required this.mapAcumDist,
      @required this.mapEma,
      @required this.mapAtr});
  Map mapSma;
  Map mapStochastic;
  Map mapIfr;
  Map mapMacd;
  Map mapBollinger;
  Map mapAcumDist;
  Map mapEma;
  Map mapAtr;
}

class DataPoint {
  DataPoint(
      {@required this.x,
      @required this.y,
      @required this.stock,
      @required this.index});
  DateTime x;
  num y;
  Stock stock;
  int index;
}

class BollingerPointData {
  BollingerPointData(
      {@required this.index,
      @required this.midBand,
      @required this.lowBand,
      @required this.upBand,
      @required this.stock});
  int index;
  num midBand;
  num lowBand;
  num upBand;
  Stock stock;
}
