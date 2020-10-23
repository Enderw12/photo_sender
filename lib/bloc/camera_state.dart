part of 'camera_bloc.dart';

@immutable
abstract class CameraState {}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraLoaded extends CameraState {
  final CameraDescription camera;
  final bool back;
  CameraLoaded(this.camera, this.back): assert(camera != null && back != null);
}

class CameraError extends CameraState {
  final error;
  CameraError({
    this.error = 'Camera initialization failed',
  });
}
