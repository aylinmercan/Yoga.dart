import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitirme/components/changePassword.dart';
import 'package:bitirme/lang/tr.dart';
import 'package:bitirme/lang/en_US.dart';
import 'package:bitirme/lang/de_germany.dart';
import 'package:bitirme/login.dart';


class ChangeLanguagePage extends StatefulWidget {
  final Map<String, String> languageMap;
  const ChangeLanguagePage({Key? key, required this.languageMap}) : super(key: key);

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  late bool _isDarkModeEnabled = false;
  late String _selectedLanguage = 'English';
  Map<String, Map<String, String>> _languageMap = {
    'English': enUS,
    'Turkish': tur,
    'German': deGermany,

  };

  @override
  void initState() {
    super.initState();
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
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    _languageMap[_selectedLanguage]!['changeLanguageTitle']!
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
            )
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
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
            ],
          ),
        ),
      ),
    );
  }
}