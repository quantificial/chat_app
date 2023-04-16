import 'dart:io';

import 'package:firebase_app/widgets/auth_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitAuthForm(String email, String password, String username,
      File? image, bool isLogin) async {
    // print(email);
    // print(username);
    // print(password);
    // print(isLogin);
    User? user;

    if (!isLogin) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        user = userCredential.user;
        await user!.updateDisplayName(username);
        await user.reload();
        user = _auth.currentUser;

        // Upload Image ///////////////////////////////////////////////////////

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(user!.uid + ".jpg");

        await ref.putFile(image!).whenComplete(() => {});

        final url = await ref.getDownloadURL();

        print(url);

        var data = {
          'image_url': url,
          'username': username,
          'email': user.email,
          'test': 'abc',
        };
        print('-------');
        print(data);

        // Update Users Collection ////////////////////////////////////////////
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set(data);
      } catch (e) {
        print(e.toString());
      }
    } else {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        user = userCredential.user;
        print(user!.uid);
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'username': username, 'email': email});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitAuthForm: _submitAuthForm),
    );
  }
}
