import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/ChatBloc.dart';
import 'package:tinder_cards/bloc/DateBloc.dart';
import 'package:tinder_cards/model/User.dart';

import 'package:tinder_cards/model/ChatMessage.dart' as message;


class ChatPage extends StatelessWidget{

  final int userId;
  final int dateId;

  ChatBloc _chatBloc = new ChatBloc();
  DateBloc _dateBloc = new DateBloc();

  Future<List<User>> _users;

  ChatPage({this.userId, this.dateId}){
    this._init();
  }

  Future<void> _init() async {
    _users = this._dateBloc.loadUsers(this.dateId);
    this._chatBloc.connectService(this.dateId, this.userId, await _users);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._users,
      builder: (_,  AsyncSnapshot<List<User>> data){
        if(data.connectionState == ConnectionState.done){
          Map<int, User> users = Map.fromIterable(data.data, key: (u) => u.id, value: (u) => u);
          return StreamBuilder(
              stream: this._chatBloc.messageStream,
              builder: (_, AsyncSnapshot<List<message.ChatMessage>> dataList) {
                Widget chat;
                if(dataList.connectionState == ConnectionState.active){
                  List<message.ChatMessage> messages=dataList.data;
                  chat =ListView(
                    children: messages.map((m) =>
                      Bubble(
                        margin: BubbleEdges.only(top: 10),
                        alignment: m.user.id == this.userId ? Alignment.topRight: Alignment.topLeft,
                        nip: m.user.id == this.userId ? BubbleNip.rightTop: BubbleNip.leftTop,
                        color: m.user.id == this.userId ? Color.fromRGBO(225, 255, 199, 1.0): null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(users[m.user.id].name, textAlign: m.user.id != this.userId ? TextAlign.right: TextAlign.left),
                            Text(m.message, textAlign: TextAlign.right)
                          ],
                        ),
                      ),
                    ).toList(),
                  );

                } else {
                  chat = ListView(
                    children: <Widget>[],
                  );
                }
                return Scaffold(
                    appBar: AppBar(title: Text("Chat"), centerTitle: true,),
                    body: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 81,
                        child: Flex(
                              direction: Axis.vertical,
                              children: <Widget>[
                                Expanded(
                                  flex: 15,
                                  child:
                                    chat
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))),
                                    onSubmitted: (String value){
                                      this._chatBloc.send(this.userId, value);
                                    },
                                  ),
                                )
                              ],
                            ),
                      ),
                    ),
                );
              }
          );
        } else {
          return CircularProgressIndicator();
        }
    }
    );

  }

}