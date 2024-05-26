import 'package:dog_app/providers/feed/feed_state.dart';
import 'package:dog_app/repositories/feed_repository.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedProvider extends StateNotifier<FeedState>with LocatorMixin{
  FeedProvider() : super(FeedState.init());



  Future<void> uploadFeed({
    required List<String>files,
    required String desc,
    required String? breed,
    required String? age,
    required String? color,


    }) async{
   String uid = read<User>().uid;
await read<FeedRepository>().uploadFeed(
    files: files,
    desc: desc,
    uid: uid,
    breed: breed,
    age: age,
   color:color,


);

  }
}