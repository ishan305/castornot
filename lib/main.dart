import 'package:castonaut/models/media_info.dart';
import 'package:castonaut/widgets/media_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:castonaut/widgets/media_info_expanded.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'blocs/media_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
        primaryColor: Colors.white,

      ),
      home: const MyAppHomePage(),
    );
  }
}

class MyAppHomePage extends StatelessWidget {
  const MyAppHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CastOrNot'),
      ),
      body: BlocProvider(
        create: (_) => MediaBloc(mediaRepository: MediaRepository(httpClient: http.Client()))..add(MediaFetched()),
        child: const InfiniteScrollingList(),
      ),
    );
  }
}

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

  navigateToExpandedView(MediaInfo info, BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MediaInfoPage(widget.key, info)),
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
            return ListView.builder(
              itemBuilder: (context, index) {
                List<Widget> children = [];
                if(index < state.mediaInfo.length) {
                  children.add(
                    ElevatedButton(
                      onPressed: navigateToExpandedView(state.mediaInfo[index], context),
                      child: MediaInfoTile(info: state.mediaInfo[index])));
                }
                if(index+1 < state.mediaInfo.length) {
                  children.add(
                    ElevatedButton(
                      onPressed: navigateToExpandedView(state.mediaInfo[index+1], context),
                      child: MediaInfoTile(info: state.mediaInfo[index+1])));
                }
                return children.isNotEmpty ? Row(children: children,) : Container();
              },
              itemCount: state.hasReachedMax
                  ? state.mediaInfo.length
                  : state.mediaInfo.length + 1,
              controller: _scrollController,
            );
          case MediaStatus.initial:
            return const Center(child: Text('failed to fetch posts'));
        }
      }
    );
  }
}