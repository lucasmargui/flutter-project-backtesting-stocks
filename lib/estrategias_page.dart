import 'package:flutter/material.dart';
import 'package:scouting/estatistica_page.dart';

import 'package:scouting/models/todo.dart';
import 'package:scouting/provider/parametrobox.dart';

class EstrategiasPage extends StatefulWidget {
  EstrategiasPage({
    Key key,
    @required this.stockname,
    @required this.stocks,
  }) : super(key: key);

  final String stockname;
  final List<Stock> stocks;

  @override
  _EstrategiasPageState createState() =>
      _EstrategiasPageState(stocks: stocks, stockname: stockname);
}

class _EstrategiasPageState extends State<EstrategiasPage> {
  _EstrategiasPageState({
    @required this.stocks,
    @required this.stockname,
  });

  final List<Stock> stocks;
  final String stockname;

  List<IndicadoresOpcao> buysignals = [];
  List<IndicadoresOpcao> sellsignals = [];

  _openPopUp(IndicadoresOpcao indicadoropcao) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [
                      0.3,
                      0.9,
                    ],
                        colors: [
                      AppColors.primary,
                      AppColors.primary,
                    ])),
                child: Stack(
                  // ignore: deprecated_member_use
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -10.0,
                      top: -10.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    ParametroBox(indicadoropcao: indicadoropcao)
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _deleteItemSellSignals(IndicadoresOpcao indicadoropcao) {
    setState(() {
      sellsignals.remove(indicadoropcao);
    });
  }

  void _deleteItemBuySignals(IndicadoresOpcao indicadoropcao) {
    setState(() {
      buysignals.remove(indicadoropcao);
    });
  }

  void _deleteItemMultiSellSignals(
      IndicadoresOpcao indicadoropcao, IndicadoresOpcao element) {
    int indexof = sellsignals.indexOf(indicadoropcao);
    setState(() {
      sellsignals[indexof].indicadoresopcoes.remove(element);
    });
  }

  void _deleteItemMultiBuySignals(
      IndicadoresOpcao indicadoropcao, IndicadoresOpcao element) {
    int indexof = buysignals.indexOf(indicadoropcao);
    setState(() {
      buysignals[indexof].indicadoresopcoes.remove(element);
    });
  }

  _buildindicadores() {
    return Container(
        padding: const EdgeInsets.all(4),
        child: ListView(
          children: [
            FurnitureGrid(
              furnitures: IndicadoresOpcao.list,
            ),
          ],
        ));
  }

  _buildcompravenda() {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      "Compra",
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [
                          0.3,
                          0.9,
                        ],
                            colors: [
                          Colors.green[200],
                          Colors.green[400],
                        ])),
                    height: 180,
                    child: _buyDragTarget,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      "Venda",
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white),
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [
                          0.3,
                          0.9,
                        ],
                            colors: [
                          Colors.red[200],
                          Colors.red[400],
                        ])),
                    height: 180,
                    child: _sellDragTarget,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50.0,
            child: RaisedButton(
              onPressed: () {
                buysignals.forEach((element) {
                  if (element.id != 13) {
                    print(
                        "///////////////EstrategiaPageCompra//////////////////");
                    print("Indicador:${element.name}");
                    print(
                        "Selecionado:   id:${element.configselecionado.id},title:${element.configselecionado.title}");
                    print("Parametro:${element.parametro}");
                    print("///////////////");
                  } else {
                    element.indicadoresopcoes.forEach((elementsingle) {
                      print(
                          "///////////////EstrategiaPageCompraMultiCondicional//////////////////");
                      print("Indicador:${elementsingle.name}");
                      print(
                          "Selecionado:   id:${elementsingle.configselecionado.id},title:${elementsingle.configselecionado.title}");
                      print("Parametro:${elementsingle.parametro}");
                      print("///////////////");
                    });
                  }
                });

                sellsignals.forEach((element) {
                  if (element.id != 13) {
                    print(
                        "///////////////EstrategiaPageVenda//////////////////");
                    print("Indicador:${element.name}");
                    print(
                        "Selecionado:   id:${element.configselecionado.id},title:${element.configselecionado.title}");
                    print("Parametro:${element.parametro}");
                    print("///////////////");
                  } else {
                    element.indicadoresopcoes.forEach((elementsingle) {
                      print(
                          "///////////////EstrategiaPageVendaMultiCondicional//////////////////");
                      print("Indicador:${elementsingle.name}");
                      print(
                          "Selecionado:   id:${elementsingle.configselecionado.id},title:${elementsingle.configselecionado.title}");
                      print("Parametro:${elementsingle.parametro}");
                      print("///////////////");
                    });
                  }
                });

                if (buysignals.isNotEmpty && sellsignals.isNotEmpty) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => EstatisticaPage(
                        stocks: stocks,
                        stockname: stockname,
                        buysignals: buysignals,
                        sellsignals: sellsignals,
                      ),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 400),
                    ),
                  );
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Analisar",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.77,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  SizedBox(
                      child: _buildindicadores(),
                      width: MediaQuery.of(context).size.width * 0.32),
                  SizedBox(
                    child: _buildcompravenda(),
                    width: MediaQuery.of(context).size.width * 0.60,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buyDragMultTarget(IndicadoresOpcao e) {
    int indexofB = buysignals.indexOf(e);

    return DragTarget<IndicadoresOpcao>(
      builder: (context, candidateData, rejectedData) {
        return Center(
            child: e.indicadoresopcoes.isEmpty
                ? Text(
                    'Indicador 1 ou Indicador 2',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  )
                : ListView(
                    children: [
                      Column(
                        children: e.indicadoresopcoes.map((element) {
                          int indexofI = buysignals[indexofB]
                              .indicadoresopcoes
                              .indexOf(element);

                          return Card(
                              elevation: 5,
                              child: ListTile(
                                leading: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.settings),
                                  color: Colors.blue,
                                  onPressed: () => _openPopUp(
                                      buysignals[indexofB]
                                          .indicadoresopcoes[indexofI]),
                                ),
                                trailing: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.delete),
                                  color: Colors.grey,
                                  onPressed: () =>
                                      _deleteItemMultiBuySignals(e, element),
                                ),
                                title: Text(
                                  element.name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ));
                        }).toList(),
                      )
                    ],
                  ));
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        if (data.id != 13 && data.id != 14) {
          setState(() => e.indicadoresopcoes.add(data));
        }
      },
    );
  }

  _sellDragMultTarget(IndicadoresOpcao e) {
    int indexofB = sellsignals.indexOf(e);

    return DragTarget<IndicadoresOpcao>(
      builder: (context, candidateData, rejectedData) {
        return Center(
            child: e.indicadoresopcoes.isEmpty
                ? Text(
                    'Indicador 1 ou Indicador 2',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  )
                : ListView(
                    children: [
                      Column(
                        children: e.indicadoresopcoes.map((element) {
                          int indexofI = sellsignals[indexofB]
                              .indicadoresopcoes
                              .indexOf(element);
                          return Card(
                              elevation: 5,
                              child: ListTile(
                                leading: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.settings),
                                  color: Colors.blue,
                                  onPressed: () => _openPopUp(
                                      sellsignals[indexofB]
                                          .indicadoresopcoes[indexofI]),
                                ),
                                trailing: IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(Icons.delete),
                                  color: Colors.grey,
                                  onPressed: () =>
                                      _deleteItemMultiSellSignals(e, element),
                                ),
                                title: Text(
                                  element.name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ));
                        }).toList(),
                      )
                    ],
                  ));
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        if (data.id != 13) {
          setState(() => e.indicadoresopcoes.add(data));
        }
      },
    );
  }

  Widget get _buyDragTarget {
    return DragTarget<IndicadoresOpcao>(
      builder: (context, candidateData, rejectedData) {
        return Center(
            child: buysignals.isEmpty
                ? Text(
                    'Arraste um indicador',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                : ListView(
                    children: [
                      Column(
                        children: buysignals
                            .map((e) => e.id != 13
                                ? Card(
                                    elevation: 5,
                                    child: ListTile(
                                      leading: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.settings),
                                        color: Colors.blue,
                                        onPressed: () => _openPopUp(e),
                                      ),
                                      trailing: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.delete),
                                        color: Colors.grey,
                                        onPressed: () =>
                                            _deleteItemBuySignals(e),
                                      ),
                                      title: Text(
                                        e.name,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ))
                                : Container(
                                    height: 120,
                                    child: Dismissible(
                                      key: UniqueKey(),
                                      onDismissed: (direction) {
                                        _deleteItemBuySignals(e);
                                      },
                                      child: Card(
                                        color: Colors.blue[900],
                                        child: _buyDragMultTarget(e),
                                      ),
                                    ),
                                  ))
                            .toList(),
                      )
                    ],
                  ));
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        if (data.id != 14) {
          setState(() => buysignals.add(data));
        }
      },
    );
  }

  Widget get _sellDragTarget {
    return DragTarget<IndicadoresOpcao>(
      builder: (context, candidateData, rejectedData) {
        return Center(
            child: sellsignals.isEmpty
                ? Text(
                    'Arraste um indicador',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                : ListView(
                    children: [
                      Column(
                        children: sellsignals
                            .map((e) => e.id != 13
                                ? Card(
                                    elevation: 5,
                                    child: ListTile(
                                      leading: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.settings),
                                        color: Colors.blue,
                                        onPressed: () => _openPopUp(e),
                                      ),
                                      trailing: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.delete),
                                        color: Colors.grey,
                                        onPressed: () =>
                                            _deleteItemSellSignals(e),
                                      ),
                                      title: Text(
                                        e.name,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ))
                                : Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (direction) {
                                      _deleteItemSellSignals(e);
                                    },
                                    child: Container(
                                      height: 120,
                                      child: Card(
                                          color: Colors.blue[900],
                                          child: _sellDragMultTarget(e)),
                                    ),
                                  ))
                            .toList(),
                      )
                    ],
                  ));
      },
      onWillAccept: (data) => true,
      onAccept: (data) {
        setState(() => sellsignals.add(data));
      },
    );
  }
}

