import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_app/models/feed_model.dart';
import 'package:dog_app/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FeedRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFireStore;

  const FeedRepository({
    required this.firebaseStorage,
    required this.firebaseFireStore,
  });

  Future<void> uploadFeed({
    required List<String> files,
    required String desc,
    required String uid,
    required String? breed,
    required age,
    required String? color,
       // Add age parameter
  }) async {
    String feedId = Uuid().v1();

    // Firestore 문서 참조
    DocumentReference<Map<String, dynamic>> feedDocRef = firebaseFireStore
        .collection('feeds').doc(feedId);

    DocumentReference<Map<String, dynamic>> userDocRef = firebaseFireStore.collection('users').doc(uid);

    // Storage 참조
    Reference ref = firebaseStorage.ref().child('feeds').child(feedId);

    List<String> imageUrls = await Future.wait(files.map((e) async {
      String imageId = Uuid().v1();
      TaskSnapshot taskSnapshot = await ref.child(imageId).putFile(File(e));
      return await taskSnapshot.ref.getDownloadURL();
    }).toList());

     DocumentSnapshot<Map<String,dynamic>> userSanpshot = await userDocRef.get();
    UserModel userModel = UserModel.fromMap(userSanpshot.data()!);

    FeedModel feedModel =  FeedModel.fromMap({
       'uid': uid,
       'feedId': feedId,
       'desc': desc,
       'imageUrls': imageUrls,
       'likes': [],
       'likeCount': 0,
       'commentCount': 0,
       'createAt': Timestamp.now(),
       'writer': userDocRef,
       'breed': breed,
       'age' : age,
       'color': color,
     });



    await feedDocRef.set(feedModel.toMap(userDocRef: userDocRef));



    await userDocRef.update({
      'feedCount': FieldValue.increment(1),
    });
  }
}
