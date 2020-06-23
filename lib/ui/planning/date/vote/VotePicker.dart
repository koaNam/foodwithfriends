import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodwithfriends/AppTheme.dart';

class VotePicker extends StatefulWidget{

  final double height;
  final double width;
  final int count;

  final bool isUpvote;
  final bool isDownvote;

  final Function onVoteUp;
  final Function onVoteDown;

  VotePicker({this.height, this.width, this.count, this.onVoteUp, this.onVoteDown, this.isUpvote = false, this.isDownvote = false});


  @override
  State<StatefulWidget> createState() {
    return new VotePickerState(this.height, this.width, this.count, this.isUpvote, this.isDownvote);
  }
}

class VotePickerState extends State<VotePicker>{

  double height;
  double width;

  bool isUpvote;
  bool isDownvote;

  int count;

  int direction;

  VotePickerState(this.height, this.width, this.count, this.isUpvote, this.isDownvote);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              height: this.height / 3,
              width: this.width,
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () => _switchUp(),
                  icon: Icon(Icons.keyboard_arrow_up, size: this.height / 3, color: this.isUpvote ? AppTheme.MAIN_COLOR: Colors.black.withOpacity(0.7))
              )
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Container(
                key: ValueKey(this.count),
                padding: EdgeInsets.all(0),
                height: this.height / 3,
                width: this.width,
                child: Center(
                  child: Text(this.count.toString(),
                    style: TextStyle(
                        fontSize: this.height / 4,
                        color: Colors.grey
                    ),
                  ),
                )
            ),
            transitionBuilder: (Widget child, Animation<double> animation) {
              ValueKey key = child.key;

              int direction;
              if(key.value == this.count) {
                if(this.direction == 0){
                  direction = 1;
                }else{
                  direction = -1;
                }
              } else {
                if(this.direction == 0){
                  direction = -1;
                }else{
                  direction = 1;
                }
              }

              return SlideTransition(
                child: child,
                position: Tween<Offset>(
                  begin: Offset(0, 1.3 * direction),
                  end: Offset.zero,
                ).animate(animation),
              );
            },
          ),
          Container(
              height: this.height / 3,
              width: this.width,
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () => _switchDown(),
                  icon: Icon(Icons.keyboard_arrow_down, size: this.height / 3, color: this.isDownvote ? AppTheme.MAIN_COLOR:  Colors.black.withOpacity(0.7))
              )
          ),
        ],
      ),
    );
  }

  _switchUp(){
    if(!this.isUpvote) {
      this.setState(() {
        isUpvote = !this.isDownvote;  // falls es zuvor ein downvote war, wird es wieder auf "neutral" gesetzt
        this.isDownvote = false;
        direction = 0;
        count++;
      });
      widget.onVoteUp();
    }
  }

  _switchDown(){
    if(!this.isDownvote) {
      this.setState(() {
        isDownvote = !this.isUpvote; // falls es zuvor ein upvote war, wird es wieder auf "neutral" gesetzt
        this.isUpvote = false;
        direction = 1;
        count--;
      });
      widget.onVoteDown();
    }
  }
}
