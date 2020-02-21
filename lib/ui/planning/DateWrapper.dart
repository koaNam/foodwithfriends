import 'package:flutter/cupertino.dart';
import 'package:tinder_cards/ui/planning/chat/ChatPage.dart';
import 'package:tinder_cards/ui/planning/date/DatePage.dart';

class DateWrapper extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return DateWrapperState();
  }
}

class DateWrapperState extends State<DateWrapper>{

  int index=0;

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        DatePage(),
        ChatPage()
      ],
    );
  }

}

