import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../blocs/media_bloc.dart';
import '../widgets/app_drawer.dart';
import '../widgets/media_info_list.dart';

class MyAppHomePage extends StatelessWidget {
  const MyAppHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('CastOrNot')),
      ),
      drawer: const MyAppDrawer(),
      body: BlocProvider(
        create: (_) => MediaBloc(mediaRepository: MediaRepository(httpClient: http.Client()))..add(MediaFetched()),
        child: const InfiniteScrollingList(),
      ),
    );
  }
}