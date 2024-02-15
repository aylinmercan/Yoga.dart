import 'package:bitirme/login.dart';
import 'package:bitirme/services/aut_service.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/components/textfield.dart';
import 'package:bitirme/components/squaretile.dart';
import 'package:bitirme/components/button.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';



class RegisterScreen extends StatelessWidget {
  // text editing controllers
  final regusername = TextEditingController();
  final passController = TextEditingController();
  final mailController = TextEditingController();
  final telController = TextEditingController();
  final passConfController = TextEditingController();

  @override
  void registerSc () async {
    WidgetsFlutterBinding.ensureInitialized(); // uygulama başlamasını bekle sonra başlat
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  Widget build(BuildContext context) {
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
                AppBar(
                  toolbarHeight: 38,
                  leading: IconButton(

                    icon: Image.asset('assets/back.png', alignment: Alignment.topLeft),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                      // Geri dönüş butonu tıklandığında yapılacak işlemler
                    },
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                ),
                Image.asset('assets/lotus.png', width: 100, height: 100),
                // welcome back, you've been missed!
                Text(
                  "Welcome !",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                textfield(
                  controller: regusername,
                  hintText: 'Username' ,
                  obscureText: false,

                ),
                const SizedBox(height: 16),
                textfield(
                  controller: mailController,
                  hintText: 'E-mail' ,
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                textfield(
                  controller: telController,
                  hintText: 'Tel-No' ,
                  obscureText: false,

                ),
                const SizedBox(height: 16),
                textfield(
                  controller: passController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                textfield(
                  controller: passConfController,
                  hintText: 'Password Confirm',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                // sign in button
                mybutton(

                  onTap: () => AuthService().signUp(username: regusername.text, email: mailController.text, telno: telController.text, password: passController.text, passwordconf: passConfController.text),
                  //onTap: registerSc,
                  text: 'Sign Up',

                ),
                // Add your other widgets here
              ],
            ),
          ),
        ),
      ),
    );
  }
}

