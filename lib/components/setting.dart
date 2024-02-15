import 'package:bitirme/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitirme/components/yoga.dart';

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFf2e1d8),
          title: Text('Yoga',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),

          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip:'Logout',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LoginScreen();
                })
                );
              },
            ),
          ]
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                    color:Color(0xFFf2e1d8)
                ),
                child: Image(image: AssetImage('assets/lotus.png'))

            ),
            ListTile(
              leading: Image.asset('assets/home.png',
                width:24,
                height: 24,
              ),
              title: const Text('Home'),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder:(context) => YogaPage()),
                );
              },
            ),
            ListTile(
              leading: Image.asset('assets/settings.png',
                width: 24,
                height: 24,
              ),
              title: const Text('Settings'),
              onTap: (){},
            )
          ],
        ),
      ),

    );
  }
}

