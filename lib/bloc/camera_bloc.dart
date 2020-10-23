import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitial());

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if (event is CameraInitialize) {
      yield CameraLoading();
      // WidgetsFlutterBinding.ensureInitialized();

      // Obtain a list of the available cameras on the device.
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        const back = true;
        yield CameraLoaded(
            cameras.firstWhere(
              (description) =>
                  description.lensDirection == CameraLensDirection.back,
            ),
            back);
      } else {
        yield CameraError();
      }
    }
    if (event is CameraSwitch) {
      final cameras = await availableCameras();
      final bool back = event.back;

      if (back)
        yield CameraLoaded(
            cameras.firstWhere((description) =>
                description.lensDirection == CameraLensDirection.front),
            !back);
      if (back)
        yield CameraLoaded(
            cameras.firstWhere((description) =>
                description.lensDirection == CameraLensDirection.back),
            !back);
    }
  }
}
