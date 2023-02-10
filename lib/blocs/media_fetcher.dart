part of 'media_bloc.dart';

abstract class MediaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MediaFetched extends MediaEvent {}

class MediaReviewFetched extends MediaEvent {
  final int mediaId;

  MediaReviewFetched({required this.mediaId});
}