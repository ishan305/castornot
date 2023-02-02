import 'package:castonaut/models/media_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaInfoPage extends StatelessWidget {
  const MediaInfoPage(Key? key, this.info) : super(key: key);
  final MediaInfo info;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Image (
          image: NetworkImage(info.coverArtUrl),
        ),
        Scaffold (
          appBar: AppBar(
            title: Text(info.title),
          ),
          body: SingleChildScrollView(child:
            Column(
              children: [
                Container(height: 200),
                MediaInfoExpanded(info: info),
                Center(child: ExternalPlayButton(info: info)),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MediaInfoExpanded extends StatelessWidget {
  const MediaInfoExpanded({
    super.key,
    required this.info,
  });

  final MediaInfo info;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(info.title),
            Text(info.artist),
          ],
        ),
        Column(
          children: [
            Icon(
              info.averageRating > 50 ? Icons.thumb_up_sharp : Icons.thumb_down_sharp,
            ),
            Text(info.averageRating as String),
          ],
        ),
      ],
    );
  }
}

class ExternalPlayButton extends StatelessWidget {
  const ExternalPlayButton({
    super.key,
    required this.info,
  });

  final MediaInfo info;

  Future<void> _openUrl(String urlString) async {
    Uri uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _openUrl(info.sources[0].url);
      },
      child: Row(
        children: [
          Text('Play this music on ' + info.sources[0].name),
          const Icon(Icons.play_arrow),
        ],
      ),
    );
  }
}