import 'package:bitirme/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/components/button.dart';

class forgotPasswordPage extends StatefulWidget {
  const forgotPasswordPage({super.key});

  @override
  State<forgotPasswordPage> createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<forgotPasswordPage> {
  final _emailController = TextEditingController();
  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }
  Future passwordReset() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Passwod reset link sent! Check your email'),
        );
      });
    } on FirebaseAuthException catch(e){
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2e1d8),
      appBar: AppBar(
        backgroundColor: Color(0xFFf2e1d8),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const SizedBox(height: 50),
         Image.asset('assets/lotus.png', width: 100, height: 100),
          SizedBox(height: 15),
          Text(
            "                   Enter Your Email \n                              and    \n "
                "we will send you a password reset link",
            style: TextStyle(
              color: Colors.black, // Gri renk
              fontSize: 20, // 16 font büyüklüğü
            ),
          ),
          SizedBox(height: 15),
          Padding(padding:
          const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Email',
                fillColor: Colors.grey[200],
                filled: true,

              ),
            ),
          ),
          SizedBox(height: 20),
          mybutton(onTap: passwordReset, text: 'Reset Password')
          ],
        ),
        ),
      )
    ),
    );

  }
}
