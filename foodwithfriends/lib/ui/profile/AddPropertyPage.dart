import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodwithfriends/bloc/ProfileBloc.dart';
import 'package:foodwithfriends/bloc/PropertyBloc.dart';
import 'package:foodwithfriends/model/Property.dart';
import 'package:foodwithfriends/ui/profile/PropertyElement.dart';

class AddPropertyPage extends StatelessWidget {

  final int userId;
  final PropertyBloc _propertyBloc = new PropertyBloc();
  final ProfileBloc profileBloc;

  AddPropertyPage({this.userId, this.profileBloc}){
    this._propertyBloc.findRandomProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Das könnte zu dir passen",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context,
                    delegate: SearchPropertyDelegate(this._propertyBloc, this.profileBloc, this.userId));
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: this._propertyBloc.propertyStream,
          builder: (_, AsyncSnapshot<List<Property>> data) {
            List<Property> props = new List();
            if (data.connectionState == ConnectionState.active) {
              props = data.data;
            }
            return Container(
              color: Colors.grey.shade100,
              child: Column(
                children: props.map((e) =>
                    InkWell(
                      child: PropertyElement(
                        property: e,
                      ),
                      onTap: () {
                        this.profileBloc.addProperty(this.userId, e.id);
                        Navigator.of(context).pop();
                      },
                    )
                ).toList(),
              ),
            );
          },
        )
    );
  }

}

class SearchPropertyDelegate extends SearchDelegate {

  final PropertyBloc _propertyBloc;
  final ProfileBloc _profileBloc;
  final int userId;

  SearchPropertyDelegate(this._propertyBloc, this._profileBloc, this.userId);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          this.query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return this.buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length > 0) {
      this._propertyBloc.findProperty("${this.query}%");
    }

    return StreamBuilder(
      stream: this._propertyBloc.propertyStream,
      builder: (_, AsyncSnapshot<List<Property>> data) {
        List<Property> props = new List();
        if (data.connectionState == ConnectionState.active) {
          props = data.data;
        }
        return Column(
          children: props.map((e) =>
              InkWell(
                child: PropertyElement(
                  property: e,
                ),
                onTap: () {
                  this._profileBloc.addProperty(this.userId, e.id);
                  Navigator.of(context).pop();
                },
              )
          ).toList(),
        );
      },
    );
  }
}
