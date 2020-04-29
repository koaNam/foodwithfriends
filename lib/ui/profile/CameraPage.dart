import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'dart:developer' as developer;

import 'package:path_provider/path_provider.dart';
import 'package:tinder_cards/bloc/ProfileBloc.dart';
import 'package:tinder_cards/ui/profile/DisplayPicturePage.dart';


class CameraPage extends StatefulWidget {
  static const String LOG = "ui.profile.CameraPage";

  final int userId;
  final ProfileBloc _profileBloc;

  CameraPage(this.userId, this._profileBloc);

  @override
  State<StatefulWidget> createState() {
    return CameraPageState();
  }
}

class CameraPageState extends State<CameraPage> {
  CameraController _controller;
  int _cameraIndex;
  List<CameraDescription> _cameras;

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
      _cameraIndex = 0;
      _cameras = cameras;
      _controller = CameraController(
        cameras[_cameraIndex],
        ResolutionPreset.veryHigh,
      );
    });
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width / _controller.value.aspectRatio,
                                child: CameraPreview(_controller)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      heroTag: "switch",
                      child: Icon(Icons.swap_horiz),
                      onPressed: () => {
                      setState(() {
                        this._cameraIndex = (this._cameraIndex + 1) % this._cameras.length;
                        this._controller = CameraController(
                          _cameras[this._cameraIndex],
                          ResolutionPreset.veryHigh,
                        );
                      }),
                      _initializeControllerFuture = _controller.initialize()},
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          heroTag: "takePic",
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
                  builder: (context) => DisplayPicturePage(
                    userId: widget.userId,
                    imagePath: path,
                    profileBloc: widget._profileBloc,
                  ),
                ),
              );
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
        ),
      ),
    );
  }
}
