import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_cards/bloc/ChatBloc.dart';
import 'package:tinder_cards/bloc/DateBloc.dart';
import 'package:tinder_cards/model/User.dart';

import 'package:tinder_cards/model/ChatMessage.dart' as message;


class ChatPage extends StatefulWidget{

  final int userId;
  final int dateId;

  ChatPage({this.userId, this.dateId});

  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage>{

  ChatBloc _chatBloc;
  DateBloc _dateBloc = new DateBloc();

  Future<List<User>> _users;

  String textMessage;

  @override
  initState() {
    super.initState();
    this._init();
  }

  Future<void> _init() async {
    _users = this._dateBloc.loadUsers(widget.dateId);
  }

  @override
  Widget build(BuildContext context) {
    this._chatBloc = Provider.of<ChatBloc>(context);
    this._chatBloc.dispose();
    return FutureBuilder(
        future: this._users,
        builder: (_,  AsyncSnapshot<List<User>> data){
          if(data.connectionState == ConnectionState.done){
            this._chatBloc.connectService(widget.dateId, widget.userId, data.data);
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
                            alignment: m.user.id == widget.userId ? Alignment.topRight: Alignment.topLeft,
                            nip: m.user.id == widget.userId ? BubbleNip.rightTop: BubbleNip.leftTop,
                            color: m.user.id == widget.userId ? Color.fromRGBO(225, 255, 199, 1.0): null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(users[m.user.id].name, textAlign: m.user.id != widget.userId ? TextAlign.right: TextAlign.left),
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
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(
                        color: Colors.black, //change your color here
                      ),
                      title: Text(
                        "Chat",
                        style: TextStyle(color: Colors.black),
                      ),
                      centerTitle: true,
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        color: Colors.grey.shade100,
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
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 11,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5),
                                          child: TextField(
                                              decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(15.0))),
                                              onSubmitted: (String value){
                                                this._chatBloc.send(widget.userId, value);
                                              },
                                              onChanged: (String value){
                                                this.setState(() {
                                                  textMessage = value;
                                                });
                                              },
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_forward),
                                          onPressed: () => this._chatBloc.send(widget.userId, textMessage),
                                        )
                                    )
                                  ],
                                )
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