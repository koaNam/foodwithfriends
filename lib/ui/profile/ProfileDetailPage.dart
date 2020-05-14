import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/bloc/ProfileSettingsBloc.dart';
import 'package:tinder_cards/model/User.dart';

class ProfileDetailPage extends StatelessWidget {

  final int userId;
  final ProfileSettingsBloc profileSettingsBloc = new ProfileSettingsBloc();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  ProfileDetailPage(this.userId){
    this.profileSettingsBloc.loadProfileSettings(this.userId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this.profileSettingsBloc.profileStream,
      builder: (_, AsyncSnapshot<User> data){
        Widget body;
        if(data.connectionState == ConnectionState.active){
          User user = data.data;
          body = Container(
              child: ListView(
                children: <Widget>[
                  Card(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                        child: TextField(
                          minLines: 1,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18
                          ),
                          controller: _nameController..text = user.name,
                          onChanged: (n) => user.name = n

                        )
                      )
                  ),
                  Card(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                        child: TextField(
                          minLines: 1,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 18
                          ),
                          controller: _dateController..text = user.birthDate != null ? new DateFormat("dd.MM.yyyy").format(user.birthDate) : "",
                          onChanged: (n) {
                            if(RegExp("^\\s*(3[01]|[12][0-9]|0?[1-9])\\.(1[012]|0?[1-9])\\.((?:19|20)\\d{2})\\s*").hasMatch(n)){
                              user.birthDate = DateFormat("dd.MM.yyyy").parse(n);
                            }
                          }
                        )
                      )
                  ),
                  Card(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Altersgruppe",
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                                Text(
                                  "${user.birthDate != null ? (DateTime.now().difference(user.birthDate).inDays ~/ 365 - user.ageMinOffset) < getMinAge(user.birthDate) ? getMinAge(user.birthDate) : (DateTime.now().difference(user.birthDate).inDays ~/ 365 - user.ageMinOffset) : 0} - "
                                      "${user.birthDate != null ? (DateTime.now().difference(user.birthDate).inDays ~/ 365 + user.ageMaxOffset) > getMaxAge(user.birthDate) ? getMaxAge(user.birthDate) : (DateTime.now().difference(user.birthDate).inDays ~/ 365 + user.ageMaxOffset): 0}",
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                              ],
                            )
                          ),
                          RangeSlider(
                            values: RangeValues(
                              user.birthDate != null ? (DateTime.now().difference(user.birthDate).inDays ~/ 365 - user.ageMinOffset).toDouble() < getMinAge(user.birthDate) ? getMinAge(user.birthDate) : (DateTime.now().difference(user.birthDate).inDays ~/ 365 - user.ageMinOffset).toDouble() : 0,
                              user.birthDate != null ? (DateTime.now().difference(user.birthDate).inDays ~/ 365 + user.ageMaxOffset).toDouble() > getMaxAge(user.birthDate) ? getMaxAge(user.birthDate) : (DateTime.now().difference(user.birthDate).inDays ~/ 365 + user.ageMaxOffset).toDouble() : 0,
                            ),
                            onChanged: (v) {
                              if(user.birthDate != null){
                                int age = DateTime.now().difference(user.birthDate).inDays ~/ 365;
                                print(age);
                                double newMin = v.start >= 18 ? age - v.start : age - 18;
                                double newMax = v.end - age ;
                                this.profileSettingsBloc.ageMinOffset = age - newMin > age ? 0: newMin;
                                this.profileSettingsBloc.ageMaxOffset = age + newMax < age ? 0: newMax;
                              }
                            },
                            min: getMinAge(user.birthDate),
                            max: getMaxAge(user.birthDate),
                          )
                        ],
                      )
                  ),
                  Card(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Küche vorhanden",
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                            Switch(
                              value: user.hasKitchen,
                              onChanged: (v) => this.profileSettingsBloc.hasKitchen = v,
                            )
                          ],
                        ),
                      )
                  ),
                  Card(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 15),
                            child: Text(
                              "Deine Kochkünste",
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                          ),
                          Center(
                            child: RatingBar(
                              initialRating: user.cookingSkill,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 35,
                                  right: MediaQuery.of(context).size.width / 35,
                                  bottom: 15
                              ),
                              itemBuilder: (context, _) =>
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                              onRatingUpdate: (rating) {
                                this.profileSettingsBloc.cookingSkill = rating;
                              },
                            ),
                          )
                        ],
                      )
                  ),
                  Card(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Abweichung",
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                                Text(
                                  "${user.cookingSkill - user.skillMinOffset < 0 ? 0: user.cookingSkill - user.skillMinOffset} - ${user.cookingSkill + user.skillMaxOffset > 5 ? 5: user.cookingSkill + user.skillMaxOffset}",
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                              ],
                            )
                          ),
                          RangeSlider(
                            values: RangeValues(
                                user.cookingSkill - user.skillMinOffset < 0 ? 0: user.cookingSkill - user.skillMinOffset,
                                user.cookingSkill + user.skillMaxOffset > 5 ? 5: user.cookingSkill + user.skillMaxOffset
                            ),
                            onChanged: (v) {
                              double newMin = user.cookingSkill - v.start;
                              double newMax = v.end - user.cookingSkill ;
                              this.profileSettingsBloc.skillMinOffset = user.cookingSkill - newMin > user.cookingSkill ? 0: newMin;
                              this.profileSettingsBloc.skillMaxOffset = user.cookingSkill + newMax < user.cookingSkill ? 0: newMax;
                            },
                            min: 0,
                            max: 5,
                          )
                        ],
                      )
                  ),
                  Card(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Anzahl der Teilnehmer:",
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                                Text(
                                  "${user.maxUsers}",
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                              ],
                            )
                          ),
                          Slider.adaptive(
                            value: user.maxUsers.toDouble(),
                            onChanged: (v) => this.profileSettingsBloc.maxUsers = v,
                            min: 3,
                            max: 10,
                          ),
                        ],
                      )
                  ),
                ],
              )
          );
        }else{
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
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () async {
                  this.profileSettingsBloc.updateProfileSettings();
                  Navigator.pop(context);
                },
              ),
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
            ),
            body: body
        );
      }
    );
  }

  double getMinAge(DateTime birthDate){
    if(birthDate != null){
      return (DateTime.now().difference(birthDate).inDays ~/ 365 - 5).toDouble() >=  18 ? (DateTime.now().difference(birthDate).inDays ~/ 365 - 5).toDouble(): 18;
    }
    return 0;
  }

  double getMaxAge(DateTime birthDate){
    if(birthDate != null){
      return (DateTime.now().difference(birthDate).inDays ~/ 365 + 5).toDouble();
    }
    return 0;
  }

}
