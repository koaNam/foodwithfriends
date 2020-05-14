import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/service/ProfileService.dart';

import 'dart:developer' as developer;

class ProfileSettingsBloc {

  static const String LOG = "bloc.ProfileSettingsBloc";

  BehaviorSubject<User> _profileController = BehaviorSubject<User>();
  Observable<User> get profileStream => _profileController.stream;

  ProfileService _profileService = new ProfileService();


  set name(String username){
    User lastUser = this._profileController.value;
    lastUser.name = username;
    this._profileController.add(lastUser);
  }

  set birthDate(String birthdate){
    User lastUser = this._profileController.value;
    lastUser.birthDate = DateFormat("dd.MM.yyyy").parse(birthdate);
    this._profileController.add(lastUser);
  }

  set ageMinOffset(double offset){
    User lastUser = this._profileController.value;
    lastUser.ageMinOffset = offset.round();
    this._profileController.add(lastUser);
  }

  set ageMaxOffset(double offset){
    User lastUser = this._profileController.value;
    lastUser.ageMaxOffset = offset.round();
    this._profileController.add(lastUser);
  }

  set cookingSkill(double skill){
    User lastUser = this._profileController.value;
    lastUser.cookingSkill = skill;
    this._profileController.add(lastUser);
  }

  set skillMinOffset(double offset){
    User lastUser = this._profileController.value;
    offset = num.parse((offset * 2).roundToDouble().toStringAsFixed(1));
    lastUser.skillMinOffset = offset / 2;
    this._profileController.add(lastUser);
  }

  set skillMaxOffset(double offset){
    User lastUser = this._profileController.value;
    offset = num.parse((offset * 2).roundToDouble().toStringAsFixed(1));
    lastUser.skillMaxOffset = offset / 2;
    this._profileController.add(lastUser);
  }

  set hasKitchen(bool hasKitchen){
    User lastUser = this._profileController.value;
    lastUser.hasKitchen = hasKitchen;
    this._profileController.add(lastUser);
  }

  set maxUsers(double maxUsers){
    User lastUser = this._profileController.value;
    lastUser.maxUsers = maxUsers.round();
    this._profileController.add(lastUser);
  }


  Future<void> loadProfileSettings(int id) async {
    developer.log("finding user with settings by id", name: LOG);
    User user=await this._profileService.findUserSettingsById(id);
    this._profileController.add(user);
  }

  Future<void> updateProfileSettings() async{
    developer.log("updating profile settings", name: LOG);

    User user = this._profileController.value;
    this._profileService.updateProfileSettings(user);
  }

}