import 'package:bitirme/components/button.dart';
import 'package:bitirme/components/squaretile.dart';
import 'package:bitirme/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/components/register.dart';
import "package:google_sign_in/google_sign_in.dart";
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:bitirme/services/aut_service.dart';
import 'package:bitirme/components/forgotPassword.dart';


class LoginScreen extends StatelessWidget {

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  // sign user in method
  void signUserIn() async{
    WidgetsFlutterBinding.ensureInitialized(); // uygulama başlamasını bekle sonra başlat
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  @override
  Widget build(BuildContext context){
   return Scaffold(
    backgroundColor: const Color(0xFFf2e1d8),
     body: SafeArea(
       child: SingleChildScrollView(
        child: Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         children: [
           const SizedBox(height: 50),
       //logo

           Image.asset('assets/lotus.png', width: 100, height: 100),

       // welcome back, you've been missed!
           Text(
             "Welcome back, you've been missed!",
             style: TextStyle(
               color: Colors.grey[700], // Gri renk
               fontSize: 16, // 16 font büyüklüğü
             ),
           ),
           const SizedBox(height:25),
       // username textfield

           textfield(

             controller: usernameController,
             hintText: 'Email' ,
             obscureText: false,

           ),
           const SizedBox(height: 25),
           // password textfield
           textfield(
             controller: passwordController,
             hintText: 'Password',
             obscureText: true,
           ),

           const SizedBox(height: 10),
         // forgot password?
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 25.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 GestureDetector(
                   onTap : () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) {
                       return forgotPasswordPage();
                     },
                     ),

                     );
                   },

             child: Text(
               'Forgot password?',
               style: TextStyle(color: Colors.grey[600]
               ),
             ),
                 ),
               ],
             ),
           ),
       const SizedBox(height: 25),
       
       // sign in button
           mybutton(

             onTap: () => AuthService().singIN(email: usernameController.text, password: passwordController.text, context: context),
             text: 'Sign In',

           ),
       const SizedBox(height: 50),
       // or continue with
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 25.0),
             child: Row(
               children: [
                 Expanded(
                   child: Divider(
                    thickness: 0.5 ,
                    color: Colors.grey[400],
             ),
                    ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                   child: Text('Or continue with',
                   style: TextStyle(color:Colors.grey[700]),
                   ),
                 ),

                 Expanded(
                   child: Divider(
                     thickness: 0.5 ,
                     color: Colors.grey[400],
                   ),
                 ),
               ],
             ),
           ),
           const SizedBox(height: 50),
           // google + apple sign in buttons
            Row(
             mainAxisAlignment: MainAxisAlignment.center ,

             children: [
               // google button
               SquareTile(imagePath: 'assets/google.png'),
                SizedBox(width: 25),

               // apple button
               SquareTile(imagePath: 'assets/apple.png'),
             ],


           ),
           const SizedBox(height: 50),

           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text('Not a member?', style: TextStyle(color: Colors.grey[700]),
               ),
               const SizedBox(width: 4),
               GestureDetector(
                 onTap: (){
                   Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => RegisterScreen()),
                   );
                 },
                 child: const Text(
                   'Register Now' ,
                   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                 ),
               )

                  ],
           )
         ],
        ),
       ),
       ),
     ),
   );
  }
}
