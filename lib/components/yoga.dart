import 'package:bitirme/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitirme/components/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitirme/lang/tr.dart';
import 'package:bitirme/lang/en_US.dart';
import 'package:bitirme/lang/de_germany.dart';

class YogaPage extends StatefulWidget {
  @override
  _YogaPageState createState() => _YogaPageState();
}
class _YogaPageState extends State<YogaPage> {
  late String userEmail;
  bool _isDarkModeEnabled = false;
  late String _selectedLanguage;
  Map<String, Map<String, String>> _languageMap = {
    'English': enUS,
    'Türkçe': tur,
    'Detusch': deGermany,
  };
  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    _loadDarkModeStatus();
    _loadSelectedLanguage(); // _selectedLanguage'ı başlat
  }
  _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }
  _loadDarkModeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = prefs.getBool('darkMode') ?? false;
    });
  }
  @override
  _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = value;
    });
    await prefs.setBool('darkMode', value);
  }

  Widget build(BuildContext context){
    return MaterialApp(
    theme: _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
      appBar: AppBar(

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

              ),
              child: Image(image: AssetImage('assets/lotus.png'))

            ),
            ListTile(
              leading: Image.asset('assets/home.png',
                  width:24,
                    height: 24,
              ),
              title: Text(_languageMap[_selectedLanguage]!['HomeLabel']!),
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
              title:  Text(_languageMap[_selectedLanguage]!['SettingsLabel']!),
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(builder:(context) => SettingsPage(emailController: userEmail)),
                );
              },
            )
          ],
        ),
      ),
      ),
    );
  }
}

