import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scouting/models/todo.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<MesesVariacao> _mesesvariacaoselected = [];

class VariacaoPage extends StatefulWidget {
  VariacaoPage({
    @required this.stockname,
    @required this.stocks,
  });

  final String stockname;
  final List<Stock> stocks;

  @override
  _VariacaoPageState createState() =>
      _VariacaoPageState(stockname: stockname, stocks: stocks);
}

class _VariacaoPageState extends State<VariacaoPage> {
  String stockname;
  List<Stock> stocks;

  _VariacaoPageState({
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

  List<MesesVariacao> mesesvariacaogenerate = [];
  List<ProjecaoForca> dataprojecao = [];

  @override
  void initState() {
    super.initState();
    print(stocks[0].datetime.year.toDouble());
    print(stocks.last.datetime.year.toDouble());
    setState(() {
      selectedRange = RangeValues(stocks[0].datetime.year.roundToDouble(),
          stocks.last.datetime.year.roundToDouble());

      var sub = stocks.last.datetime.year - stocks[0].datetime.year;
      divisions = sub > 0 ? sub : 1;
      rangeano = sub > 0 ? sub : 1;

      candles = stocks;
      mesesvariacaogenerate = prepareData();
      _mesesvariacaoselected = mesesvariacaogenerate;
      dataprojecao = generateProjecao();
    });
  }

  String randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });
    return new String.fromCharCodes(codeUnits);
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  List<ProjecaoForca> generateProjecao() {
    try {
      MesesVariacao sum = _mesesvariacaoselected.reduce((value, element) {
        return MesesVariacao(
            9000,
            value.jan + element.jan,
            value.fev + element.fev,
            value.mar + element.mar,
            value.abr + element.abr,
            value.mai + element.mai,
            value.jun + element.jun,
            value.jul + element.jul,
            value.ago + element.ago,
            value.sep + element.sep,
            value.out + element.out,
            value.nov + element.nov,
            value.dez + element.dez);
      });

      List<ProjecaoForca> projecaosoma = [];

      projecaosoma.add(ProjecaoForca('Jan', sum.jan));
      projecaosoma.add(ProjecaoForca('Fev', sum.fev));
      projecaosoma.add(ProjecaoForca('Mar', sum.mar));
      projecaosoma.add(ProjecaoForca('Abr', sum.abr));
      projecaosoma.add(ProjecaoForca('Mai', sum.mai));
      projecaosoma.add(ProjecaoForca('Jun', sum.jun));
      projecaosoma.add(ProjecaoForca('Jul', sum.jul));
      projecaosoma.add(ProjecaoForca('Ago', sum.ago));
      projecaosoma.add(ProjecaoForca('Set', sum.sep));
      projecaosoma.add(ProjecaoForca('Out', sum.out));
      projecaosoma.add(ProjecaoForca('Nov', sum.nov));
      projecaosoma.add(ProjecaoForca('Dez', sum.dez));

      print(projecaosoma);
      return projecaosoma;
    } catch (e) {
      print(e);
      throw Exception("Error on server");
    }
  }

