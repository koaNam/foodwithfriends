import 'package:flutter/material.dart';
import 'package:tinder_cards/ui/planning/date/AddVotePage.dart';

class FloatingActionButtonRow extends StatefulWidget {

  int userId;
  int dataId;

  FloatingActionButtonRow({this.userId, this.dataId});

  @override
  State<StatefulWidget> createState() {
    return new _FloatingActionButtonRowState();
  }
}

class _FloatingActionButtonRowState extends State<FloatingActionButtonRow>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _buttonAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });

    _buttonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0, 0.75, curve: Curves.easeOut),
    );
  }

  Widget addVoteButton() {
    return Transform(
      transform: Matrix4.translationValues(
          _buttonAnimation.value * 45, _buttonAnimation.value * -45, 0),
      child: Container(
        margin: EdgeInsets.only(top: 55, left: 180, right: 180),
        height: 55,
        child: RawMaterialButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (BuildContext context){
                      return AddVotePage(userId: widget.userId, dateId: widget.dataId,);
                    }
                )
            );
          },
          child: Center(
            child: Icon(
              Icons.thumbs_up_down,
              color: Colors.blue,
              size: 35.0,
            ),
          ),
          shape: new CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget addSuggestionButton() {
    return SizedBox(
      child: Transform(
          transform: Matrix4.translationValues(
              _buttonAnimation.value * -45, _buttonAnimation.value * -45, 0),
          child: Container(
            margin: EdgeInsets.only(top: 55, left: 180, right: 180),
            height: 55,
            width: 55,
            child: RawMaterialButton(
              onPressed: () {
                print("test");
              },
              child: Icon(
                Icons.pause,
                color: Colors.blue,
                size: 35.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Stack(
        children: <Widget>[
          addVoteButton(),
          addSuggestionButton(),
          Container(
            height: 52,
            width: 52,
            margin: EdgeInsets.only(bottom: 45, left: 135, top: 11),
          ),
          Container(
              margin: EdgeInsets.only(top: 55, left: 180, right: 180),
              height: 55,
              width: 55,
              child: RawMaterialButton(
                onPressed: () {
                  if (this._isExpanded) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                  this._isExpanded = !this._isExpanded;
                },
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.blue,
                    size: 35.0,
                  ),
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
              ))
        ],
      ),
    );
  }
}
