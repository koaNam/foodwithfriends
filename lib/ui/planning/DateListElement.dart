import 'dart:core';

import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/PlanningBloc.dart';
import 'package:tinder_cards/model/Date.dart';
import 'package:tinder_cards/ui/planning/DateWrapper.dart';

class DateListElement extends StatelessWidget{

  final int userId;

  final PlanningBloc _planningBloc=new PlanningBloc();

  DateListElement({this.userId}){
    this._planningBloc.loadDates(userId);
  }

  @override
  Widget build(BuildContext context) {
   return StreamBuilder(
     stream: _planningBloc.dateListStream,
     builder: (_, AsyncSnapshot<List<Date>> data) {
       if (data.connectionState == ConnectionState.active) {
         List<Date> dates=data.data;
         return Container(
           height: MediaQuery.of(context).size.height,
           child: ListView(
             children: this._buildDates(context, dates),
           ),
         );
       }else{
         return CircularProgressIndicator();
       }
     },
   );
  }

  List<Widget> _buildDates(BuildContext context, List<Date> dates){
    List<Widget> result=new List();

    for(Date date in dates){
      result.add(
        InkWell(
          child: Text(date.id.toString()),
          onTap: ()=> Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (BuildContext context){
                    return DateWrapper(this.userId, date.id);
                  }
              )
          ),
        )
      );
    }

    return result;
  }
}

