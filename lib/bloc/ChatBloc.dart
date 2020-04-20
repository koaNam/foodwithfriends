import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stomp/impl/plugin.dart';
import "package:stomp/stomp.dart";
import 'package:tinder_cards/bloc/DateBloc.dart';
import 'package:tinder_cards/model/ChatMessage.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/service/graphql/graphql_constants.dart';
import 'package:web_socket_channel/io.dart';

import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert' as convert;

class ChatBloc {

  StompClient _stompClient;
  String _chatId;

  List<ChatMessage> _messages = new List();

  BehaviorSubject<List<ChatMessage>> _messageController = BehaviorSubject<List<ChatMessage>>();
  Observable<List<ChatMessage>> get messageStream =>_messageController.stream;

  Future<void> connectService(int dateId, int userId, List<User> users) async {
    String chatId = "$dateId:";
    users.forEach((u) => chatId += "${u.id}:");
    this._chatId = chatId.hashCode.toString();
    this._stompClient =  await this.connect(GraphQlConstants.CHAT_URL);

    this._stompClient.subscribeString("1", "/user/$userId/**", (Map<String, String> header, String msg) {
      List<dynamic> result = convert.jsonDecode(msg);
      for(var message in result){
        this._messages.add(ChatMessage.fromJson(message));
      }
      this._messageController.add(this._messages);
    });

     this._stompClient.subscribeString("2", "/room/${this._chatId}", (Map<String, String> header, String msg) {
      ChatMessage message = ChatMessage.fromJson(convert.jsonDecode(msg));
      this._messages.add(message);
      this._messageController.add(this._messages);
    });

    this._stompClient.sendString("/chat/user/$userId/${this._chatId}/getAll", "dummy");
  }

  Future<void> send(int userId, String message) async{
    this._stompClient.sendString("/chat/room/${this._chatId}/message.send", convert.jsonEncode(ChatMessage(user: User(userId, null, null, null, null, null), message: message).toJson()));
  }


  Future<StompClient> connect(String url,
      {String host,
        String login,
        String passcode,
        List<int> heartbeat,
        void onConnect(StompClient client, Map<String, String> headers),
        void onDisconnect(StompClient client),
        void onError(StompClient client, String message, String detail,
            Map<String, String> headers),
        void onFault(StompClient client, error, stackTrace)}) async {
      return connectWith(await IOWebSocketChannel.connect(url),
          host: host,
          login: login,
          passcode: passcode,
          heartbeat: heartbeat,
          onConnect: onConnect,
          onDisconnect: onDisconnect,
          onError: onError,
          onFault: onFault);
  }
  Future<StompClient> connectWith(IOWebSocketChannel channel,
      {String host,
        String login,
        String passcode,
        List<int> heartbeat,
        void onConnect(StompClient client, Map<String, String> headers),
        void onDisconnect(StompClient client),
        void onError(StompClient client, String message, String detail,
            Map<String, String> headers),
        void onFault(StompClient client, error, stackTrace)}){
      return StompClient.connect(_WSStompConnector.startWith(channel),
          host: host,
          login: login,
          passcode: passcode,
          heartbeat: heartbeat,
          onConnect: onConnect,
          onDisconnect: onDisconnect,
          onError: onError,
          onFault: onFault);
      }
}

class _WSStompConnector extends StringStompConnector {
  final IOWebSocketChannel _socket;
  StreamSubscription _listen;


  static _WSStompConnector startWith(IOWebSocketChannel socket) =>
      new _WSStompConnector(socket);

  _WSStompConnector(this._socket) {
    _init();
  }

  void _init() {
    _listen = _socket.stream.listen((data) {
      if (data != null) {
        final String sdata = data.toString();
        if (sdata.isNotEmpty) onString(sdata);
      }
    });
    _listen.onError((err) => onError(err, null));
    _listen.onDone(() => onClose());

    _socket.stream.handleError((error) => onError(error, null));

    _socket.sink.done.then((v) {
      onClose();
    });
  }

  @override
  void writeString_(String string) {
    _socket.sink.add(string);
  }

  @override
  Future close() {
    _listen.cancel();
    _socket.sink.close(status.goingAway);
    return new Future.value();
  }
}