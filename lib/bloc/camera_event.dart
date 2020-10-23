part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {}

class CameraSwitch extends CameraEvent {
  final bool back;
  CameraSwitch(this.back) : assert(back != null);
}

class CameraInitialize extends CameraEvent {}
