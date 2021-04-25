

import 'dart:io';

import 'package:moneymanagement/globals.dart';
import 'package:moneymanagement/models/moneymanagementModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TransactionDB{


  String DBname;

  TransactionDB({this.DBname});
  String totalamount;

  Future <Database> openDB() async{

    Directory appDiretory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDiretory.path,DBname);

    DatabaseFactory dbFactory = await databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);


    return db;

  }

Future<int>  InsertData(MoneyModels transaction) async{
    var db = await this.openDB();
    var store = intMapStoreFactory.store("expense");

    var keyId = store.add(db, {
      "type":transaction.type,
      "amount":transaction.amount,
      "date":transaction.dateTime
    });
    db.close();
    return keyId;

  }

  Future<List<MoneyModels>> loadAllData() async{

   var db = await this.openDB();
   var store = intMapStoreFactory.store("expense");
   List transactionList = List<MoneyModels>();
   var snapshot = await store.find(db,finder: Finder(sortOrders: [SortOrder(Field.key,false)]));

   for(var record in snapshot){

     transactionList.add(
         MoneyModels(type: record['type'],
         amount: record['amount'],
         dateTime:  record['date'])
         );

   }
   return transactionList;
  }






}