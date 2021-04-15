import 'package:flutter/foundation.dart';
import 'package:moneymanagement/db/moneymanage_db.dart';
import 'package:moneymanagement/models/moneymanagementModel.dart';
import 'globals.dart' as globals;

class TransactionProvider with ChangeNotifier{


  List<MoneyModels> transactions = [];
  List<MoneyModels> dataList = [];


  List<MoneyModels> getTransaction(){
    return transactions;
  }

  void initData() async{
    var db = TransactionDB(DBname:"transactions.db");
    transactions = await db.loadAllData();

    if(dataList.isNotEmpty){
      dataList.clear();
    }
    dataList = transactions;

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

  List<MoneyModels> loadAll() {

    return dataList;
  }
  List<MoneyModels> loadIncome() {

    List<MoneyModels> incomelist = [];;

    for(var record in dataList){
      if(record.type == "Income"){
        incomelist.add(record);
      }
    }

    return incomelist;
  }
  List<MoneyModels> loadExpanse() {

    List<MoneyModels> expanselist = [];;

    for(var record in dataList){
      if(record.type == "Expense"){
        expanselist.add(record);
      }
    }

    return expanselist;
  }
  List<MoneyModels> loadOther() {
    List<MoneyModels> otherlist = [];;

    for(var record in dataList){
      if(record.type == "Other"){
        otherlist.add(record);
      }
    }

    return otherlist;
  }
}