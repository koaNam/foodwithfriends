import 'package:flutter/material.dart';
import 'package:tinder_cards/ui/planning/DateWrapper.dart';

class DateListElement extends StatelessWidget{

  final int dateId;
  final int userId;

  DateListElement({this.dateId, this.userId});


  @override
  Widget build(BuildContext context) {
   return InkWell(
       child: Text(this.dateId.toString()),
        onTap: ()=> Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (BuildContext context){
                  //return DatePage(userId: this.userId, dateId: this.dateId);
                  return DateWrapper();
                }
            )
        ),
   );
  }
}