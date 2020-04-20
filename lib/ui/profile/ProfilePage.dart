import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/ui/profile/AddPropertyPage.dart';
import 'package:tinder_cards/ui/profile/CameraPage.dart';

class ProfilePage extends StatefulWidget {

  final int userId;

  ProfilePage({this.userId});

  @override
  State<ProfilePage> createState() {
    return new ProfilePageState(this.userId);
  }

}

class ProfilePageState extends State<ProfilePage> {

  final int userId;
  final ProfileBloc _profileBloc = new ProfileBloc();

  bool editMode = false;

  ProfilePageState(this.userId) {
    this._profileBloc.loadProfile(this.userId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._profileBloc.profileStream,
      builder: (_, AsyncSnapshot<User> data) {
        Widget body;
        if (data.connectionState == ConnectionState.active) {
          User user = data.data;
          body = GestureDetector(
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: <Widget>[
                  Center(
                      heightFactor: 1.5,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePicture),
                            radius: MediaQuery
                                .of(context)
                                .size
                                .width / 4,
                          ),
                          FloatingActionButton(
                            heroTag: "Camera",
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.edit),
                            onPressed: () =>
                                Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                          return CameraPage(
                                              this.userId, this._profileBloc);
                                        }
                                    )
                                ),
                          )
                        ],
                      )
                  ),
                  RatingBar(
                    initialRating: 3,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) =>
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 5,
                    crossAxisCount: 2,
                    children: user.userProperties.map((e) =>
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.075),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(3, 3),
                                      blurRadius: 3,
                                      spreadRadius: -3
                                  ),
                                ]
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Center(child: Text(e.name,
                                    style: TextStyle(color: Colors.grey.shade700))),
                                this.editMode ? Positioned(
                                    right: MediaQuery.of(context).size.width * -0.018,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close, color:  Colors.grey.shade400),
                                      onPressed: () =>
                                          this._profileBloc.deleteProperty(userId, e.id),
                                    )
                                ) : SizedBox.shrink()
                              ],
                            ),
                          ),
                          onLongPress: () =>
                          {
                            this.setState(() {
                              editMode = true;
                            })
                          },
                        )).toList(),
                  ),
                ],
              ),
            ),
            onTap: () =>
            {
              this.setState(() {
                editMode = false;
              })
            },
          );
        } else {
          body = CircularProgressIndicator();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: body,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton:Padding(
              padding: EdgeInsets.only(bottom: 50),
              child:  FloatingActionButton(
                heroTag: "AddProperty",
                child: Container(
                  child: Icon(Icons.add),
                ),
                onPressed: () =>
                    Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return AddPropertyPage(userId: this.userId,
                                profileBloc: this._profileBloc,);
                            }
                        )
                    ),
              ),
            )
        );
      },
    );
  }

}