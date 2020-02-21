import 'package:flutter/material.dart';

class DatePage extends StatelessWidget{

  final int dateId;
  final int userId;

  DatePage({this.dateId, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Votes"), centerTitle: true,),
      body: Stack(
        children: <Widget>[
          Padding(
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://www.thepeakid.com/wp-content/uploads/2016/03/default-profile-picture.jpg"),
              radius: MediaQuery
                  .of(context)
                  .size
                  .width / 10,
            ),
            padding: EdgeInsets.only(left: 0),
          ),
          Padding(
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://www.thepeakid.com/wp-content/uploads/2016/03/default-profile-picture.jpg"),
              radius: MediaQuery
                  .of(context)
                  .size
                  .width / 10,
            ),
            padding: EdgeInsets.only(left:  MediaQuery.of(context).size.width  -  MediaQuery.of(context).size.width  / 10 *2),
          )
        ],
      )

    );
  }

}