import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:foodwithfriends/bloc/ProfileBloc.dart';
import 'package:foodwithfriends/service/social/FacebookService.dart';
import 'package:foodwithfriends/service/social/GoogleService.dart';
import 'package:foodwithfriends/ui/MainPageWrapper.dart';

import 'model/User.dart';

class Home extends StatelessWidget {

  Future<void> fileFuture;
  final ProfileBloc profileBloc = new ProfileBloc();

  Home(){
    this.fileFuture = this.profileBloc.loginFromFile();
  }

  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
        future: this.fileFuture,
        builder: (context, AsyncSnapshot data){
          Widget child;
          if(data.connectionState == ConnectionState.done){
            child = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FacebookSignInButton(
                      onPressed: this.facebookLogin,
                      text: "Weiter mit Facebook",
                    ),
                    GoogleSignInButton(
                      onPressed: this.googleLogin,
                      text: "Anmelden mit Google",
                    ),
                  ],
                )
            );
          }else{
            child = SizedBox.expand();
          }

          return StreamBuilder(
              stream: profileBloc.profileStream,
              builder: (_, AsyncSnapshot<User> snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return Scaffold(
                      backgroundColor: Colors.white,
                      body: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/start_screen.png'),
                                fit: BoxFit.cover
                            )
                        ),
                        child: child
                      )
                  );
                } else {
                  User user = snapshot.data;
                  return MainPageWrapper(user.id);
                }
              }
          );
        },
      );
  }

  Future facebookLogin() async {
    this.profileBloc.loginSocial(FacebookService());
  }

  Future googleLogin() async {
    this.profileBloc.loginSocial(GoogleService());
  }
}
