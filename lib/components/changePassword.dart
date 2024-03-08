import 'package:flutter/material.dart';
import 'package:bitirme/components/button.dart';
import 'package:bitirme/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitirme/components/forgotPassword.dart';
import 'package:bitirme/lang/tr.dart';
import 'package:bitirme/lang/en_US.dart';
import 'package:bitirme/lang/de_germany.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage = '';
  late bool _isDarkModeEnabled;
  late String _selectedLanguage;
  Map<String, Map<String, String>> _languageMap = {
    'English': enUS,
    'Turkish': tur,
    'German': deGermany,
  };

  @override
  void initState() {
    super.initState();
    _loadDarkModeStatus();
    _loadSelectedLanguage(); // _selectedLanguage'ı başlat
  }

  _loadDarkModeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = prefs.getBool('darkMode') ?? false;
    });
  }

  _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: _oldPasswordController.text);
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(_newPasswordController.text);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                    _languageMap[_selectedLanguage]!['successDialogTitle']!
                ),
                content: Text(_languageMap[_selectedLanguage]!['successDialogMessage']!),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(_languageMap[_selectedLanguage]!['OK']!),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        setState(() {
          _errorMessage = _languageMap[_selectedLanguage]!['CheckYourPassword']!;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // Geri dönüş işlevselliği
                },
              ),
              Text(
                _languageMap[_selectedLanguage]!['changePasswordTitle']!,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height : 20),
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(labelText: _languageMap[_selectedLanguage]!['oldPasswordLabel']!),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _languageMap[_selectedLanguage]!['PleaseEnterYourOldPassword']!;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: _languageMap[_selectedLanguage]!['newPasswordLabel']!),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _languageMap[_selectedLanguage]!['PleaseEnterYourNewPassword']!;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: _languageMap[_selectedLanguage]!['confirmPasswordLabel']!),
                  obscureText: true,
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return _languageMap[_selectedLanguage]!['passwordsDoNotMatchError']!;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return forgotPasswordPage();
                    }));
                  },
                  child: Text(
                    _languageMap[_selectedLanguage]!['forgotPasswordText']!,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                mybutton(
                  onTap: _changePassword,
                  text: _languageMap[_selectedLanguage]!['changePasswordTitle']!,
                ),
                if (_errorMessage != null && _errorMessage!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.red,
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}