class FurnitureGrid extends StatefulWidget {
  const FurnitureGrid({Key key, this.furnitures}) : super(key: key);
  final List<IndicadoresOpcao> furnitures;

  @override
  _FurnitureGridState createState() => _FurnitureGridState();
}

class _FurnitureGridState extends State<FurnitureGrid> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.furnitures.length,
        itemBuilder: (context, index) {
          return IndicadorItem(
            furniture: widget.furnitures[index],
          );
        });
  }
}

class IndicadorItem extends StatelessWidget {
  const IndicadorItem({
    @required this.furniture,
    Key key,
  }) : super(key: key);
  final IndicadoresOpcao furniture;

  @override
  Widget build(BuildContext context) {
    return Draggable<IndicadoresOpcao>(
      feedback: _itemmovimento,
      data: furniture,
      childWhenDragging: _indicadoreslista,
      onDragStarted: () {},
      onDragCompleted: () {},
      onDraggableCanceled: (velocity, offset) {},
      child: _indicadoreslista,
    );
  }

  Widget get _itemmovimento {
    return Material(
      color: Colors.transparent,
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
        alignment: Alignment.center,
        width: 120,
        height: 40,
        child: Text(
          furniture.name,
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: .18,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget get _indicadoreslista {
    return Card(
        elevation: 5,
        child: Container(
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.blue]),
          ),
          alignment: Alignment.center,
          width: 120,
          height: 35,
          child: Text(
            furniture.name,
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: .18,
            ),
          ),
        ));
  }
}
