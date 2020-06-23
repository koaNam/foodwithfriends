import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:foodwithfriends/AppTheme.dart';
import 'package:foodwithfriends/bloc/DateBloc.dart';
import 'package:foodwithfriends/model/Date.dart';
import 'package:foodwithfriends/model/DateVote.dart';
import 'package:foodwithfriends/model/TextVote.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/ui/planning/date/vote/VoteWidget.dart';
import 'dart:math' as math;


import 'vote/AddVotePageWrapper.dart';

class DatePage extends StatefulWidget{

  final int dateId;
  final int userId;

  final DateBloc _dateBloc=new DateBloc();

  DatePage({this.dateId, this.userId}){
    this._dateBloc.loadDate(this.dateId);
  }

  @override
  State<StatefulWidget> createState() {
    return new DatePageState(this.dateId, this.userId, this._dateBloc);
  }

}

class DatePageState extends State<DatePage> with SingleTickerProviderStateMixin{

  final int dateId;
  final int userId;

  final DateBloc dateBloc;

  AnimationController _controller;
  Animation _animation;

  DatePageState(this.dateId, this.userId, this.dateBloc);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInCubic)
      ..addListener((){
        setState(() {
        });
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: this.dateBloc.dateStream,
        builder: (_, AsyncSnapshot<Date> data) {
          Widget body;
          if (data.connectionState == ConnectionState.active) {
            Date date=data.data;
            body = Container(
                color: Colors.grey.shade100,
                child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: this.buildUserCircle(date.users, context),
                          ),
                          padding: EdgeInsets.only(bottom: 5, top: 5),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: date.votes.isNotEmpty ? this.buildVotes(date, context): this.buildDefault(),
                          ),
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
                                return AddVotePageWrapper(userId: this.userId, dateId: this.dateId, dateBloc: this.dateBloc,);
                              }
                          )
                      )
              ),
              body: body
          );

        }
    );
  }

  Widget buildDefault(){
    return Center(
      child: Text("Trau dich! \n"+
        "Sei der Erste, der einen Vorschlag für euer Treffen erstellt",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15
        ),
      ),
    );
  }

  Widget buildVotes(Date date, BuildContext context) {
    return ListView(
      children: date.votes.whereType<TextVote>().map((v) =>
          VoteWidget(
            child: Container(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 1.3,
                  child: Text(v.description,
                      style: TextStyle(
                        fontWeight: v.result == "accepted" ? FontWeight.bold : FontWeight.normal,
                        color: v.result == "declined" ? Color.fromRGBO(170, 175, 180, 100) :  v.result == "accepted" ? Colors.black : Colors.black.withOpacity(0.7),
                        fontSize: 16,
                      )
                  ),
                )
            ),
            userId: this.userId,
            vote: v,
            onVoteUp: () =>
                this.dateBloc.vote(
                    this.dateId, v.id, this.userId, "yes", v.voters
                    .where((vo) => (vo.user.id == this.userId))
                    .isEmpty),
            onVoteDown: () =>
                this.dateBloc.vote(
                    this.dateId, v.id, this.userId, "no", v.voters
                    .where((vo) => (vo.user.id == this.userId))
                    .isEmpty),
          )
      ).toList()
        ..addAll(
            date.votes.whereType<DateVote>().map((v) =>
                VoteWidget(
                  userId: this.userId,
                  vote: v,
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 1.3,
                    child: Text(
                        "Hi Leute, was halted ihr von diesem Termin: ${DateFormat(
                            "dd.MM.yyyy HH:mm").format(v.datetime)}",
                        style: TextStyle(
                            fontWeight: v.result == "accepted"
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: v.result == "declined" ? Color.fromRGBO(
                                170, 175, 180, 100) : Colors.black,
                            fontSize: 16
                        )
                    ),
                  ),
                  onVoteUp: () =>
                      this.dateBloc.vote(
                          this.dateId, v.id, this.userId, "yes", v.voters
                          .where((vo) => (vo.user.id == this.userId))
                          .isEmpty),
                  onVoteDown: () =>
                      this.dateBloc.vote(
                          this.dateId, v.id, this.userId, "no", v.voters
                          .where((vo) => (vo.user.id == this.userId))
                          .isEmpty),
                )
            )
        ),
    );
  }

  List<Widget> buildUserCircle(List<User> users, BuildContext context){
    List<Widget> widgets = buildTable(context);
    widgets.addAll(this.buildPictures(context, users));

    return widgets;
  }

  List<Widget> buildPictures(BuildContext context, List<User> users) {
    List<Widget> pictures=new List();

    double pictureRadius = MediaQuery.of(context).size.width / 13;

    Size size = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * ((1 / 5)));

    Path path = Path();
    path.addOval(Rect.fromCircle(center: Offset(size.width / 2 - pictureRadius, size.height / 2 + pictureRadius / 2), radius: (MediaQuery.of(context).size.height / 8) / 2 + pictureRadius));
    path.close();

    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);

    for(int i = 0; i< users.length; i++) {
      double value = (pathMetric.length / users.length) * i  * _animation.value;
      Tangent pos = pathMetric.getTangentForOffset(value);
      Offset offset = pos.position;

      pictures.add(
          Positioned(
            left: offset.dx,
            top: offset.dy,
            child: CircleAvatar(
              backgroundImage: NetworkImage(users[i].profilePicture),
              radius: pictureRadius,
            ),
          )
      );
    }

    return pictures;
  }

  List<Widget> buildTable(BuildContext context) {
    List<Widget> circles=new List();

    Widget outerCircle = this.buildCircle((MediaQuery.of(context).size.height / 4) / 2, AppTheme.MAIN_COLOR, 7.0);
    Widget innerCircle = this.buildCircle((MediaQuery.of(context).size.height / 8) / 2, Color(0xFF29292B), 0);
    circles.add(outerCircle);
    circles.add(innerCircle);

    return circles;
  }

  Widget buildCircle(double radius, Color color, double elevation){
    return PhysicalShape(
      color: color,
      elevation: elevation,
      clipper: TabClipper(radius: radius),
      child: Center(
        child: SizedBox.shrink(),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {

  double radius;

  TabClipper({this.radius});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: this.radius));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    var radian = (math.pi / 180) * degree;
    return radian;
  }
}



