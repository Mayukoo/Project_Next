import 'package:flutter/material.dart';
import 'package:moneymanagement/TransactionsProvider.dart';
import 'package:moneymanagement/main.dart';
import 'package:moneymanagement/models/moneymanagementModel.dart';
import 'package:moneymanagement/screen/home.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';



class addData extends StatefulWidget {
  static const routeName = '/addData';

  @override
  State<StatefulWidget> createState() {
    return _addData();
  }
}

class _addData extends State<addData> {

  List<String> dropDown = ["Income", "Expense", "Other"];
  String _selectedLocation; // Option 2
  final amountController = TextEditingController();


  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Form(
        key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton(
                hint: Text('Select Type'), // Not necessary for Option 1
                value: _selectedLocation,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
                items: dropDown.map((type) {
                  return DropdownMenuItem(
                    child: new Text(type),
                    value: type,
                  );
                }).toList(),
              ),
            TextFormField(controller:amountController,decoration: new InputDecoration(labelText: "Amount"),validator: (String str){
              if(str.isEmpty){

                return "No amount data";
              }
              if(double.parse(str) < 0){
                return "Please enter only Number in amout.";
              }
            },),
              TextButton(onPressed: (){
                if(formKey.currentState.validate()){
                  var amountdata = amountController.text;
                  DateTime now = DateTime.now();
                  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);


                  MoneyModels transaction = MoneyModels(
                    type: _selectedLocation,
                    amount: double.parse(amountdata),
                    dateTime: formattedDate
                  );

                  TransactionProvider provider = Provider.of<TransactionProvider>(context,listen:false);
                  provider.addTransaction(transaction);


                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Add Data."),
                  ));
                  Navigator.push(context, MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context){
                    return MyApp();
                  }));

                }else{
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Error."),
                  ));
                }


              }, child: Text("Add Data"))
            ],
          )
      ),
    );
  }
}