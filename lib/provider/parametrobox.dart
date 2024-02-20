import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting/models/todo.dart';

class ParametroBox extends StatefulWidget {
  ParametroBox({
    @required this.indicadoropcao,
  });

  final IndicadoresOpcao indicadoropcao;

  @override
  _ParametroBoxState createState() =>
      _ParametroBoxState(indicadoropcao: indicadoropcao);
}

class _ParametroBoxState extends State<ParametroBox> {
  _ParametroBoxState({
    @required this.indicadoropcao,
  });

  IndicadoresOpcao indicadoropcao;

  final _formKey = GlobalKey<FormState>();


_buildInput(campo, labeltext){
  return Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: MediaQuery.of(context).size.height / 10,
                    child: TextFormField(
                       style: TextStyle(color: AppColors.menu),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(labelText: '$labeltext',labelStyle: TextStyle(color: AppColors.menu)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter value';
                          }
                          return null;
                        },
                        initialValue:
                            indicadoropcao.parametro["$campo"].toString(),
                        onSaved: (val) {
                          setState(() => indicadoropcao.parametro["$campo"] =
                              int.parse(val));
                        }),
                  );
}


_buildDropDown(campo){

    List<Map<String, dynamic>> items = [
          {'name': 'Janeiro', 'mes': 1},
          {'name': 'Fevereiro', 'mes': 2},
          {'name': 'Março', 'mes': 3},
          {'name': 'Abril', 'mes': 4},
          {'name': 'Maio', 'mes': 5},
          {'name': 'Junho', 'mes': 6},
          {'name': 'Julho', 'mes': 7},
          {'name': 'Agosto', 'mes': 8},
          {'name': 'Setembro', 'mes': 9},
          {'name': 'Outubro', 'mes': 10},
          {'name': 'Novembro', 'mes': 11},
          {'name': 'Dezembro', 'mes': 12}
        ];

  return DropdownButton(
                value: items
                    .where((e) =>
                        e['mes'] ==
                        indicadoropcao.parametro['$campo'])
                    .single['name'],
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 20,
                style: TextStyle(color: AppColors.menu),
                underline: Container(
                  height: 0,
                  color: AppColors.white,
                ),
                onChanged: (newValue) {
                  Map mapmes =
                      items.where((e) => e['name'] == newValue).single;
                  int messelecionado = mapmes['mes'];
                  print(messelecionado);
                  setState(() {
                    setState(() => indicadoropcao
                        .parametro["$campo"] = messelecionado);
                  });
                },
                items: items.map((Map<String, dynamic> value) {
                  return DropdownMenuItem(
                    value: value['name'],
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: MediaQuery.of(context).size.height / 10,
                        child: Text(value['name'])),
                  );
                }).toList(),
              );
}



