// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:async';

import 'package:castonaut/models/podcast_feed.dart';
import 'package:castonaut/models/review.dart';
import 'package:castonaut/utils/api_key.dart';
import 'package:equatable/equatable.dart';
import 'package:castonaut/models/media_info.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../utils/api_secret.dart';

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
        final mediaInfo = await mediaRepository.fetchTrendingMediaInfo();
        emitter(state.copyWith(
          status: MediaStatus.success,
          mediaInfo: mediaInfo,
          hasReachedMax: false,
        ));
      }
      final posts = await mediaRepository.fetchTrendingMediaInfo(
        currentIndex: state.mediaInfo.length,
      );
      emitter(posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
        status: MediaStatus.success,
        mediaInfo: posts,
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
    on<MediaReviewAdded>(onMediaReviewAdded);
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

  Future<void> onMediaReviewAdded(MediaReviewAdded event, Emitter<MediaReviewState> emitter) async {
    emitter(state.copyWith(
      status: MediaStatus.success,
      mediaReview: List.from(state.mediaReview)..insert(0, event.review),
      hasReachedMax: false,
    ));
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

  Map<String, String> createHeaderForPodcastIndex() {
    String apiKey = ApiKey().key!;
    String apiSecret = ApiSecret().secret!;
    String currentUnixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();

    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);
    input.add(utf8.encode(apiKey));
    input.add(utf8.encode(apiSecret));
    input.add(utf8.encode(currentUnixTime));
    input.close();
    var digest = output.events.single;

    return {
      "X-Auth-Date": currentUnixTime,
      "X-Auth-Key": apiKey,
      "Authorization": digest.toString(),
      "User-Agent": "SomethingAwesome/1.0.1"
    };
  }

  Future<List<MediaInfo>> fetchTrendingMediaInfo({int currentIndex = 0}) async {
    Map<String, String> headers = createHeaderForPodcastIndex();
    Uri getUrl = Uri.https(
        'api.podcastindex.org',
        '/api/1.0/podcasts/trending',
        <String, String>{'max': '${currentIndex+20}'}
    );
    final response = await httpClient.get(getUrl, headers: headers);
    if (response.statusCode == 200) {
      final podcastFeedList = json.decode(response.body)["feeds"] as List;
      return podcastFeedList.map((dynamic json) {
        Map<String, dynamic> map = json as Map<String, dynamic>;
        PodcastFeed podcastFeed = PodcastFeed.fromJson(map);
        return MediaInfo.fromPodcastFeed(podcastFeed);
      }).toList();
    }
    throw Exception('error fetching trending media');
  }

  Future<List<MediaReview>> fetchMediaReview(String mediaId, {int startingIndex = 0}) async {
    DatabaseReference dbRef = FirebaseDatabase.instance. ('podcasts/$mediaId/reviews');
    dbRe .startAt(startingIndex.toString()).limitToFirst(20).once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values);
      });
    });

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
