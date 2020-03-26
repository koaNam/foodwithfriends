import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/ui/profile/AddPropertyPage.dart';
import 'package:tinder_cards/ui/profile/CameraPage.dart';

class ProfilePage extends StatefulWidget{

  final int userId;

  ProfilePage({this.userId});

  @override
  State<ProfilePage> createState() {
    return new ProfilePageState(this.userId);
  }

}

class ProfilePageState extends State<ProfilePage>{

  final int userId;
  final ProfileBloc _profileBloc=new ProfileBloc();

  bool editMode = false;

  ProfilePageState(this.userId){
    this._profileBloc.loadProfile(this.userId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._profileBloc.profileStream,
      builder: (_, AsyncSnapshot<User> data){
        if(data.connectionState == ConnectionState.active) {
          User user=data.data;
          return Scaffold(
              appBar: AppBar(title: Text("Profile"), centerTitle: true,),
              body: GestureDetector(
                  child: Container(
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
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.edit),
                                  onPressed: () =>Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context){
                                            return CameraPage();
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
                          itemBuilder: (context, _) => Icon(
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
                          children: user.userProperties.map((e) =>  GestureDetector(
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius:  BorderRadius.all(Radius.circular(20.0)),
                                color: Colors.blue,
                              ),
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  Center(child: Text(e.name, style: TextStyle(color: Colors.white))),
                                  this.editMode ? Positioned(
                                      bottom: -12,
                                      right: -8,
                                      child: IconButton(
                                        icon: Icon(Icons.close, color: Colors.white,),
                                        onPressed: () => this._profileBloc.deleteProperty(userId, e.id),
                                      )
                                  ): SizedBox.shrink()
                                ],
                              ),
                            ),
                            onLongPress: () => {
                              this.setState(() {
                                editMode = true;
                              })
                            },
                          )).toList(),
                        ),
                        Container(
                            height: 40,
                            margin: EdgeInsets.only(bottom: 80),
                            child:RaisedButton(
                              child: Text("Add Property"),
                              onPressed: () =>Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context){
                                        return AddPropertyPage(userId: this.userId,);
                                      }
                                  )
                              ),
                            ))
                      ],
                    ),
                    color: Colors.white,
                  ),
                  onTap: () => {
                    this.setState(() {
                      editMode = false;
                    })
                  },
              )
          );
        }else{
          return CircularProgressIndicator();
        }
      },
    );
  }

}