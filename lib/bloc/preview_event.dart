part of 'preview_bloc.dart';

@immutable
abstract class PreviewEvent {}

class PreviewImage extends PreviewEvent {
  final String imagePath;
  PreviewImage(this.imagePath) : assert(imagePath != null);
}

class PreviewUploadImage extends PreviewEvent {
  final String imagePath;
  PreviewUploadImage(this.imagePath) : assert(imagePath != null);
}
