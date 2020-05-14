import 'package:flutter/material.dart';
import 'package:tinder_cards/model/Vote.dart';
import 'package:tinder_cards/model/Voter.dart';

class VoteWidget extends StatelessWidget{

  final Vote vote;
  final Widget child;
  final int userId;
  final Function onVoteUp;
  final Function onVoteDown;


  VoteWidget({this.vote, this.child, this.userId, this.onVoteUp, this.onVoteDown});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1),
          top: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      padding: EdgeInsets.only(bottom: 10, top: 5),
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 5),
            child: CircleAvatar(
              backgroundImage: NetworkImage(this.vote.sourceUser.profilePicture),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(this.vote.sourceUser.name,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16
                ),
              ),
              child,
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: ((this.vote.voters.where((vo) => vo.user.id == this.userId && vo.vote == "yes").isEmpty) ? Icon(Icons.thumb_up) : Icon(Icons.thumb_up, color: Color(0xFF3a5fb6),)),
                      onTap: this.onVoteUp,
                    ),
                    Padding(
                      child: Text(this.getUpvotes(this.vote.voters).toString()),
                      padding: EdgeInsets.only(right:  MediaQuery.of(context).size.width  / 3.8),
                    ),
                    Padding(
                      child: InkWell(
                        child: ((this.vote.voters.where((vo) => vo.user.id == this.userId && vo.vote == "no").isEmpty) ? Icon(Icons.thumb_down) : Icon(Icons.thumb_down, color: Color(0xFF3a5fb6),)),
                        onTap: this.onVoteDown,
                      ),
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width  / 2.5),
                    ),
                    Text(this.getDownvotes(this.vote.voters).toString()),
                  ],
                ),
              )
            ],
          ),
        ],
      )
    );
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