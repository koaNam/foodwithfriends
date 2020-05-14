import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinder_cards/bloc/PlanningBloc.dart';
import 'package:tinder_cards/model/Date.dart';

import 'DateWrapper.dart';

class PlanningPage extends StatelessWidget {

  final int userId;

  final PlanningBloc _planningBloc=new PlanningBloc();

  PlanningPage({this.userId}){
    this._planningBloc.loadDates(userId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _planningBloc.dateListStream,
      builder: (_, AsyncSnapshot<List<Date>> data) {
        Widget body;
        if (data.connectionState == ConnectionState.active) {
          List<Date> dates=data.data;
          body= Container(
            margin: EdgeInsets.only(top: 3),
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: this._buildDates(context, dates),
            ),
          );
        }else{
          body = Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(
                "Matches",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: body
        );
      },
    );
  }

  List<Widget> _buildDates(BuildContext context, List<Date> dates){
    List<Widget> result=new List();

    for(Date date in dates){
      result.add(
          InkWell(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              elevation: 10,
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height / 10,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: date.users.take(4).map((e) => Image.network(e.profilePicture,  fit: BoxFit.cover)).toList(),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Match mit ${date.users.length} Personen "
                            "${date.datetime != null ? "am ${new DateFormat("dd.MM.yyyy").format(date.datetime)} um ${new DateFormat("HH:mm").format(date.datetime)} Uhr" : ""}"),
                      ),
                    )
                  ],
                ),
              ),
            ),
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
