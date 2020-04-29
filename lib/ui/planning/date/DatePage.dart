import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/DateBloc.dart';
import 'package:tinder_cards/model/Date.dart';
import 'package:tinder_cards/model/TextVote.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/model/Voter.dart';

import 'AddVotePageWrapper.dart';


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
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  title: Text(""),
                  centerTitle: true,
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton(
                  heroTag: "AddProperty",
                  child: Container(
                    child: Icon(Icons.add),
                  ),
                  onPressed: () =>
                      Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (BuildContext context){
                                return AddVotePageWrapper(userId: this.userId, dateId: this.dateId);
                              }
                          )
                      )
                ),
                body: Container(
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
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(color: Colors.grey, width: 1),
                                          top: BorderSide(color: Colors.grey, width: 1),
                                        ),
                                      ),
                                      padding: EdgeInsets.only(bottom: 10, top: 5),
                                      margin: EdgeInsets.only(left: 5, right: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(v.title, style: TextStyle(fontWeight:  v.result == "accepted" ? FontWeight.bold: FontWeight.normal, fontSize: 22, color: v.result == "declined" ? Color.fromRGBO(170, 175, 180, 100): Colors.black)),
                                          Text(v.description, style: TextStyle(fontWeight:  v.result == "accepted" ? FontWeight.bold: FontWeight.normal, color: v.result == "declined" ? Color.fromRGBO(170, 175, 180, 100): Colors.black)),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  child: ((v.voters.where((vo) => vo.user.id == this.userId && vo.vote == "yes").isEmpty) ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up, color: Colors.blue,)),
                                                  onTap: () => this._dateBloc.vote(this.dateId, v.id, this.userId, "yes", v.voters.where((vo) => (vo.user.id == this.userId && vo.vote == "yes")).isEmpty),
                                                ),
                                                Padding(
                                                  child: Text(this.getUpvotes(v.voters).toString()),
                                                  padding: EdgeInsets.only(right:  MediaQuery.of(context).size.width  / 2.6),
                                                ),
                                                Padding(
                                                  child: InkWell(
                                                    child: ((v.voters.where((vo) => vo.user.id == this.userId && vo.vote == "no").isEmpty) ? Icon(Icons.thumb_down) : Icon(Icons.thumb_down, color: Colors.blue,)),
                                                    onTap: () => this._dateBloc.vote(this.dateId, v.id, this.userId, "no", v.voters.where((vo) => (vo.user.id == this.userId && vo.vote == "no")).isEmpty),
                                                  ),
                                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width  / 2.5),),
                                                Text(this.getDownvotes(v.voters).toString()),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                ).toList()
                            )
                        )
                      ]
                  ),
                )
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