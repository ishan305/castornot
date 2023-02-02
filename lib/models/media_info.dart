import 'review.dart';
import 'package:equatable/equatable.dart';

class MediaInfo extends Equatable {
  final int id;
  final String title;
  final String artist;
  final String description;
  final String thumbnailUrl;
  final String coverArtUrl;
  final List<Review> reviews;
  final double averageRating;
  final List<Source> sources;


  MediaInfo({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.id,
    required this.reviews,
    required this.coverArtUrl,
    required this.artist,
    required this.averageRating,
    required this.sources,
  });

  factory MediaInfo.fromJson(Map<String, dynamic> json) {
    return MediaInfo(
      id: json['id'] as int,
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      coverArtUrl: json['coverArtUrl'],
      artist: json['artist'],
      reviews: json['reviews'].map((x) => Review.fromJson(x)).toList(),
      averageRating: json['reviews'].map((x) => Review.fromJson(x)).toList().map((x) => x.rating).reduce((x, y) => x+y)/json['reviews'].length*100,
      sources: json['sources'].map((x) => Source.fromJson(x)).toList(),
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