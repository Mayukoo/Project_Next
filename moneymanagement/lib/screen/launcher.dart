import 'package:flutter/material.dart';
import 'package:moneymanagement/screen/addData.dart';
import 'package:moneymanagement/screen/home.dart';
import 'package:moneymanagement/screen/report.dart';



class Launcher extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  List<Widget> _pageWidget = <Widget>[
    Home(),
    addData(),
    Report(),
    Home(),
    Home(),
  ];
  List<BottomNavigationBarItem> _menuBar
  = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      title: Text('AddData'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.report),
      title: Text('Report'),
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.school),
    //   title: Text('Profile'),
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme
            .of(context)
            .primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}