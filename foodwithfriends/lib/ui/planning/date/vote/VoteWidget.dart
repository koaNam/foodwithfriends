import 'package:flutter/material.dart';
import 'package:foodwithfriends/model/Vote.dart';
import 'package:foodwithfriends/model/Voter.dart';

import 'VotePicker.dart';

class VoteWidget extends StatelessWidget {

  final Vote vote;
  final Widget child;
  final int userId;
  final Function onVoteUp;
  final Function onVoteDown;


  VoteWidget(
      {this.vote, this.child, this.userId, this.onVoteUp, this.onVoteDown});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        padding: EdgeInsets.only(bottom: 10, top: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5, right: 8),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        this.vote.sourceUser.profilePicture),
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
                    Container(
                      child: child,
                      width: MediaQuery.of(context).size.width / 1.35,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height / 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width / 10,
                  child: VotePicker(
                    height: MediaQuery.of(context).size.height / 7,
                    width: MediaQuery.of(context).size.width / 10,
                    count: this.getUpvotes(this.vote.voters) - this.getDownvotes(this.vote.voters),
                    isUpvote: this.vote.voters.where((vo) => vo.user.id == this.userId && vo.vote == "yes").isNotEmpty,
                    isDownvote: this.vote.voters.where((vo) => vo.user.id == this.userId && vo.vote == "no").isNotEmpty,
                    onVoteUp: this.onVoteUp,
                    onVoteDown: this.onVoteDown,
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  int getUpvotes(List<Voter> voters) {
    int count = 0;
    for (Voter voter in voters) {
      if (voter.vote == "yes") {
        count++;
      }
    }
    return count;
  }

  int getDownvotes(List<Voter> voters) {
    int count = 0;
    for (Voter voter in voters) {
      if (voter.vote == "no") {
        count++;
      }
    }
    return count;
  }

}