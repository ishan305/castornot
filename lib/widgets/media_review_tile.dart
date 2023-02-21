import 'package:flutter/material.dart';

import '../models/review.dart';

class MediaReviewTile extends StatelessWidget{
  const MediaReviewTile({
    super.key,
    required this.review,
  });

  final MediaReview review;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(review.name),
            Text(review.review),
          ],
        ),
        Column(
          children: [
            Icon(
              review.rating > 5.0 ? Icons.thumb_up_sharp : Icons.thumb_down_sharp,
            ),
            Text('${review.rating}'),
          ],
        ),
      ],
    );
  }
}