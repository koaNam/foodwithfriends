import 'package:flutter/material.dart';
import 'package:tinder_cards/ui/planning/PlanningPage.dart';
import 'package:tinder_cards/ui/profile/ProfilePage.dart';
import 'package:tinder_cards/ui/matching//SwipeFeedPage.dart';
import 'BottomNavigation.dart';

class MainPageWrapper extends StatefulWidget{

  final int userId;

  MainPageWrapper(this.userId);

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
    widgets[2]=ProfilePage(userId: widget.userId);

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