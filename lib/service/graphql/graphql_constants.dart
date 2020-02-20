import 'dart:io';

class GraphQlConstants{
 // static const String URL="http://54.93.216.142/v1/graphql";
  //static const String URL="http://10.0.2.2:8080/graphql";
  static const String URL="http://ec2-3-121-201-73.eu-central-1.compute.amazonaws.com/v1/graphql";
  static const Map<String, String> HEADERS={HttpHeaders.contentTypeHeader: "application/json", "x-hasura-admin-secret": "ZsnTMov69n"};
}