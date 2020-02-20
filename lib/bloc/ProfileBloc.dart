import 'package:rxdart/rxdart.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/service/ProfileService.dart';
import 'package:location/location.dart';

import 'dart:developer' as developer;

class ProfileBloc{

  static const String LOG="bloc.ProfileBloc";

  BehaviorSubject<User> _profileController = BehaviorSubject<User>();
  Observable<User> get profileStream =>_profileController.stream;

  ProfileService _profileService;

  String username;

  ProfileBloc(){
    _profileService=new ProfileService();
  }

  Future<void> login(String username) async{
    Location location = new Location();
    LocationData currentLocation = await location.getLocation();

    developer.log("trying to log in user", name: LOG);
    User user=await this._profileService.findUserByName(username);
    if(user == null){
      developer.log("user not found, creating it", name: LOG);
      user=await this._profileService.insertUser(User(0, username, null, null));
    }
    this._profileService.updateLocation(user, currentLocation);

    this._profileController.add(user);
  }

  Future<void> loadProfile(int id) async {
    developer.log("finding user by id", name: LOG);
    User user=await this._profileService.findUserById(id);
    this._profileController.add(user);
  }

  void dispose() {
   this._profileController.close();
  }

}