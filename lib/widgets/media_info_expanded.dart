import 'package:castonaut/blocs/media_bloc.dart';
import 'package:castonaut/models/media_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../models/review.dart';

class MediaInfoPage extends StatelessWidget {
  const MediaInfoPage(Key? key, this.info) : super(key: key);
  final MediaInfo info;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Positioned.fill(child:
          Image (
            image: NetworkImage(info.coverArtUrl),
            fit: BoxFit.fill,
          ),
        ),
        Scaffold (
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(info.title),
          ),
          body: BlocProvider(
            create: (_) => MediaReviewBloc(mediaRepository: MediaRepository(httpClient: http.Client()))
            ..add(MediaReviewFetched(mediaId: info.id)),
            child: MediaInfoReviewScrollVew(mediaInfo: info),
          ),
        ),
      ],
    );
  }
}

class MediaInfoReviewScrollVew extends StatefulWidget {
  const MediaInfoReviewScrollVew({
    key,
    required this.mediaInfo,
  }) : super(key: key);

  final MediaInfo mediaInfo;

  @override
  State<MediaInfoReviewScrollVew> createState() => _MediaInfoReviewScrollVewState();
}

class _MediaInfoReviewScrollVewState extends State<MediaInfoReviewScrollVew> {

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if(_isBottom) {
      context.read<MediaReviewBloc>().add(MediaReviewFetched(mediaId: widget.mediaInfo.id));
    }
  }

  bool get _isBottom {
    if(!_scrollController.hasClients) {
      return false;
    }
    return _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
  }


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers:[
      SliverList(
        delegate: SliverChildListDelegate.fixed([
            Container(height: 200),
            MediaInfoExpanded(info: widget.mediaInfo),
            Center(child: ExternalPlayButton(info: widget.mediaInfo)),
        ]),
      ),
      const MediaReviewList(),
    ],
    controller: _scrollController,
    );
  }
}

class MediaReviewList extends StatelessWidget {
  const MediaReviewList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaReviewBloc, MediaReviewState>(
      builder: (context, state) {
        switch (state.status) {
          case MediaStatus.failure:
            return SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildListDelegate(
                [
                  const Text('failed to fetch posts'),
                ],
              ),
            );
          case MediaStatus.success:
            if (state.mediaReview.isEmpty) {
              return SliverFixedExtentList(
                itemExtent: 50.0,
                delegate: SliverChildListDelegate(
                  [
                    const Text('no reviews'),
                  ],
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= state.mediaReview.length) {return Container();}
                  return MediaReviewTile(review: state.mediaReview[index]);
                },
              childCount: state.hasReachedMax
                  ? state.mediaReview.length
                  : state.mediaReview.length + 1,
            ));
          case MediaStatus.initial:
            return SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildListDelegate(
                [
                  const Text('failed to fetch reviews'),
                ],
              ),
            );
        }
      },
    );
  }
}

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
              info.averageRating > 5.0 ? Icons.thumb_up_sharp : Icons.thumb_down_sharp,
            ),
            Text('${info.averageRating}'),
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
        if(info.sources.isNotEmpty){
          _openUrl(info.sources[0].url);
        }
      },
      child: Row(
        children: [
          info.sources.isEmpty
              ? const Text('No Sources avaialble')
              : Text('Play this music on ' + info.sources[0].name),
          const Icon(Icons.play_arrow),
        ],
      ),
    );
  }
}