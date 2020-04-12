import 'dart:io';

class GraphQlConstants{
  static const String URL="http://52.29.23.56//v1/graphql";
  static const Map<String, String> HEADERS={HttpHeaders.contentTypeHeader: "application/json", "x-hasura-admin-secret": "ZsnTMov69n"};

  static const String CHAT_URL="ws://52.29.23.56/:8081/fwfchat/websocket";

  static const String S3_URL="https://foodwithfriends.s3.eu-central-1.amazonaws.com/";
}