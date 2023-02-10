import 'package:castonaut/models/media_info.dart';
import 'package:flutter/material.dart';

class MediaInfoTile extends StatelessWidget {
  MediaInfoTile({Key? key,
    required this.info}) : super(key: key);
  MediaInfo info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: NetworkImage(info.thumbnailUrl),
        ),
        Column(
          children: [
            Text(info.title),
            Row(
              children: [
                Icon(
                  info.averageRating > 5.0 ? Icons.thumb_up_sharp : Icons.thumb_down_sharp,
                ),
                Text('${info.averageRating}'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}