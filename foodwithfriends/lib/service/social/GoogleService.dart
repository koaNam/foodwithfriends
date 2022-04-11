import 'package:google_sign_in/google_sign_in.dart';
import 'package:foodwithfriends/service/social/SocialService.dart';

class GoogleService extends SocialService{

  static const String URL = "https://graph.facebook.com/v2.12/me?fields=name&access_token=";

  @override
  String getIdentifier() {
    return "GOOGLE";
  }

  @override
  Future<void> loadData() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email'],
    );
    GoogleSignInAccount result = await googleSignIn.signIn();
    this.id = result.id;
    this.name = result.displayName;

    return;
  }




}