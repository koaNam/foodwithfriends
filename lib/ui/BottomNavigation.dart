import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget{

  final Function(int) onWidgetChange;

  BottomNavigation({this.onWidgetChange});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: (e) =>onWidgetChange(e),
        currentIndex: 0,
        selectedFontSize: 10,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Colors.blue,),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Colors.blue,),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue,),
            title: Text(""),
          )
        ]
    );
  }

}