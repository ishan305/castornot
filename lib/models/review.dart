class Review {
  final String id;
  final String name;
  final String review;
  final double rating;
  final String date;


  Review({
    required this.id,
    required this.name,
    required this.review,
    required this.rating,
    required this.date});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      name: json['name'],
      review: json['review'],
      rating: json['rating'] as double,
      date: json['date'],
    );
  }
}