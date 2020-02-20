import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';

class ChatPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DashChat(
        height: MediaQuery.of(context).size.height-130,
        user: ChatUser(
          name: "Fayeed",
          uid: "abc56789",
          avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
        ),
        messages: [
          ChatMessage(
            user: ChatUser(
              name: "Fayeed",
              uid: "123456789",
              avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
            ),
            text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
          ),
          ChatMessage(
            user: ChatUser(
              name: "Fayeed",
              uid: "123456789",
              avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
            ),
            text: "Test"
          )
        ],
        onSend: (e) {

        },
      )
    );
  }

}