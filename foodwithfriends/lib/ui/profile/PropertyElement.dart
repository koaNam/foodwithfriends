import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodwithfriends/AppTheme.dart';
import 'package:foodwithfriends/model/Property.dart';

class PropertyElement extends StatelessWidget{

  final Property property;

  PropertyElement({this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 25),
      height: MediaQuery.of(context).size.height / 15,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1)
        ),
        color: Colors.white,
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: FaIcon(
              AppTheme.ICONS[this.property.colour],
              color: AppTheme.MAIN_COLOR,
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(this.property.name,
                style: TextStyle(
                    color: Colors.black
                )
            ),
          )
        ],
      )
    );
  }

}