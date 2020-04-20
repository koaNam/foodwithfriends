import 'dart:io';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:tinder_cards/service/social/SocialService.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FacebookService extends SocialService{

  static const String URL = "https://graph.facebook.com/v2.12/me?fields=name&access_token=";

  static FacebookLogin facebookLogin = FacebookLogin();

  @override
  String getIdentifier() {
    return "FACEBOOK";
  }

  @override
  Future<void> loadData() async {
    var resultToken = await facebookLogin.logIn(["email"]);
    http.Response result = await http.get(URL + resultToken.accessToken.token);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      this.id = int.parse(resultToken.accessToken.userId);
      this.name = resultMap["name"];
    }
    return;
  }




}