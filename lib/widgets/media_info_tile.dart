import 'package:castonaut/models/media_info.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaInfoTile extends StatelessWidget {
  const MediaInfoTile({Key? key,
    required this.info}) : super(key: key);
  final MediaInfo info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: info.thumbnailUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),),
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
    );
  }
}