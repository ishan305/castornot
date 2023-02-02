part of 'media_bloc.dart';

enum MediaStatus { initial, success, failure }

class MediaState extends Equatable {
  final MediaStatus status;
  final List<MediaInfo> mediaInfo;
  final bool hasReachedMax;

  const MediaState({
    this.status = MediaStatus.initial,
    this.mediaInfo = const <MediaInfo>[],
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [status, mediaInfo, hasReachedMax];

  MediaState copyWith({MediaStatus? status, List<MediaInfo>? mediaInfo, bool? hasReachedMax}) {
    return MediaState(
      status: status ?? this.status,
      mediaInfo: mediaInfo ?? this.mediaInfo,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}