import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';

import 'dart:convert';

class DisplayPicturePage extends StatelessWidget {
  final int userId;
  final String imagePath;
  final ProfileBloc profileBloc;

  DisplayPicturePage({this.userId, this.imagePath, this.profileBloc});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Center(
              child: Image.file(File(this.imagePath)),
            ),
            Container(
              color: Colors.black,
              height: ((MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) - MediaQuery.of(context).size.width  ) / 2,
            ),
            Container(
              margin: EdgeInsets.only(top: (((MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) - MediaQuery.of(context).size.width) / 2) + MediaQuery.of(context).size.width),
              color: Colors.black,
              height: ((MediaQuery.of(context).size.height  - MediaQuery.of(context).padding.top) - MediaQuery.of(context).size.width) / 2,
            ),
            Positioned(
              child: IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () => {
                  profileBloc.changeProfilePicture(
                      this.userId,
                      basename(this.imagePath).replaceAll(" ", ""),
                      base64Encode(File(this.imagePath).readAsBytesSync())),
                  Navigator.of(context).pop()
                },
              ),
              right: 0,
            ),
            Positioned(
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => {Navigator.of(context).pop()},
              ),
              left: 0,
            ),
          ],
        ),
      ),
    );
  }
}
