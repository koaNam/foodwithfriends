
import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/DateBloc.dart';
import 'package:tinder_cards/model/Date.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/model/Voter.dart';
import 'package:tinder_cards/ui/planning/date/FloationActionButtonRow.dart';


class DatePage extends StatelessWidget{

  final int dateId;
  final int userId;

  final DateBloc _dateBloc=new DateBloc();

  DatePage({this.dateId, this.userId}){
    this._dateBloc.loadDate(dateId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: this._dateBloc.dateStream,
        builder: (_, AsyncSnapshot<Date> data) {
          if (data.connectionState == ConnectionState.active) {
            Date date=data.data;
            return Scaffold(
                appBar: AppBar(title: Text(""), centerTitle: true,),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Container(
                  height: 110,
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButtonRow(userId: this.userId, dataId: this.dateId)
                ),
                body: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: this.buildProfilePictures(date.users, context),
                    ),
                    Expanded(
                      child: ListView(
                        children: date.votes.map((v) =>
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(v.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                                  Text(v.description),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        child: ((v.voters.where((vo) => vo.user.id == this.userId).isEmpty) ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up, color: Colors.grey,)),
                                        onTap: () => this._dateBloc.vote(this.dateId, v.id, this.userId, "yes", v.voters.where((vo) => vo.user.id == this.userId).isEmpty),
                                      ),
                                      Padding(
                                        child: Text(this.getUpvotes(v.voters).toString()),
                                        padding: EdgeInsets.only(right:  MediaQuery.of(context).size.width  / 2.5),
                                      ),
                                      Padding(
                                        child: InkWell(
                                          child: ((v.voters.where((vo) => vo.user.id == this.userId).isEmpty) ? Icon(Icons.thumb_down) : Icon(Icons.thumb_down, color: Colors.grey,)),
                                          onTap: () => this._dateBloc.vote(this.dateId, v.id, this.userId, "no", v.voters.where((vo) => vo.user.id == this.userId).isEmpty),
                                        ),
                                        padding: EdgeInsets.only(left:  MediaQuery.of(context).size.width  / 2.5),
                                      ),
                                      Text(this.getDownvotes(v.voters).toString()),
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ).toList()
                        )
                    )
                  ]
                 ),
                );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }

  List<Widget> buildProfilePictures(List<User> users, BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double placePerPic= width / users.length;

    List<Widget> pictures=new List();
    for(int i=0; i < users.length; i++){
      User user=users[i];
      pictures.add( Padding(
        child: CircleAvatar(
          backgroundImage: NetworkImage(user.profilePicture),
          radius: MediaQuery
              .of(context)
              .size
              .width / 10,
        ),
        padding: EdgeInsets.only(left:  placePerPic * i),
      ));
    }

    return pictures;
  }

  int getUpvotes(List<Voter> voters){
    int count=0;
    for (Voter voter in voters) {
       if (voter.vote == "yes") {
        count++;
       }
    }
    return count;
  }

  int getDownvotes(List<Voter> voters){
    int count=0;
    for(Voter voter in voters){
      if(voter.vote == "no"){
        count++;
      }
    }
    return count;
  }

}