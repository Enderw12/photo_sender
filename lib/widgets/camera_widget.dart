import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:photo_sender/bloc/camera_bloc.dart';
import 'package:photo_sender/bloc/preview_bloc.dart';
import 'package:photo_sender/screens/preview_screen.dart';

class CameraWidget extends StatefulWidget {
  final CameraDescription camera;
  final bool back;

  const CameraWidget({
    Key key,
    @required this.camera,
    @required this.back,
  }) : super(key: key);

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String cameraLensDirection =
        widget.back ? 'Основная камера' : 'Фронтальная камера';
    return Scaffold(
      // appBar: AppBar(title: Text(cameraLensDirection)),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: ActionButtons(
        initializeControllerFuture: _initializeControllerFuture,
        controller: _controller,
        back: widget.back,
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key key,
    @required Future<void> initializeControllerFuture,
    @required CameraController controller,
    @required bool back,
  })  : _initializeControllerFuture = initializeControllerFuture,
        _controller = controller,
        _back = back,
        super(key: key);

  final Future<void> _initializeControllerFuture;
  final CameraController _controller;
  final bool _back;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: FloatingActionButton(
            child: Icon(_back ? Icons.camera_front : Icons.camera_rear),
            onPressed: () {
              BlocProvider.of<CameraBloc>(context).add(CameraSwitch(_back));
            },
          ),
          alignment: Alignment.bottomCenter,
        ),
        Align(
          child: FloatingActionButton(
            child: Icon(Icons.camera_alt),
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Construct the path where the image should be saved using the
                // pattern package.
                final path = join(
                  // Store the picture in the temp directory.
                  // Find the temp directory using the `path_provider` plugin.
                  (await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png',
                );

                // Attempt to take a picture and log where it's been saved.
                await _controller.takePicture(path);

                BlocProvider.of<PreviewBloc>(context).add(PreviewImage(path));

                Navigator.of(context).pop();
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
          ),
          alignment: Alignment.bottomRight,
        ),
      ],
    );
  }
}
