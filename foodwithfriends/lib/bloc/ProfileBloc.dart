import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/service/CameraService.dart';
import 'package:foodwithfriends/service/ProfileService.dart';
import 'package:foodwithfriends/service/PropertyService.dart';
import 'package:foodwithfriends/service/social/SocialService.dart';

import 'package:location/location.dart';
import 'dart:developer' as developer;

class ProfileBloc{

  static const String LOG="bloc.ProfileBloc";

  BehaviorSubject<User> _profileController = BehaviorSubject<User>();
  Observable<User> get profileStream =>_profileController.stream;

  ProfileService _profileService;
  PropertyService _propertyService;
  CameraService _cameraService;

  ProfileBloc(){
    _profileService=new ProfileService();
    _propertyService = new PropertyService();
    _cameraService = new CameraService();
  }

  Future<void> loginSocial(SocialService service) async{
    LocationData currentLocation = await this._getLocation();
    FlutterSecureStorage storage = new FlutterSecureStorage();

    developer.log("trying to log in user", name: LOG);

    await service.loadData();

    storage.write(key: "id", value: service.id);
    storage.write(key: "serviceIdentifier", value: service.getIdentifier());

    User user = await this._profileService.findUserByOauth(service.id, service.getIdentifier());

    if(user == null){
      developer.log("user not found, creating it", name: LOG);
      user=await this._profileService.insertUser(User(0, service.name, "https://foodwithfriends.s3.eu-central-1.amazonaws.com/default.jpg", service.id, service.getIdentifier(), null));  //TODO URL codieren
    }
    if(currentLocation != null) {
      this._profileService.updateLocation(user, currentLocation);
    }
    this._profileController.add(user);
  }

  Future<void> loginFromFile() async{
    FlutterSecureStorage storage = new FlutterSecureStorage();

    developer.log("trying to read login data from file", name: LOG);

    String id = await storage.read(key: "id");
    String serviceName = await storage.read(key: "serviceIdentifier");

    if(id != null && serviceName != null) {
      developer.log("found credentials in file", name: LOG);

      LocationData currentLocation = await this._getLocation();
      User user = await this._profileService.findUserByOauth(id, serviceName);
      if(currentLocation != null) {
        this._profileService.updateLocation(user, currentLocation);
      }
      this._profileController.add(user);
    }
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
    developer.log("changing profile picture", name: LOG);

    this._profileService.updateProfilePicture(userId, name);
    await this._cameraService.addProfilePicture(name, base64String);

    User user=await this._profileService.findUserById(userId);
    this._profileController.add(user);
  }

  Future<LocationData> _getLocation() async{
    Location location = new Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    bool  permissionGranted = await location.hasPermission();
    if (!permissionGranted) {
      permissionGranted = await location.requestPermission();
      if (!permissionGranted ) {
        return null;
      }
    }

    LocationData currentLocation = await location.getLocation();
    return currentLocation;
  }

  void logout(){
    FlutterSecureStorage storage = new FlutterSecureStorage();

    storage.delete(key: "id");
    storage.delete(key: "serviceIdentifier");
    this._profileController.addError(null);
  }

  void dispose() {
   this._profileController.close();
  }

}