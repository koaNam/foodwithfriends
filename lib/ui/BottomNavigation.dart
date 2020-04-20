import 'package:flutter/material.dart';
import 'dart:math' as math;

class BottomNavigation extends StatelessWidget {
  final Function(int) onWidgetChange;

  BottomNavigation({this.onWidgetChange});

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
        color: Colors.white,
        elevation: 16.0,
        clipper: TabClipper(radius: 38.0),
        child: Column(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TabIcon(
                  onWidgetChange: onWidgetChange,
                  index: 0,
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                  ),
                ),
                TabIcon(
                  onWidgetChange: onWidgetChange,
                  index: 1,
                  icon: Icon(
                    Icons.bookmark,
                    color: Colors.blue,
                  ),
                ),
                TabIcon(
                  onWidgetChange: onWidgetChange,
                  index: 2,
                  icon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),
              ],
            )
          )
        ]
      )
    );
  }
}

class TabIcon extends StatelessWidget {
  final Icon icon;
  final Function onWidgetChange;
  final int index;

  TabIcon({this.icon, this.onWidgetChange, this.index});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => onWidgetChange(index),
        child: Container(
          width: 50,
          height: 50,
          child: this.icon,
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  final double radius;

  TabClipper({this.radius = 38.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    final v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);

    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
