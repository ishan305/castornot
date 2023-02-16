part of 'media_bloc.dart';

abstract class MediaEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MediaFetched extends MediaEvent {}

class MediaReviewFetched extends MediaEvent {
  final String mediaId;

  MediaReviewFetched({required this.mediaId});
}

class MediaReviewAdded extends MediaEvent {
  final String mediaId;
  final MediaReview review;

  MediaReviewAdded({required this.mediaId, required this.review});
}