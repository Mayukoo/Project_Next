import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymanagement/models/moneymanagementModel.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import '../TransactionsProvider.dart';
import '../globals.dart' as globals;
import '../title.dart';

class Report extends StatefulWidget {
  static const routeName = '/report';


  @override
  State<StatefulWidget> createState() {

    return _ReportState();
  }
}


class _ReportState extends State<Report> {
  List<String> dropDown = ["Income", "Expense", "Other"];
  String _selectedLocation; // Option 2
  List<MoneyModels> dataList = [];
  var resultTotal = 0.0;
  Map<String, double> dataMap;
  List<MoneyModels> incomeList = [];
  List<MoneyModels> expanseList = [];
  List<MoneyModels> otherList = [];


  void initState() {
    dataList = Provider.of<TransactionProvider>(context, listen: false).loadAll();
    resultTotal = double.parse(calculateData());
    incomeList = Provider.of<TransactionProvider>(context, listen: false).loadIncome();
    expanseList = Provider.of<TransactionProvider>(context, listen: false).loadExpanse();
    otherList = Provider.of<TransactionProvider>(context, listen: false).loadOther();

   dataMap = Map.fromIterables(dropDown,calculateList());

  }

  List<double> calculateList(){

    var mapData = <double>[];
    var incomeTotal = 0.0;
    var expenseTotal = 0.0;
    var otherTotal = 0.0;
    for(var data in incomeList){
      incomeTotal = incomeTotal+data.amount;
    }
    for(var data in expanseList){
      expenseTotal = expenseTotal+data.amount;
    }
    for(var data in otherList){
      otherTotal = otherTotal+data.amount;
    }
    mapData.add(incomeTotal);
    mapData.add(expenseTotal);
    mapData.add(otherTotal);


    return mapData;
  }


  final _headerText = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.appName),
      ),
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
            title.report,
            style: new TextStyle(
              fontSize: 30.0,
              color: Colors.black,
            ),
          ),
          Text(
            "",
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: "",
            legendOptions: LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
          DropdownButton(
            hint: Text('Select Type'), // Not necessary for Option 1
            value: _selectedLocation,
            onChanged: (newValue) {
              setState(() {
                _selectedLocation = newValue;
                switch(_selectedLocation){
                  case "Income" :{
                    dataList = Provider.of<TransactionProvider>(context, listen: false).loadIncome();
                  }
                  break;
                  case "Expense" :{
                dataList = Provider.of<TransactionProvider>(context, listen: false).loadExpanse();
                }
                break;
                  case "Other" :{
                    dataList = Provider.of<TransactionProvider>(context, listen: false).loadOther();
                  }
                  break;
                }

              });
              calculateData();
            },
            items: dropDown.map((type) {
              return DropdownMenuItem(
                child: new Text(type),
                value: type,
              );
            }).toList(),
          ),
          Text(resultTotal.toString(),style: new TextStyle(fontSize: 25,color: Colors.black),)
          ,
      Expanded(child: ListView.builder(
        itemCount: dataList.length,
                    itemBuilder: (context, int position) {
                      MoneyModels data = dataList[position];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 5),
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
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  children: <Widget>[
                                    Text(data.type, textAlign: TextAlign.center,
                                      style: _headerText,),
                                    Text(data.amount.toString(),
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontSize: 20, color: Colors.black),),

                                  ],),
                                Text(data.dateTime.toString(),
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      fontSize: 15, color: Colors.black),)

                              ],),


                          ),

                        ),


                      );
                    },
                  )),


        ],
      ),
    );
  }

  String calculateData(){
    resultTotal = 0.0;
    for(var data in dataList){

      resultTotal = resultTotal+data.amount;
    }

    return resultTotal.toString();
  }
  void loadData() {
    Provider.of<TransactionProvider>(context, listen: false).calculateAmount();
  }

}
