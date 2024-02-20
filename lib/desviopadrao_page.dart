

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scouting/desviopadrao_estatistica.dart';
import 'package:scouting/models/todo.dart';



class DesvioPadraoPage extends StatefulWidget {

  DesvioPadraoPage({
    @required this.stockname,
    @required this.stocks,

  });


  final String stockname;
  final List<Stock> stocks;

  @override
  _DesvioPadraoPageState createState() => _DesvioPadraoPageState(stockname: stockname,stocks: stocks);
}

class _DesvioPadraoPageState extends State<DesvioPadraoPage> {

   String stockname;
   List<Stock> stocks;
   bool variacao = false;
   final _formKey = GlobalKey<FormState>();
   final TextEditingController desviocustomizado = new TextEditingController();
   final TextEditingController periodocustomizado = new TextEditingController();


  _DesvioPadraoPageState({
    @required this.stockname,
    @required this.stocks,
  });


 @override
  void initState() {
    super.initState();
  }



_buildPageChart(BuildContext context, List<Stock> candles){
      

        return _buildForm(context,candles);

}


_buildForm(context,candles){

  return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Desvio Padrao Customizado",style: TextStyle(fontSize: 25,color: Colors.white),),
              Container(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: desviocustomizado,
                      decoration: const InputDecoration(
                        hintText: 'Desvio',
                        fillColor: Colors.white, filled: true
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
              Container(
                
                child: TextFormField(
                  controller: periodocustomizado,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Periodo',
                    fillColor: Colors.white, filled: true
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),

              Container(
                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Colors.black,Colors.black],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                child: FlatButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => DesvioEstatisticaPage(desvio:int.parse(desviocustomizado.text),periodo: int.parse(periodocustomizado.text),stocks: candles,stockname:stockname),
                                      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                      transitionDuration: Duration(milliseconds: 400),
                                    ),
                                  );  

                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Analisar',style: TextStyle(color: Colors.white),),
                    ),
                  ),
              )
              
            ],
          ),
        ),
      );
}
 


  @override
  Widget build(BuildContext context) {

    return _buildPageChart(context,stocks);
  }
}


