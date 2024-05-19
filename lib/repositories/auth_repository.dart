import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_app/exceptions/custom_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const AuthRepository({
    required this.firebaseAuth,
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  Future<void>signOut() async {
await firebaseAuth.signOut();
  }
 Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(
          email: email,
          password: password
      );

      bool isVerified = userCredential.user!.emailVerified; //인증메일 여부확인
      if (!isVerified) {
        await userCredential.user!.sendEmailVerification();
        await firebaseAuth.signOut();
        throw CustomException(
          code: 'Exception',
          message: '인증되지 않은 이메일',
        );
      }
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }
  Future<void> signUp({
    required String email,
    required String name,
    required String password,
    required Uint8List? profileImage,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      String uid = userCredential.user!.uid;

      await userCredential.user!.sendEmailVerification();

      String? downloadURL = null;

      if (profileImage != null) {
        Reference ref = firebaseStorage.ref().child('profile').child(uid);
        TaskSnapshot snapshot = await ref.putData(profileImage);
        downloadURL = await snapshot.ref.getDownloadURL();
      }
      await firebaseFirestore.collection('users').doc(uid).set(
          {
            'uid': uid,
            'email': email,
            'name': name,
            'profileeImagee': downloadURL,
            'feedcount': 0,
            'likes': [],
            'followers': [],
            'following': [],

          }
      );

      firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } catch (e) {
      throw CustomException(code: 'Exception', message: e.toString(),);
    }
  }
}