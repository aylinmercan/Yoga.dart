import 'package:bitirme/components/register.dart';
import 'package:bitirme/login.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bitirme/components/yoga.dart';

class AuthService{
  var userCollection = FirebaseFirestore.instance.collection("users");
  var firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInGoogle(BuildContext context) async {
    try{
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if(googleUser != null){
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        if(userCredential.user != null){
          Navigator.push(context,
              MaterialPageRoute(builder: (context)=> RegisterScreen()));
        };
      } else {
        print('Giriş Hatalı');
      }
    } on FirebaseAuthException catch(e) {
      Fluttertoast.showToast(
          msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }

  }
  /* signInGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);


  }*/

/*  Future<UserCredential> signInGoogle() async {
    // kimlik doğrulama
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  */

  Future<void> signUp({required String username, required String email, required String telno, required String password, required String passwordconf }) async {

    if (password == passwordconf) {
      if (isValidPhoneNumber(telno)) {
        try {
          final UserCredential userCredential = await firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password);
          if (userCredential.user != null) {
            _registerUser(username: username,
                email: email,
                telno: telno,
                password: password,
                passwordconf: passwordconf);
            Fluttertoast.showToast(
                msg: "Kayıt Olundu", toastLength: Toast.LENGTH_LONG);
          }
        } on FirebaseAuthException catch (e) { //hata ayıklama eklentisi
          Fluttertoast.showToast(
              msg: e.message!, toastLength: Toast.LENGTH_LONG);
        }
      }
      else{
        Fluttertoast.showToast(msg: "Geçerli Bir Telefon Numarası Giriniz!", toastLength: Toast.LENGTH_LONG);
      }
    }
    else{
      Fluttertoast.showToast(msg: "Sifrenizi Kontrol Ediniz!", toastLength: Toast.LENGTH_LONG);
    }
  }
  bool isValidPhoneNumber(String phoneNumber) {
    // Telefon numarası sadece rakamlardan oluşmalı ve 11 haneli olmalı
    return RegExp(r'^[0-9]{11}$').hasMatch(phoneNumber);
  }

  Future<void> singIN(
      {required String email, required String password, required BuildContext context}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Fluttertoast.showToast(
            msg: "Giriş Başarılı", toastLength: Toast.LENGTH_LONG);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => YogaPage()));
      };
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }


  Future<void> _registerUser({required String username, required String email, required String telno, required String password, required String passwordconf }) async {
    await userCollection.doc().set({
      "username" : username,
      "email" : email,
      "telno" : telno,
      "password" : password,
      "passwordconf" : passwordconf

    });
  }

}