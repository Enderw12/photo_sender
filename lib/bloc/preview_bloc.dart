import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'preview_event.dart';
part 'preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  PreviewBloc() : super(PreviewInitial());

  @override
  Stream<PreviewState> mapEventToState(
    PreviewEvent event,
  ) async* {
    if (event is PreviewImage) {
      yield PreviewImageState(event.imagePath);
    }
    if (event is PreviewUploadImage) {
      yield PreviewUploading(event.imagePath);
      try {
        // TODO implement uploading to server
        await Future.delayed(Duration(seconds: 1));
        yield PreviewUploaded();
      } on HttpException {
        yield PreviewUploadFailed(event.imagePath);
      }
    }
  }
}
