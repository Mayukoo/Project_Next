import 'package:flutter/material.dart';
import 'package:moneymanagement/TransactionsProvider.dart';
import 'package:provider/provider.dart';
import './screen/launcher.dart';

void main() => runApp(MyApp());

// ส่วนของ Stateless widget
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context){
          return TransactionProvider();
        })

      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.pink,
          accentColor: Colors.purple,
          textTheme: TextTheme(body1: TextStyle(color: Colors.red)),
        ),
        title: 'First Flutter App',
        initialRoute: '/', // สามารถใช้ home แทนได้
        routes: {
          Launcher.routeName: (context) => Launcher(),
        },
      ),
    );
  }
}