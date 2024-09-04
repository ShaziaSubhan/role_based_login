

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';  // For icons
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:role_based_login/home_page.dart';

class SignInScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  SignInScreen({super.key});


  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
          credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _saveUserToFirestore(
            user, role: 'user');
      }

      return user;
    } catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }
  }

  Future<void> _saveUserToFirestore(User user, {required String role}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final DocumentReference userDoc = firestore.collection('users').doc(
        user.uid);

    await userDoc.set({
      'uid': user.uid,
      'name': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'role': role, // 'user', 'worker', etc.
      'createdAt': FieldValue.serverTimestamp(),
    });
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Sign in to Your Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50.0),

                // Google Sign-In Button
                ElevatedButton.icon(
                  icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                  label: Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    // Text color
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide(color: Colors.grey), // Border color
                  ),
                  onPressed: () async {
                    final user = await _signInWithGoogle();
                    if (user != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    }
                  },
                ),

              ],
            ),
          ),
        ),
      );
    }
  }


