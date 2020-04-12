import 'package:rxdart/rxdart.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/service/CameraService.dart';
import 'package:tinder_cards/service/ProfileService.dart';
import 'package:location/location.dart';

import 'dart:developer' as developer;

import 'package:tinder_cards/service/PropertyService.dart';

class ProfileBloc{

  static const String LOG="bloc.ProfileBloc";

  BehaviorSubject<User> _profileController = BehaviorSubject<User>();
  Observable<User> get profileStream =>_profileController.stream;

  ProfileService _profileService;
  PropertyService _propertyService;
  CameraService _cameraService;

  String username;

  ProfileBloc(){
    _profileService=new ProfileService();
    _propertyService = new PropertyService();
    _cameraService = new CameraService();
  }

  Future<void> login(String username) async{
    Location location = new Location();
    LocationData currentLocation = await location.getLocation();

    developer.log("trying to log in user", name: LOG);
    User user=await this._profileService.findUserByName(username);
    if(user == null){
      developer.log("user not found, creating it", name: LOG);
      user=await this._profileService.insertUser(User(0, username, "https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg", null));
    }
    this._profileService.updateLocation(user, currentLocation);

    this._profileController.add(user);
  }

  Future<void> loadProfile(int id) async {
    developer.log("finding user by id", name: LOG);
    User user=await this._profileService.findUserById(id);
    this._profileController.add(user);
  }

  Future<void> deleteProperty(int userId, int propertyId)async{
    await this._propertyService.deleteUserProperty(userId, propertyId);
    User user=await this._profileService.findUserById(userId);
    this._profileController.add(user);
  }

  Future<void> addProperty(int userId, int propertyId) async{
    developer.log("adding property to user", name: LOG);
    await this._propertyService.addUserProperty(userId, propertyId);

    User user=await this._profileService.findUserById(userId);
    this._profileController.add(user);
  }

  Future<void> changeProfilePicture(int userId, String name, String base64String) async{
    developer.log("changing profile  picture", name: LOG);

    this._profileService.updateProfilePicture(userId, name);
    await this._cameraService.addProfilePicture(name, base64String);

    User user=await this._profileService.findUserById(userId);
    this._profileController.add(user);
  }

  void dispose() {
   this._profileController.close();
  }

}