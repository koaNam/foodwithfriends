import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/ui/MainPageWrapper.dart';

import 'model/User.dart';

class Home extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    ProfileBloc profileBloc=new ProfileBloc();

    return StreamBuilder(
      stream: profileBloc.profileStream,
      builder: (_, AsyncSnapshot<User> snapshot) {
        if(snapshot.connectionState != ConnectionState.active){
          return Scaffold(
            body: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onSubmitted: (String value){
                     profileBloc.username = value;
                    },
                  ),
                ),
                RaisedButton(
                  child: Text("login"),
                  onPressed: () => profileBloc.login(profileBloc.username),
                )
              ],
            ),
          );
        } else {
          User user=snapshot.data;
          return MainPageWrapper(user.id);
          //return MainPageWrapper(1);
        }
      }
    );
  }

}