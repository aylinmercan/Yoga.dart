import 'package:bitirme/lang/en_US.dart';
import 'package:bitirme/lang/tr.dart';
import 'package:bitirme/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitirme/components/yoga.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitirme/components/changePassword.dart';
import 'package:bitirme/components/changeLanguage.dart';

class SettingsPage extends StatefulWidget {
  static final String path = "lib/companents/setting.dart";
  final String emailController;

  SettingsPage({required this.emailController});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  bool _isDarkModeEnabled = false;
  @override
  void initState(){
    super.initState();
    _loadDarkModeStatus();
  }
  _loadDarkModeStatus() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = _prefs.getBool("darkMode") ?? false;
    });
  }
  _toggleDarkMode(bool value){
    setState(() {
      _isDarkModeEnabled = value;
      _prefs.setBool("darkMode", value);
    });
  }
  @override
  Widget build(BuildContext context){
    return Theme(
      data: _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(

            title: Text('Settings',
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
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  /*color: Color(0xFFffffff),*/
                    child: ListTile(
                      onTap: (){
                        //editprofil
                      },
                      title: Text(
                        "${widget.emailController}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      leading: Image.asset('assets/account.png',
                        width: 24,
                        height: 24,
                      ),
                      trailing: Icon(Icons.edit),
                    )
                ),
                const SizedBox(height: 0.2),
                Card(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 0.5),
                      ListTile(

                        title: Text("Change Password", style: TextStyle(fontWeight: FontWeight.w500),),
                        leading: Icon(Icons.lock_outline,color: Colors.black),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ChangePassword();
                          },),
                          );
                          //changePassword
                        },
                      ),
                      const SizedBox(height: 0.5),
                      ListTile(
                        title: Text("Change Language", style: TextStyle(fontWeight: FontWeight.w500),),
                        leading: Icon(Icons.language,color: Colors.black),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeLanguagePage(languageMap: enUS),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 0.5),
                      SwitchListTile(
                        title: Text("Dark Mode"),
                        value: _isDarkModeEnabled,
                        onChanged: (value){
                          _toggleDarkMode(value);
                          setState((){
                            _isDarkModeEnabled = value;
                          });
                        },
                      )


                    ],
                  ),
                ),

              ],
            )

        ),
      ),
    );
  }
}