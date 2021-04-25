import 'package:flutter/foundation.dart';
import 'package:moneymanagement/db/moneymanage_db.dart';
import 'package:moneymanagement/models/moneymanagementModel.dart';
import 'globals.dart' as globals;

class TransactionProvider with ChangeNotifier{


  List<MoneyModels> transactions = [];


  List<MoneyModels> getTransaction(){
    return transactions;
  }

  void initData() async{
    var db = TransactionDB(DBname:"transactions.db");
    transactions = await db.loadAllData();

    notifyListeners();
    calculateAmount();

  }

  void addTransaction(MoneyModels statement) async{
    var db = TransactionDB(DBname:"transactions.db");
    await db.InsertData(statement);
    await db.loadAllData();

    notifyListeners();
    calculateAmount();
  }

  String calculateAmount(){

    int income = 0;
    int expense = 0;
    int total = 0;

    for(var record in transactions){

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