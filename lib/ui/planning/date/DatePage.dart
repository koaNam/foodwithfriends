import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinder_cards/bloc/DateBloc.dart';
import 'package:tinder_cards/model/Date.dart';
import 'package:tinder_cards/model/DateVote.dart';
import 'package:tinder_cards/model/TextVote.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/model/Voter.dart';
import 'package:tinder_cards/ui/planning/date/vote/VoteWidget.dart';

import 'vote/AddVotePageWrapper.dart';


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
          Widget body;
          if (data.connectionState == ConnectionState.active) {
            Date date=data.data;
            body = Container(
                  color: Colors.grey.shade100,
                  child: Column(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: this.buildProfilePictures(date.users, context),
                          ),
                          padding: EdgeInsets.only(bottom: 5, top: 5),
                        ),
                        Expanded(
                            child: ListView(
                                children: date.votes.whereType<TextVote>().map((v) =>
                                    VoteWidget(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(v.title, style: TextStyle(fontWeight:  v.result == "accepted" ? FontWeight.bold: FontWeight.normal, fontSize: 22, color: v.result == "declined" ? Color.fromRGBO(170, 175, 180, 100): Colors.black)),
                                            Text(v.description, style: TextStyle(fontWeight:  v.result == "accepted" ? FontWeight.bold: FontWeight.normal, color: v.result == "declined" ? Color.fromRGBO(170, 175, 180, 100): Colors.black)),
                                          ],
                                        ),
                                      ),
                                      userId: this.userId,
                                      vote: v,
                                      onVoteUp: () => this._dateBloc.vote(this.dateId, v.id, this.userId, "yes", v.voters.where((vo) => (vo.user.id == this.userId && vo.vote == "yes")).isEmpty),
                                      onVoteDown: () => this._dateBloc.vote(this.dateId, v.id, this.userId, "no", v.voters.where((vo) => (vo.user.id == this.userId && vo.vote == "no")).isEmpty),
                                    )
                                ).toList()
                                ..addAll(
                                    date.votes.whereType<DateVote>().map((v) =>
                                        VoteWidget(
                                          userId: this.userId,
                                          vote: v,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Termin", style: TextStyle(fontWeight:  v.result == "accepted" ? FontWeight.bold: FontWeight.normal, fontSize: 22, color: v.result == "declined" ? Color.fromRGBO(170, 175, 180, 100): Colors.black)),
                                              Text("Am ${new DateFormat("dd.MM.yyyy").format(v.datetime)} um ${new DateFormat("HH:mm").format(v.datetime)} Uhr", style: TextStyle(fontWeight:  v.result == "accepted" ? FontWeight.bold: FontWeight.normal, color: v.result == "declined" ? Color.fromRGBO(170, 175, 180, 100): Colors.black)),
                                            ],
                                          ),
                                          onVoteUp: () => this._dateBloc.vote(this.dateId, v.id, this.userId, "yes", v.voters.where((vo) => (vo.user.id == this.userId && vo.vote == "yes")).isEmpty),
                                          onVoteDown: () => this._dateBloc.vote(this.dateId, v.id, this.userId, "no", v.voters.where((vo) => (vo.user.id == this.userId && vo.vote == "no")).isEmpty),
                                        )
                                    )
                                ),
                            )
                        )
                      ]
                  )
            );
          } else {
            body = Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerFloat,
              floatingActionButton: FloatingActionButton(
                  child: Container(
                    child: Icon(Icons.add),
                  ),
                  onPressed: () =>
                      Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                                return AddVotePageWrapper(userId: this.userId, dateId: this.dateId);
                              }
                          )
                      )
              ),
              body: body
          );

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