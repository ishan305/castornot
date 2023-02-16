import 'review.dart';
import 'package:equatable/equatable.dart';

class MediaInfo extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String description;
  final String thumbnailUrl;
  final String coverArtUrl;
  final double averageRating;
  final List<Source> sources;


  const MediaInfo({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.id,
    required this.coverArtUrl,
    required this.artist,
    required this.averageRating,
    required this.sources,
  });

  factory MediaInfo.fromJson(Map<String, dynamic> json) {
    return MediaInfo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      coverArtUrl: json['coverArtUrl'],
      artist: json['artist'],
      averageRating: 7.5,
      sources: json.containsKey('sources')
          ? json['sources'].map((x) => MediaReview.fromJson(x)).toList()
          : [],
    );
  }

  @override
  List<Object?> get props => [id];
}

class Source {
  final String name;
  final String url;

  Source({
    required this.name,
    required this.url,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      name: json['name'],
      url: json['url'],
    );
  }
}