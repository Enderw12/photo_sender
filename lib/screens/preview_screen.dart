import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_sender/bloc/camera_bloc.dart';
import 'package:photo_sender/bloc/preview_bloc.dart';
import 'package:photo_sender/screens/take_picture_screen.dart';

class PreviewScreen extends StatelessWidget {
  static const route = '/display_picture_screen';

  const PreviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: BlocConsumer<PreviewBloc, PreviewState>(
        listener: (context, state) {
          if (state is PreviewUploadFailed)
            PreviewColumnWidget(imagePath: state.imagePath, uploadFailed: true);
        },
        builder: (context, state) {
          if (state is PreviewImageState)
            return PreviewColumnWidget(
              imagePath: state.imagePath,
            );
          if (state is PreviewUploading)
            return PreviewColumnWidget(
                imagePath: state.imagePath, uploading: true);
          if (state is PreviewUploaded)
            return PreviewColumnWidget(
              imagePath: null,
            );
          else
            return PreviewColumnWidget(imagePath: null);
        },
      ),
    );
  }
}

class PreviewColumnWidget extends StatelessWidget {
  const PreviewColumnWidget({
    Key key,
    @required this.imagePath,
    this.uploading = false,
    this.uploadFailed = false,
  }) : super(key: key);
  final bool uploadFailed;
  final bool uploading;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final snackBar =
        SnackBar(content: Text('Сетевая ошибка! Попробуйте снова.'));
    final String cameraButtonLabel =
        (imagePath == null) ? 'Сделать фото' : 'Сделать другое фото';
    final String uploadButtonLabel = uploading ? 'Ожидайте...' : 'Загрузить';
    return Column(
      children: [
        CapturedImageWidget(
          imagePath: imagePath,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
        ),
        FlatButton.icon(
          icon: Icon(Icons.camera),
          label: Text(cameraButtonLabel),
          onPressed: () {
            BlocProvider.of<CameraBloc>(context).add(CameraInitialize());
            Navigator.of(context).pushNamed(TakePictureScreen.route);
          },
        ),
        FlatButton.icon(
          icon: Icon(uploading ? Icons.lock_clock : Icons.upload_file),
          label: Text(uploadButtonLabel),
          onPressed: uploading
              ? null
              : () => BlocProvider.of<PreviewBloc>(context)
                  .add(PreviewUploadImage(imagePath)),
        ),
        if (uploadFailed) snackBar
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

class CapturedImageWidget extends StatelessWidget {
  final String imagePath;
  const CapturedImageWidget({@required this.imagePath, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (imagePath == null)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Placeholder(
                fallbackHeight: MediaQuery.of(context).size.height * 0.5,
                fallbackWidth: MediaQuery.of(context).size.width * 0.3,
              ),
            )
          : Image.file(
              File(imagePath),
              height: MediaQuery.of(context).size.height * 0.5,
            ),
    );
  }
}
