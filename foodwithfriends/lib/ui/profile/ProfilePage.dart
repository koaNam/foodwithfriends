import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodwithfriends/AppTheme.dart';
import 'package:foodwithfriends/bloc/ProfileBloc.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/ui/profile/AddPropertyPage.dart';
import 'package:foodwithfriends/ui/profile/CameraPage.dart';
import 'package:foodwithfriends/ui/profile/ProfileDetailPage.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;


class ProfilePage extends StatefulWidget {

  final int userId;
  final ProfileBloc profileBloc;

  ProfilePage({this.userId, this.profileBloc});

  @override
  State<ProfilePage> createState() {
    return new ProfilePageState(this.userId, this.profileBloc);
  }

}

class ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin{

  final int userId;
  final ProfileBloc _profileBloc;// = new ProfileBloc();
  AnimationController rotationController;


  bool editMode = false;

  ProfilePageState(this.userId, this._profileBloc);

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
                  PhysicalShape(
                    color: Colors.white,
                    elevation: 7.0,
                    clipper: TabClipper(),
                    child: Center(
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
                                backgroundColor: AppTheme.MAIN_COLOR,
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
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.1
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
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10, right: 10),
                                        child: FaIcon(
                                          AppTheme.ICONS[e.colour],
                                          color: AppTheme.MAIN_COLOR,
                                          size: 18,
                                        ),
                                      ),
                                      Text(e.name, style: TextStyle(color: Colors.grey.shade700)),
                                    ],
                                  ),
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
                            Vibration.vibrate(duration: 50, amplitude: 32);

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
                    settings: RouteSettings(
                      name: "/login"
                    ),
                    builder: (BuildContext context) {
                      return ProfileDetailPage(this.userId, this._profileBloc);
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

class TabClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(-size.width, -size.height * 3.5);
    path.arcToPoint(Offset(size.width * 2, 0), radius: Radius.circular(10), clockwise: false);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    var radian = (math.pi / 180) * degree;
    return radian;
  }
}