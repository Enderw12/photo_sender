part of 'preview_bloc.dart';

@immutable
abstract class PreviewState {}

class PreviewInitial extends PreviewState {
  final String imagePath = null;
}

class PreviewUploading extends PreviewState {
  final String imagePath;
  PreviewUploading(this.imagePath) : assert(imagePath != null);
}

class PreviewUploaded extends PreviewState {
  // final String imagePath;
  // PreviewUploaded(this.imagePath);
}

class PreviewImageState extends PreviewState {
  final String imagePath;
  PreviewImageState(this.imagePath);
}

class PreviewUploadFailed extends PreviewState {
  final String imagePath;
  PreviewUploadFailed(this.imagePath) : assert(imagePath != null);
}
