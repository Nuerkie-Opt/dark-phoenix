import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
//log in with email and password
  Future logIn(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredentials.user;

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //alert(context, 'User not found');
        print(e);
      } else if (e.code == 'wrong-password') {
        //alert(context, 'Invalid credentials');
        print(e);
      }
      return null;
    }
  }
}
