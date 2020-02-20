import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayPicturePage extends StatelessWidget {

  final String imagePath;

  const DisplayPicturePage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.file(File(this.imagePath)),
    );
  }
}