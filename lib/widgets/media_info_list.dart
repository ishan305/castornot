import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/media_bloc.dart';
import '../models/media_info.dart';
import '../views/media_screen.dart';
import 'media_info_tile.dart';

class InfiniteScrollingList extends StatefulWidget {
  const InfiniteScrollingList({Key? key}) : super(key: key);

  @override
  State<InfiniteScrollingList> createState() => _InfiniteScrollingListState();
}

class _InfiniteScrollingListState extends State<InfiniteScrollingList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if(_isBottom) {
      context.read<MediaBloc>().add(MediaFetched());
    }
  }

  bool get _isBottom {
    if(!_scrollController.hasClients) {
      return false;
    }
    return _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
  }

  _navigateToExpandedView(MediaInfo info, BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MediaInfoPage(context.widget.key, info),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaBloc, MediaState>(
        builder: (context, state) {
          switch (state.status) {
            case MediaStatus.failure:
              return const Center(child: Text('failed to fetch posts'));
            case MediaStatus.success:
              if(state.mediaInfo.isEmpty) {
                return const Center(child: Text('no posts'));
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return index < state.mediaInfo.length
                      ? ElevatedButton(
                            onPressed: () {_navigateToExpandedView(state.mediaInfo[index], context);},
                            child: MediaInfoTile(info: state.mediaInfo[index]))
                      : const Center(child: CircularProgressIndicator(semanticsLabel: 'Circular progress indicator'));
                },
                itemCount: state.hasReachedMax
                    ? state.mediaInfo.length
                    : state.mediaInfo.length + 1,
                controller: _scrollController,
              );
            case MediaStatus.initial:
              //TODO: Create better interstitials
              return const Center(
                  child: CircularProgressIndicator(semanticsLabel: 'Circular progress indicator')
              );
          }
        }
    );
  }
}