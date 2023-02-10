class MediaReview {
  final int id;
  final int podcastId;
  final String name;
  final String review;
  final int rating;
  final String date;


  MediaReview({
    required this.id,
    required this.podcastId,
    required this.name,
    required this.review,
    required this.rating,
    required this.date});

  factory MediaReview.fromJson(Map<String, dynamic> json) {
    return MediaReview(
      id: json['podcastId'] as int,
      podcastId: json['podcastId'] as int,
      name: json['name'],
      review: json['review'],
      rating: json['rating'] as int,
      date: json['date'],
    );
  }
}