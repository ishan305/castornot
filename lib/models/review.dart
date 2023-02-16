class MediaReview {
  final String id;
  final String userId;
  final String podcastId;
  final String name;
  final String review;
  final int rating;
  final String date;


  MediaReview({
    required this.id,
    required this.userId,
    required this.podcastId,
    required this.name,
    required this.review,
    required this.rating,
    required this.date});

  factory MediaReview.fromJson(Map<String, dynamic> json) {
    return MediaReview(
      id: json['podcastId'],
      userId: json['userId'],
      podcastId: json['podcastId'],
      name: json['name'],
      review: json['review'],
      rating: json['rating'] as int,
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'podcastId': podcastId,
      'name': name,
      'review': review,
      'rating': rating,
      'date': date,
    };
  }
}