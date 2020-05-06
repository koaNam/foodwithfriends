import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/ui/profile/AddPropertyPage.dart';
import 'package:tinder_cards/ui/profile/CameraPage.dart';
import 'package:tinder_cards/ui/profile/ProfileDetailPage.dart';
import 'package:vibrate/vibrate.dart';

class ProfilePage extends StatefulWidget {

  final int userId;

  ProfilePage({this.userId});

  @override
  State<ProfilePage> createState() {
    return new ProfilePageState(this.userId);
  }

}

class ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin{

  final int userId;
  final ProfileBloc _profileBloc = new ProfileBloc();
  AnimationController rotationController;


  bool editMode = false;

  ProfilePageState(this.userId);

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(duration: const Duration(milliseconds: 50), vsync: this);
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
                      child: Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.025
                        ),
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
                              backgroundColor: Color(0xFF3a5fb6),
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
                        ),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.03
                    ),
                    child: Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 5,
                    crossAxisCount: 2,
                    children: user.userProperties.map((e) =>
                        GestureDetector(
                          child: RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.01).animate(rotationController),
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
                          ),
                          onLongPress: () {
                            this.setState(() {
                              editMode = true;
                            });
                            Vibrate.feedback(FeedbackType.medium);
                            TickerFuture tickerFuture = this.rotationController.repeat(reverse: true);
                            tickerFuture.timeout(Duration(milliseconds: 200), onTimeout:  () {
                              this.rotationController.forward(from: 0);
                              this.rotationController.stop(canceled: true);
                            });
                          }

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
          body = Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return ProfileDetailPage();
                    }
                  )
                ),
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                )
              )
            ],
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