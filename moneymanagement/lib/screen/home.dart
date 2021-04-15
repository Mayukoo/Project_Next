import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanagement/models/moneymanagementModel.dart';
import 'package:provider/provider.dart';
import '../TransactionsProvider.dart';
import '../globals.dart' as globals;
import '../title.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';





  @override
  State<StatefulWidget> createState() {

    return _HomeState();
  }
}


class _HomeState extends State<Home> {
  var amount = 0;

  void initState(){
    Provider.of<TransactionProvider>(context,listen: false).initData();
    amount = int.parse(calculateAmount());
  }

  final _headerText = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title.appName),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            setState(() {
              amount = int.parse(calculateAmount());
            });
          })
        ],),
        body:

        Column(
          children: <Widget>[
            Text(
              "",
              style: new TextStyle(
                fontSize: 70.0,
                color: Colors.yellow,
              ),
            ),
            Text(
              title.totalamount,
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
           Text(amount.toString(),style: new TextStyle(fontSize: 25,color: Colors.black),)
            ,
           Consumer(
             builder: (context,TransactionProvider provider,Widget child){

               return
               Expanded(child:ListView.builder(
                 itemCount: provider.transactions.length,
                 itemBuilder: (context,int position){
                   MoneyModels data = provider.transactions[position];
                   return Card(
                     elevation: 5,
                     margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                     child: ListTile(
                       leading: ConstrainedBox(
                         constraints: BoxConstraints(
                           minHeight: 50,
                           minWidth: 50,
                           maxHeight: 300,
                           maxWidth: 300
                         ),

                         child:
                             Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children:<Widget> [

                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: <Widget>[
                                   Text(data.type, textAlign: TextAlign.center,style: _headerText,),
                                   Text(data.amount.toString(),textAlign: TextAlign.center,style: new TextStyle(fontSize: 20,color: Colors.black),),

                                 ],), Text(data.dateTime.toString(),textAlign: TextAlign.center,style: new TextStyle(fontSize: 15,color: Colors.black),)

                             ],),


                       ),

                     ),


                   );

                 },
               ));


             }),

          ],
        ),
    );
  }


  String calculateAmount(){
    int income = 0;
    int expense = 0;
    int total = 0;

    for(var record in Provider.of<TransactionProvider>(context,listen: false).loadAll()){

      if(record.type == "Income"){
        income = income.toInt() + record.amount.toInt();
      }else if (record.type == "Expense"){
        expense = expense.toInt() + record.amount.toInt();
      }
    }
    total = income - expense;
    globals.amount = total;

    return total.toString();
  }



}