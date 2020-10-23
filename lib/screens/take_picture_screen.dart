import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_sender/bloc/camera_bloc.dart';
import 'package:photo_sender/widgets/camera_widget.dart';

class TakePictureScreen extends StatelessWidget {
  static const route = '/take_picture_screen';
  const TakePictureScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is CameraLoading) return Loading();
        if (state is CameraLoaded)
          return CameraWidget(camera: state.camera, back: state.back);
      },
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initializing...'),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
