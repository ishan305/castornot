class PodcastFeed {
  int? id;
  String? url;
  String? title;
  String? description;
  String? author;
  String? image;
  String? artwork;
  int? newestItemPublishTime;
  int? itunesId;
  int? trendScore;
  String? language;
  Map<String, dynamic>? categories;

  PodcastFeed({this.id,
    this.url,
    this.title,
    this.description,
    this.author,
    this.image,
    this.artwork,
    this.newestItemPublishTime,
    this.itunesId,
    this.trendScore,
    this.language,
    this.categories});

  factory PodcastFeed.fromJson(Map<String, dynamic> json) {
    return PodcastFeed(
    id : json['id'],
    url : json['url'],
    title : json['title'],
    description : json['description'],
    author : json['author'],
    image : json['image'],
    artwork : json['artwork'],
    newestItemPublishTime : json['newestItemPublishTime'],
    itunesId : json['itunesId'],
    trendScore : json['trendScore'],
    language : json['language'],
    categories : json['categories']);
  }
}