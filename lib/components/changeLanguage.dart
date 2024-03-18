import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitirme/components/changePassword.dart';
import 'package:bitirme/lang/tr.dart';
import 'package:bitirme/lang/en_US.dart';
import 'package:bitirme/lang/de_germany.dart';
import 'package:bitirme/login.dart';
import 'package:bitirme/components/setting.dart';


class ChangeLanguagePage extends StatefulWidget {
  final Map<String, String> languageMap;
  const ChangeLanguagePage({Key? key, required this.languageMap}) : super(key: key);

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  late String userEmail;
  late bool _isDarkModeEnabled = false;
  late String _selectedLanguage = 'English';
  Map<String, Map<String, String>> _languageMap = {
    'English': enUS,
    'Türkçe': tur,
    'Detusch': deGermany,

  };

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    _loadSelectedLanguage();
    _loadDarkModeStatus();
  }

  // Kullanıcının tercih ettiği karanlık mod durumunu yükler
  _loadDarkModeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = prefs.getBool('darkMode') ?? false;
    });
  }

  // Kullanıcının tercih ettiği dili kaydeder
  _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
    setState(() {
      _selectedLanguage = language;
    });
  }

  // Kaydedilmiş dili yükler
  _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }


  @override
  Widget build(BuildContext context) {

    return Theme(
      data: _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        body: WillPopScope( //telefonun geri tuşu özelliği
          onWillPop: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => SettingsPage(emailController: userEmail)),
            );
            return true;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Dikeyde en üstte başlasın
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (BuildContext context) => SettingsPage(emailController: userEmail)));
                      },
                    ),
                    Text(
                      _languageMap[_selectedLanguage]!['changeLanguageTitle']!,
                      style: TextStyle(
                        fontSize: 20, // Opsiyonel: Başlık boyutunu ayarlayabilirsiniz
                        fontWeight: FontWeight.bold, // Opsiyonel: Başlık kalınlığını ayarlayabilirsiniz
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      tooltip: 'Logout',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 220), // İsteğe bağlı: Araya boşluk ekleyebilirsiniz
              Center(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                      _saveSelectedLanguage(newValue);
                    });
                  },
                  items: _languageMap.keys.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}