import 'dart:async';
import 'dart:io';

import 'graphql/mutation.dart';
import 'graphql/graphql_constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CameraService{

  Future<void> addProfilePicture(String name, String base64String) async{
    Mutation mutation=new Mutation("uploadData", Mutation.NONE)
        .addObjects("name: \"$name\", base64String: \"$base64String\"");

    http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      if(resultMap.containsKey("errors")){  //TODO throw exception
        return null;
      }
    }
    return null;
  }

}