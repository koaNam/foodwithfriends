import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'dart:developer' as developer;

import 'package:path_provider/path_provider.dart';
import 'package:tinder_cards/ui/profile/DisplayPicturePage.dart';

class CameraPage extends StatefulWidget{

  static const String LOG="ui.profile.CameraPage";

  @override
  State<StatefulWidget> createState() {
    return CameraPageState();
  }

}

class CameraPageState extends State<CameraPage>{

  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  initState() {
    super.initState();
    this._createCamera();
  }

  Future<void> _createCamera() async {
    developer.log("creating camera", name: CameraPage.LOG);

    List<CameraDescription> cameras = await availableCameras();
    setState(() {
      _controller = CameraController(cameras.first, ResolutionPreset.medium,);
    });
    _initializeControllerFuture =  _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                //builder: (context) => DisplayPictureScreen(imagePath: path),
                builder: (context) => DisplayPicturePage(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }

}