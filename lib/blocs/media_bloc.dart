import 'dart:convert';

import 'package:castonaut/models/review.dart';
import 'package:equatable/equatable.dart';
import 'package:castonaut/models/media_info.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';


part 'media_fetcher.dart';
part 'media_state.dart';
part 'media_review_state.dart';


class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRepository mediaRepository;

  EventTransformer<E> throttleDroppableRequests<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  MediaBloc({required this.mediaRepository})
      : super(const MediaState()) {
    on<MediaFetched>(
        onMediaFetched,
        transformer: throttleDroppableRequests(const Duration(milliseconds: 100)));
  }

  Future<void> onMediaFetched(MediaFetched event, Emitter<MediaState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == MediaStatus.initial) {
        final mediaInfo = await mediaRepository.fetchMediaInfo();
        emitter(state.copyWith(
          status: MediaStatus.success,
          mediaInfo: mediaInfo,
          hasReachedMax: false,
        ));
      }
      final posts = await mediaRepository.fetchMediaInfo(
        startingIndex: state.mediaInfo.length,
      );
      emitter(posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
        status: MediaStatus.success,
        mediaInfo: List.from(state.mediaInfo)..addAll(posts),
        hasReachedMax: false,
      ));

    } catch (_) {
      print(_);
      emitter(state.copyWith(status: MediaStatus.failure));
    }
  }
}


class MediaReviewBloc extends Bloc<MediaEvent, MediaReviewState> {
  final MediaRepository mediaRepository;

  MediaReviewBloc({required this.mediaRepository})
      : super(const MediaReviewState()) {
    on<MediaReviewFetched>(onMediaReviewFetched);
  }

  Future<void> onMediaReviewFetched(MediaReviewFetched event, Emitter<MediaReviewState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == MediaStatus.initial) {
        final mediaReview = await mediaRepository.fetchMediaReview(event.mediaId);
        emitter(state.copyWith(
          status: MediaStatus.success,
          mediaReview: mediaReview,
          hasReachedMax: false,
        ));
      }
      final mediaReview = await mediaRepository.fetchMediaReview(event.mediaId, startingIndex: state.mediaReview.length);
      emitter(mediaReview.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
        status: MediaStatus.success,
        mediaReview: List.from(state.mediaReview)..addAll(mediaReview),
        hasReachedMax: false,
      ));

    } catch (_) {
      print(_);
      emitter(state.copyWith(status: MediaStatus.failure));
    }
  }
}

//TODO: Update the uri to your own backend.
class MediaRepository {
  final http.Client httpClient;

  MediaRepository({required this.httpClient});

  Future<List<MediaInfo>> fetchMediaInfo({int startingIndex = 0}) async {
    Uri getUrl = Uri.https(
        'mockend.com',
        '/ishan305/castornot-mockend/podcast',
        <String, String>{'_start': '$startingIndex', '_limit': '20'}
    );
    final response = await httpClient.get(getUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return MediaInfo.fromJson(map);
      }).toList();
    }
    throw Exception('error fetching media infos');
  }

  Future<List<MediaReview>> fetchMediaReview(int mediaId, {int startingIndex = 0}) async {
    Uri getUrl = Uri.https(
        'mockend.com',
        '/ishan305/castornot-mockend/reviews',
        <String, String>{'podcastid_eq': '${mediaId}','_start': '${startingIndex}', '_limit': '20'}
    );
    final response = await httpClient.get(getUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return MediaReview.fromJson(map);
      }).toList();
    }
    throw Exception('error fetching media reviews');
  }
}
