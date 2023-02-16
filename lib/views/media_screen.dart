import 'package:castonaut/blocs/media_bloc.dart';
import 'package:castonaut/models/media_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

import '../models/review.dart';
import '../widgets/media_review_list.dart';
import '../widgets/modal_expanded.dart';
import 'package:uuid/uuid.dart';

void onAddReviewPressed(BuildContext context, MediaInfo mediaInfo) {
  String review = '';
  int rating = -1;

  showSimpleModalDialog(context, [
    const Text('Add Review'),
    TextField(onChanged: (value) => review = value),
    ElevatedButton(
        onPressed: () {
          //TODO: validate the data
          User? user = FirebaseAuth.instance.currentUser;
          DatabaseReference dbRef = FirebaseDatabase.instance.ref('podcasts/{$mediaInfo.id}/reviews');
          MediaReview userReview = MediaReview(
              podcastId: mediaInfo.id,
              rating: rating,
              review: review,
              userId: user!.uid, id: const Uuid().toString(), name: user.email!, date: DateTime.now().toString());

          saveReviewToDB(dbRef, userReview);
          context.read<MediaReviewBloc>().add(MediaReviewFetched(mediaId: widget.mediaInfo.id));

          Navigator.of(context).pop();
        },
        child: const Text('Submit'))
  ]);
}

void saveReviewToDB(DatabaseReference dbRef, MediaReview userReview) {
  dbRef.push()
      .set(userReview.toJson())
      .then((value) => {print('Review added successfully')})
      .catchError((error) {print(error);});
}

class MediaInfoPage extends StatelessWidget {
  const MediaInfoPage(Key? key, this.info) : super(key: key);
  final MediaInfo info;

  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
        create: (_) => MediaReviewBloc(mediaRepository: MediaRepository(httpClient: http.Client()))
          ..add(MediaReviewFetched(mediaId: info.id)),
        child: Stack(children: [
          Positioned.fill(child:
            Image (
              image: NetworkImage(info.coverArtUrl),
              fit: BoxFit.fill,
            ),
          ),
          Scaffold (
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(info.title),
                centerTitle: true,
            ),
            body: MediaInfoReviewScrollVew(mediaInfo: info),
          ),
          FloatingActionButton.extended(
              onPressed: () {
                onAddReviewPressed(context, info);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Review')),
        ],
      ),
    );
  }
}

