import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/PropertyBloc.dart';
import 'package:tinder_cards/model/Property.dart';

class AddPropertyPage extends StatelessWidget{

  final int userId;
  final PropertyBloc _propertyBloc=new PropertyBloc();

  AddPropertyPage({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchPropertyDelegate(this._propertyBloc, this.userId));
            },
          )
        ],
      ),
      body: Text(this.userId.toString()),
    );
  }
}

class SearchPropertyDelegate extends SearchDelegate{

  final PropertyBloc _propertyBloc;
  final int userId;

  SearchPropertyDelegate(this._propertyBloc, this.userId);

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
                  this._propertyBloc.addProperty(this.userId, e.id);
                  Navigator.of(context).pop();
                },
              )
          ).toList(),
        );
      },
    );

  }

}