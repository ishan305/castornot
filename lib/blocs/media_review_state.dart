part of 'media_bloc.dart';

class MediaReviewState extends Equatable {
  final MediaStatus status;
  final List<MediaReview> mediaReview;
  final bool hasReachedMax;

  const MediaReviewState({
    this.status = MediaStatus.initial,
    this.mediaReview = const <MediaReview>[],
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [status, mediaReview];

  MediaReviewState copyWith({MediaStatus? status, List<MediaReview>? mediaReview, bool? hasReachedMax}) {
    return MediaReviewState(
      status: status ?? this.status,
      mediaReview: mediaReview ?? this.mediaReview,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}