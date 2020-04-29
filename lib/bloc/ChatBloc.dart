import 'dart:async';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tinder_cards/model/ChatMessage.dart';
import 'package:tinder_cards/model/User.dart';
import 'dart:convert' as convert;
import 'package:path_provider/path_provider.dart';

class ChatBloc {

  MqttServerClient client;
  List<ChatMessage> _messages = new List();
  String _chatId;

  BehaviorSubject<List<ChatMessage>> _messageController = BehaviorSubject<List<ChatMessage>>();
  Observable<List<ChatMessage>> get messageStream =>_messageController.stream;

  Future<void> connectService(int dateId, int userId, List<User> users) async {
    //this.dispose();
    if(this.client == null || this.client.connectionStatus.state != MqttConnectionState.connected) {
      client = MqttServerClient('wss://b-9c6d043a-3ff3-4ee4-b8e1-0d2352d3f377-1.mq.eu-central-1.amazonaws.com', '');
      client.useWebSocket = true;
      client.port = 61619;
      client.keepAlivePeriod = 30;

      final connMess = MqttConnectMessage()
          .withClientIdentifier(userId.toString())
          .withWillQos(MqttQos.atLeastOnce)
          .keepAliveFor(30)
          .authenticateAs("***REMOVED***", "***REMOVED******REMOVED***");

      client.connectionMessage = connMess;
      await client.connect();

      String chatId = "$dateId:";
      users..sort((f, s) => f.id - s.id)..forEach((u) => chatId += "${u.id}:");
      this._chatId = chatId.hashCode.toString();

      String topic = 'chat/${this._chatId}';
      client.subscribe(topic, MqttQos.atLeastOnce);

      client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
        final MqttPublishMessage recMess = c[0].payload;
        final msg = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        Map<String, dynamic> result = convert.jsonDecode(msg);
        this._messages.add(ChatMessage.fromJson(result));

        this._messageController.add(this._messages);

        this._saveMessage(msg);
      });

      List<ChatMessage> oldMessages = await this._readMessages();
      this._messages.addAll(oldMessages);
      this._messageController.add(oldMessages);
    }
  }

  Future<void> send(int userId, String message) async{
    final builder = MqttClientPayloadBuilder();
    builder.addString(convert.jsonEncode(ChatMessage(user: User(userId, null, null, null, null, null), message: message).toJson()));
    client.publishMessage('chat/${this._chatId}', MqttQos.exactlyOnce, builder.payload);
  }

  dispose(){
    this._messages = new List();
    if(this.client != null) {
      this.client.unsubscribe('chat/${this._chatId}');
      this.client.disconnect();
    }
  }

  _saveMessage(String message) async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    File file = File('$path/${this._chatId}');
    file.writeAsString("$message;", mode: FileMode.append);
  }

  Future<List<ChatMessage>> _readMessages() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    File file = File('$path/${this._chatId}');
    if(file.existsSync()) {
      String data = file.readAsStringSync();
      List<String> messageStrings = data.split(";");

      List<ChatMessage> messages = new List();
      for (String messageString in messageStrings) {
        if (messageString.isNotEmpty) {
          ChatMessage message = ChatMessage.fromJson(convert.jsonDecode(messageString));
          messages.add(message);
        }
      }
      return messages;
    }
    return new List();
  }

}