import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bitirme/components/yoga.dart';
import 'package:camera/camera.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/register.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<CameraDescription>? cameras;

  AuthService({required this.cameras});

  Future<void> signInGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(cameras: cameras,)));
        }
      } else {
        print('Giriş Hatalı');
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String telno,
    required String password,
    required String passwordconf,
  }) async {
    if (password == passwordconf) {
      if (isValidPhoneNumber(telno)) {
        try {
          final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (userCredential.user != null) {
            _registerUser(
              username: username,
              email: email,
              telno: telno,
              password: password,
              passwordconf: passwordconf,
            );
            Fluttertoast.showToast(
              msg: "Kayıt Olundu",
              toastLength: Toast.LENGTH_LONG,
            );
          }
        } on FirebaseAuthException catch (e) {
          Fluttertoast.showToast(
            msg: e.message!,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Geçerli Bir Telefon Numarası Giriniz!",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Şifrenizi Kontrol Ediniz!",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^[0-9]{11}$').hasMatch(phoneNumber);
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      if (cameras == null || cameras!.isEmpty) {
        print('No cameras available in auth');
      }
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        Fluttertoast.showToast(
          msg: "Giriş Başarılı",
          toastLength: Toast.LENGTH_LONG,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => YogaPage(cameras: cameras!),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> _registerUser({
    required String username,
    required String email,
    required String telno,
    required String password,
    required String passwordconf,
  }) async {
    await FirebaseFirestore.instance.collection("users").doc().set({
      "username": username,
      "email": email,
      "telno": telno,
      "password": password,
      "passwordconf": passwordconf,
    });
  }
}
