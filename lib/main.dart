import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_sender/screens/take_picture_screen.dart';
import 'package:photo_sender/screens/preview_screen.dart';

import 'bloc/camera_bloc.dart';
import 'bloc/preview_bloc.dart';
// import 'package:photo_sender/screens/main_screen.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      // home: TakePictureScreen(
      //   // Pass the appropriate camera to the TakePictureScreen widget.
      //   camera: firstCamera,
      // ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CameraBloc>(
            create: (context) => CameraBloc(),
          ),
          BlocProvider<PreviewBloc>(
            create: (context) => PreviewBloc(),
          ),
        ],
        child: PhotoSenderApp(),
      ),
    ),
  );
}

class PhotoSenderApp extends StatelessWidget {
  const PhotoSenderApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: PreviewScreen.route,
      routes: {
        PreviewScreen.route: (context) => PreviewScreen(),
        TakePictureScreen.route: (context) => TakePictureScreen(),
      },
    );
  }
}
