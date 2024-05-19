import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_app/firebase_options.dart';
import 'package:dog_app/providers/auth_provider.dart' as myAuthProvider;
import 'package:dog_app/providers/auth_state.dart';
import 'package:dog_app/repositories/auth_repository.dart';
import 'package:dog_app/screens/signin_screen.dart';
import 'package:dog_app/screens/signup_screen.dart';
import 'package:dog_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   //FirebaseAuth.instance.signOut();
   return MultiProvider(
     providers: [
       Provider<AuthRepository>(
           create: (context) => AuthRepository(
               firebaseAuth: FirebaseAuth.instance,
               firebaseStorage: FirebaseStorage.instance,
               firebaseFirestore: FirebaseFirestore.instance,
           ),
       ),
       StreamProvider<User?>(
         create:(context)=>FirebaseAuth.instance.authStateChanges(),
         initialData: null,
       ),
       StateNotifierProvider<myAuthProvider.AuthProvider, AuthState>(
         create: (context) => myAuthProvider.AuthProvider(),
       ),

     ],
     child: MaterialApp(
       debugShowCheckedModeBanner: false,
       theme: ThemeData.dark(),
       home: SplashScreen(),
     ),
   );
  }
}



 
