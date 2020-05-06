import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/bloc/PropertyBloc.dart';
import 'package:tinder_cards/model/Property.dart';
import 'package:tinder_cards/model/User.dart';

class AddPropertyPage extends StatelessWidget {

  final int userId;
  final PropertyBloc propertyBloc = new PropertyBloc();
  final ProfileBloc profileBloc;

  AddPropertyPage({this.userId, this.profileBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context,
                    delegate: SearchPropertyDelegate(this.propertyBloc, this.profileBloc, this.userId));
              },
            )
          ],
        ),
        body: StreamBuilder(
            stream: this.profileBloc.profileStream,
            builder: (_, AsyncSnapshot<User> data) {
              if (data.connectionState == ConnectionState.active) {
                List<Property> properties=data.data.userProperties;
                return Center(
                    child: ListView.builder(
                        itemCount: properties.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PropertyBox(
                            property: properties[index],
                            heightMulti: 13,
                          );
                        }
                    )
                );
              } else {
                return Center(
                    child: CircularProgressIndicator()
                );
              }
            }
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
                child: PropertyBox(
                  property: e,
                  heightMulti: 15,
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

class PropertyBox extends StatelessWidget{

  final Property property;
  final int heightMulti;

  PropertyBox({this.property, this.heightMulti});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 25),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / this.heightMulti,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1)
          )
      ),
      child: Text(this.property.name),
    );
  }

}