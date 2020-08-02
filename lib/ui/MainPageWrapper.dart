import 'package:flutter/material.dart';
import 'package:foodwithfriends/bloc/ProfileBloc.dart';
import 'package:foodwithfriends/ui/planning/PlanningPage.dart';
import 'package:foodwithfriends/ui/profile/ProfilePage.dart';
import 'package:foodwithfriends/ui/matching//SwipeFeedPage.dart';
import 'BottomNavigation.dart';

class MainPageWrapper extends StatefulWidget{

  final int userId;
  final ProfileBloc _profileBloc;

  MainPageWrapper(this.userId, this._profileBloc);

  @override
  State<StatefulWidget> createState() {
    return MainPageWrapperState();
  }
}

class MainPageWrapperState extends State<MainPageWrapper> {
  final Map<int, Widget> widgets=Map();

  int currentIndex=2;

  onWidgetChange(index){
    if(index >= 0 && index < widgets.length) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widgets[0]=SwipeFeedPage(userId: widget.userId);
    widgets[1]=PlanningPage(userId: widget.userId,);
    widgets[2]=ProfilePage(userId: widget.userId, profileBloc: widget._profileBloc);

    return Stack(
        children: <Widget>[
          widgets[currentIndex],
          bottomBar()
        ],
      );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        BottomNavigation(
          onWidgetChange: this.onWidgetChange,
          activePage: this.currentIndex,
        ),
      ],
    );
  }

}