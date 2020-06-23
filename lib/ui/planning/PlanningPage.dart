import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:foodwithfriends/bloc/PlanningBloc.dart';
import 'package:foodwithfriends/model/Date.dart';

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
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/herbs.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )
            ),
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
    List<Widget> coming = new List();
    List<Widget> past = new List();

    for(Date date in dates){
      Widget listElement = InkWell(
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
                    child: Text(
                        "Match mit ${date.users.length} Personen ""${date.datetime != null ? "am ${new DateFormat("dd.MM.yyyy").format(date.datetime)} um ${new DateFormat("HH:mm").format(date.datetime)} Uhr" : ""}",
                        style: TextStyle(
                            color: Colors.black
                        )
                    ),
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
      );

      if(date.datetime == null || date.datetime.isAfter(DateTime.now())) {
        coming.add(listElement);
      }else{
        past.add(listElement);
      }
    }

    return [
      ListTileTheme(
        contentPadding: EdgeInsets.only(left: 0, right: MediaQuery.of(context).size.width / 1.6),
        child: ExpansionTile(
          title: Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              elevation: 10,
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(5),
                child: Center(
                  child: Text("Anstehend",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )
                ),
              )
          ),
          children: coming,
          initiallyExpanded: true,
        ),
      ),
      ListTileTheme(
        contentPadding: EdgeInsets.only(left: 0, right: MediaQuery.of(context).size.width / 1.6),
        child: ExpansionTile(
          title: Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              elevation: 10,
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(5),
                child: Center(
                    child: Text("Vergangen",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                ),
              )
          ),
          children: past,
          initiallyExpanded: false,
        ),
      ),
    ];
  }

}