_buildDropDownPosicao(){

    List<Map<String, dynamic>> items = [
          {'name': 'Candle atual', 'posicao': 0},
          {'name': 'Candle anterior', 'posicao': 1},
          {'name': 'Candle 2', 'posicao': 2},
          {'name': 'Candle 3', 'posicao': 3},
          {'name': 'Candle 4', 'posicao': 4},
          {'name': 'Candle 5', 'posicao': 5},
          {'name': 'Candle 6', 'posicao': 6},
          {'name': 'Candle 7', 'posicao': 7},
          {'name': 'Candle 8', 'posicao': 8},
          {'name': 'Candle 9', 'posicao': 9},
          {'name': 'Candle 10', 'posicao': 10},
        ];

  return Expanded(
    
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
                    value: items
                        .where((e) =>
                            e['posicao'] ==
                            indicadoropcao.parametro['posicao'])
                        .single['name'],
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 20,
                    style: TextStyle(color: AppColors.menu),
                    decoration: InputDecoration(

                      labelText: 'Posição do candle',
               
                    ),
                    onChanged: (newValue) {
                      Map mapposicao =
                          items.where((e) => e['name'] == newValue).single;
                      int posicaoselecionado = mapposicao['posicao'];
                      print(posicaoselecionado);
                      setState(() {
                        setState(() => indicadoropcao
                            .parametro["posicao"] = posicaoselecionado);
                      });
                    },
                    items: items.map((Map<String, dynamic> value) {
                      return DropdownMenuItem(
                        value: value['name'],
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.33,
                            height: MediaQuery.of(context).size.height / 10,
                            child: Text(value['name'])),
                      );
                    }).toList(),
                  ),
    ),
  );
}

  List<Widget> camposParametro() {
    List<Widget> textForm = <Widget>[];
    switch (indicadoropcao.id) {
      case 1:
        {
          if (indicadoropcao.configselecionado.id == 'acudis1' ||
              indicadoropcao.configselecionado.id == 'acudis2' ||
              indicadoropcao.configselecionado.id == 'acudis3' ||
              indicadoropcao.configselecionado.id == 'acudis4') {
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("sequencia","Sequência")
                ],
              )
            ];
            return textForm;
          } else if(indicadoropcao.configselecionado.id == 'acudis5' ||
              indicadoropcao.configselecionado.id == 'acudis6'){
            
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("periodo","Média de A/D")
                ],
              )
            ];
            return textForm;
          } else {
            textForm = [Container()];
            return textForm;
          }
        }
        break;

      case 2:
        {}
        break;

      case 3:
        {
          if (indicadoropcao.configselecionado.id == 'bollinger7' ||
              indicadoropcao.configselecionado.id == 'bollinger8') {
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("desvio","Desvio"),
                  _buildInput("periodo","Periodo")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("sequencia", "(n) periodos")
                ],
              )
            ];
          } else {
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("desvio", "Desvio"),
                  _buildInput("periodo", "Periodo")
                ],
              ),
            ];
          }

          return textForm;
        }
        break;
      case 4:
        {
        if (indicadoropcao.configselecionado.id == 'ema3' ||
              indicadoropcao.configselecionado.id == 'ema4'||
              indicadoropcao.configselecionado.id == 'ema9'|| 
              indicadoropcao.configselecionado.id == 'ema10'){
                textForm = <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("periodo", "Periodo"),
                      _buildInput("sequencia", "Sequência"),
                    ],
                  ),
                ];
                return textForm;
          }else if (indicadoropcao.configselecionado.id == 'ema7' ||
              indicadoropcao.configselecionado.id == 'ema8'){
                textForm = <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("periodo", "Periodo curto"),
                      _buildInput("periodolongo", "Periodo longo"),
                    ],
                  ),
                ];
                return textForm;
          }else{
            textForm = <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("periodo", "Periodo"),
                    ],
                  ),
                ];
                return textForm;
          }
        }
        break;
      case 5:
        {
          if(indicadoropcao.configselecionado.id == 'macd5' || 
          indicadoropcao.configselecionado.id == 'macd6' || 
          indicadoropcao.configselecionado.id == 'macd7' || 
          indicadoropcao.configselecionado.id == 'macd8' || 
          indicadoropcao.configselecionado.id == 'macd9' || 
          indicadoropcao.configselecionado.id == 'macd10'   ){
              textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  _buildInput("periodorapido", "Periodo Rápido"),
                  _buildInput("periodolento", "Periodo Lento")
                
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("periodo", "Periodo"),
                  _buildInput("sequencia", "Sequência"),
                ],
              )
            ];
            return textForm;
          }else{
              textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  _buildInput("periodorapido", "Periodo Rápido"),
                  _buildInput("periodolento", "Periodo Lento")
                
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("periodo", "Periodo"),
                ],
              )
            ];
            return textForm;
          }
          
        }
        break;

      case 6:
        {}
        break;

      case 7:
        {
          
          textForm = <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                _buildInput("sobrecomprado","Sobrecomprado"),
                _buildInput("sobrevendido","Sobrevendido"),
                
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInput("periodo", "Periodo"),
              ],
            )
          ];
          return textForm;
        }
        break;

      case 8:
        {
          if (indicadoropcao.configselecionado.id == 'media3' ||
              indicadoropcao.configselecionado.id == 'media4'||
              indicadoropcao.configselecionado.id == 'media9'|| 
              indicadoropcao.configselecionado.id == 'media10'){
                textForm = <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("periodo", "Periodo"),
                      _buildInput("sequencia", "Sequência"),
                    ],
                  ),
                ];
                return textForm;
          }else if (indicadoropcao.configselecionado.id == 'media7' ||
              indicadoropcao.configselecionado.id == 'media8'){
                textForm = <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("periodo", "Periodo curto"),
                      _buildInput("periodolongo", "Periodo longo"),
                    ],
                  ),
                ];
                return textForm;
          }else{
            textForm = <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("periodo", "Periodo"),
                    ],
                  ),
                ];
                return textForm;
          }
          
        }
        break;
      case 9:
        {
          if(indicadoropcao.configselecionado.id == 'stochastic7' || indicadoropcao.configselecionado.id == 'stochastic8'){
              textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  _buildInput("sobrecomprado","Sobrecomprado"),
                  _buildInput("sobrevendido","Sobrevendido"),
                  
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("periodo", "Periodo"),
                  _buildInput("sequencia", "(n) periodos"),
                ],
              )
            ];
            return textForm;
          }else{
              textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  _buildInput("sobrecomprado","Sobrecomprado"),
                  _buildInput("sobrevendido","Sobrevendido"),
                  
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("periodo", "Periodo"),
                ],
              )
            ];
            return textForm;
          }
        }
        break;
      case 10:
        {
          if(indicadoropcao.configselecionado.id == 'candle1' || indicadoropcao.configselecionado.id == 'candle2'){

              textForm = <Widget>[
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("sequencia", "(n) periodos"),             
                    ],
                  ),
                ];
                return textForm;

          }else if (indicadoropcao.configselecionado.id == 'candle3' ||
              indicadoropcao.configselecionado.id == 'candle4' ||
              indicadoropcao.configselecionado.id == 'candle5' ||
              indicadoropcao.configselecionado.id == 'candle6' ||
              indicadoropcao.configselecionado.id == 'candle7' ||
              indicadoropcao.configselecionado.id == 'candle8'){
              textForm = <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDropDownPosicao(),
           
                      
                    ],
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("sequencia", "(n) periodos"),             
                    ],
                  ),
                ];
                return textForm;
              }else{
                textForm = <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("preco", "Preço"),
                    ],
                  ),
                ];
                return textForm;
              }
          
        }
        break;
      case 11:
      

        {
          if (indicadoropcao.configselecionado.id == 'data1' ||
              indicadoropcao.configselecionado.id == 'data2') {
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("dia", "Dia"),
                ],
              ),
            ];
            return textForm;
          } else if (indicadoropcao.configselecionado.id == 'data3' ||
              indicadoropcao.configselecionado.id == 'data4') {
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("dia", "Dia"),
                  _buildDropDown("mes"),
                ],
              ),
            ];
            return textForm;
          } else if (indicadoropcao.configselecionado.id == 'data5') {
            textForm = <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("diainicio", "Inicio"),
                      _buildDropDown("mesinicio")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInput("diafim", "Até"),
                      _buildDropDown("mesfim")
                    ],
                  )
                ],
              ),
            ];
            return textForm;
          } else if (indicadoropcao.configselecionado.id == 'data6' ||
              indicadoropcao.configselecionado.id == 'data7') {
            textForm = [Container()];
            return textForm;
          } else {}
        }
        break;

        case 12:
        {
          textForm = [Container()];
            return textForm;
        }
        break;
      case 14:
        {
          if(indicadoropcao.configselecionado.id == 'saida2'){
            textForm = <Widget>[
              Container()
            ];
            return textForm;
          }else if (indicadoropcao.configselecionado.id == 'saida3') {
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("gain","Gain %")
                ],
              )
            ];
            return textForm;
          } else if(indicadoropcao.configselecionado.id == 'saida4'){
            
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   _buildInput("loss","Loss %")
                ],
              )
            ];
            return textForm;
          }else if(indicadoropcao.configselecionado.id == 'saida5' || indicadoropcao.configselecionado.id == 'saida6'){
            
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   _buildInput("periodo","Periodo"),
                   _buildInput("fatorAtr","Constante atr multiplicacao")
                ],
              )
            ];
            return textForm;
          } else {
            textForm = <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInput("periodo","(n) periodos")
                ],
              )
            ];
            return textForm;
          }
        }
        break;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Builder(
        builder: (context) => Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Parâmetros",
                      style: TextStyle(fontSize: 25,color: AppColors.white),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                        children: indicadoropcao.config
                            .map((Condicional condicional) {
                      return Card(
                        elevation: 5,
                        child: CheckboxListTile(
                            activeColor: Colors.blue,
                            title: Text(condicional.title, style: TextStyle(color: AppColors.menu),),
                            value:
                                indicadoropcao.configselecionado == condicional,
                            onChanged: (val) {
                              setState(() {
                                if (val) {
                                  indicadoropcao.configselecionado = condicional;
                                }
                              });
                              print(condicional);
                            }),
                      );
                    }).toList()),
                  ),
                  Card(child: Column(children: camposParametro())),
                  RaisedButton(
                      child: Text("Salvar Parametros"),
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (_formKey.currentState.validate()) {
                          form.save();
                          print("novovalor:${indicadoropcao.parametro}");
                          Navigator.of(context).pop();
                        }
                      })
                ],
              ),
            )),
      ),
    );
  }
}
