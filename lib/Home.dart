import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/service/social/FacebookService.dart';
import 'package:tinder_cards/service/social/GoogleService.dart';
import 'package:tinder_cards/ui/MainPageWrapper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tinder_cards/ui/profile/ProfileDetailPage.dart';

import 'model/User.dart';

class Home extends StatelessWidget {
  final ProfileBloc profileBloc = new ProfileBloc();

  @override
  Widget build(BuildContext context) {
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
                  child: Center(
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
                  ),
                )
            );
          } else {
            User user = snapshot.data;
            return MainPageWrapper(user.id);
          }
        }
      );
  }

  Future facebookLogin() async {
    this.profileBloc.loginSocial(FacebookService());
  }

  Future googleLogin() async {
    this.profileBloc.loginSocial(GoogleService());
  }
}
