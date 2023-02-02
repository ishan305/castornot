import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:castonaut/models/media_info.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';


part 'media_fetcher.dart';
part 'media_state.dart';


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
      emit(posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
        status: MediaStatus.success,
        mediaInfo: List.from(state.mediaInfo)..addAll(posts),
        hasReachedMax: false,
      ));

    } catch (_) {
      emitter(state.copyWith(status: MediaStatus.failure));
    }
  }
}

//TODO: Update the uri to your own backend.
class MediaRepository {
  final http.Client httpClient;

  MediaRepository({required this.httpClient});

  Future<List<MediaInfo>> fetchMediaInfo({int startingIndex = 0}) async {
    final response = await httpClient.get(Uri.parse(
        'https://castonaut.herokuapp.com/api/media/$startingIndex'));
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return MediaInfo.fromJson(map);
      }).toList();
    }
    throw Exception('error fetching media infos');
  }
}
