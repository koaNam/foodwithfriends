import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/bloc/PropertyBloc.dart';
import 'package:tinder_cards/model/Property.dart';

class AddPropertyPage extends StatelessWidget{

  final int userId;
  final PropertyBloc propertyBloc=new PropertyBloc();
  final ProfileBloc profileBloc;

  AddPropertyPage({this.userId, this.profileBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchPropertyDelegate(this.propertyBloc, this.profileBloc, this.userId));
            },
          )
        ],
      ),
      body: Text(""),
    );
  }
}

class SearchPropertyDelegate extends SearchDelegate{

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
    if(this.query.length > 0) {
      this._propertyBloc.findProperty("${this.query}%");
    }

    return StreamBuilder(
      stream: this._propertyBloc.propertyStream,
      builder: (_, AsyncSnapshot<List<Property>> data){
        List<Property> props=new List();
        if(data.connectionState == ConnectionState.active){
          props=data.data;
        }
        return Column(
          children: props.map((e) =>
              RaisedButton(
                child: Text(e.name),
                onPressed: () {
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