  prepareData() {
    int ano = candles[0].datetime.year;
    List<MesesVariacao> mesesvariacao = [];

    try {
      print("ano inicial $ano");
      print("anos $rangeano");

      for (int i = 0; i <= rangeano; i++) {
        Map<num, dynamic> mesVar = {
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
        List<Stock> filteredporano =
            candles.where((e) => e.datetime.year == ano).toList();
        for (int j = 1; j <= 12; j++) {
          List<Stock> filteredpormes =
              filteredporano.where((e) => e.datetime.month == j).toList();
          if (filteredpormes.length > 0) {
            double primeirodia = filteredpormes[0].close;
            double ultimodia = filteredpormes.last.close;
            double porcentagem =
                ((ultimodia - primeirodia) / primeirodia) * 100;
            mesVar[j] = porcentagem;
          }
        }
        mesesvariacao.add(MesesVariacao(
            ano,
            mesVar[1],
            mesVar[2],
            mesVar[3],
            mesVar[4],
            mesVar[5],
            mesVar[6],
            mesVar[7],
            mesVar[8],
            mesVar[9],
            mesVar[10],
            mesVar[11],
            mesVar[12]));
        ano++;
      }

      return mesesvariacao;
    } catch (e) {
      print(e);
      throw Exception("Error on server");
    }
  }

  _buildEstatistica(BuildContext context) {
    return Container(
        height: 400,
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
                // Y axis labels will be rendered with currency format
                numberFormat: NumberFormat.percentPattern()),
            enableSideBySideSeriesPlacement: false,
            series: <ChartSeries>[
              SplineSeries<ProjecaoForca, dynamic>(
                  dataSource: dataprojecao,
                  dashArray: <double>[5, 5],
                  xValueMapper: (ProjecaoForca sazonal, _) => sazonal.month,
                  // Media da variação
                  // yValueMapper: (ProjecaoForca sazonal, _) => sazonal.porcentagem / (rangeano + 1)
                  yValueMapper: (ProjecaoForca sazonal, _) =>
                      sazonal.porcentagem / 100),
            ]));
  }

  _buildTableCedula(value) {
    Color color;

    if (value > 0) {
      color = Colors.green;
    } else if (value < 0) {
      color = Colors.red;
    } else {
      color = Colors.grey;
    }

    double heigth = MediaQuery.of(context).size.height / 16;
    return Expanded(
      child: Container(
        color: color,
        height: heigth,
        child: Center(
            child: Text(
          "${value.toInt()}%",
          style: TextStyle(color: AppColors.white, fontSize: 10),
        )),
      ),
    );
  }

  Widget _buildTableCedulaAno(value) {
    double widthdivision = 45;
    double heigth = MediaQuery.of(context).size.height / 30;
    return Container(
      padding: EdgeInsets.all(5),
      width: widthdivision,
      height: heigth,
      child: Text(
        "$value",
        style: TextStyle(color: AppColors.white, fontSize: 10),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    List<Widget> childrenTable = <Widget>[];

    List<Widget> childrenTd = _mesesvariacaoselected.map((element) {
      List<Widget> listcedulas = [];

      listcedulas.add(_buildTableCedulaAno(element.ano));

      listcedulas.add(_buildTableCedula(element.jan));

      listcedulas.add(_buildTableCedula(element.fev));

      listcedulas.add(_buildTableCedula(element.mar));

      listcedulas.add(_buildTableCedula(element.abr));

      listcedulas.add(_buildTableCedula(element.mai));

      listcedulas.add(_buildTableCedula(element.jun));

      listcedulas.add(_buildTableCedula(element.jul));

      listcedulas.add(_buildTableCedula(element.ago));

      listcedulas.add(_buildTableCedula(element.sep));

      listcedulas.add(_buildTableCedula(element.out));

      listcedulas.add(_buildTableCedula(element.nov));

      listcedulas.add(_buildTableCedula(element.dez));

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: listcedulas,
      );
    }).toList();

    childrenTable.addAll(childrenTd);

    return Padding(
      padding: const EdgeInsets.only(right: 7.0),
      child: Container(child: Column(children: childrenTable)),
    );
  }

  _buildGrafico(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 210,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Soma da variação de porcentagem de cada mês respectivo pelo intervalo de anos",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
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
                selectedRange = RangeValues(
                    value.start.roundToDouble(), value.end.roundToDouble());
                _mesesvariacaoselected = mesesvariacaogenerate
                    .where((e) =>
                        e.ano >= selectedRange.start.toInt() &&
                        e.ano <= selectedRange.end.toInt())
                    .toList();
                dataprojecao = generateProjecao();
                rangeano = (value.end - value.start).toInt();
              });
            },
          ),
          _buildEstatistica(context)
        ],
      ),
    );
  }

  _buildPageMain(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [_buildGrafico(context), _buildTable(context)],
      ),
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

class ProjecaoForca {
  ProjecaoForca(this.month, this.porcentagem);
  final String month;
  final double porcentagem;
}

class MesesVariacao {
  MesesVariacao(this.ano, this.jan, this.fev, this.mar, this.abr, this.mai,
      this.jun, this.jul, this.ago, this.sep, this.out, this.nov, this.dez);
  final int ano;
  final double jan;
  final double fev;
  final double mar;
  final double abr;
  final double mai;
  final double jun;
  final double jul;
  final double ago;
  final double sep;
  final double out;
  final double nov;
  final double dez;
}
