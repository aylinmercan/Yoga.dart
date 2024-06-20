import 'package:bitirme/components/squaretile.dart';
import 'package:bitirme/login.dart';
import 'package:bitirme/yoga_detect/pose_det.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitirme/components/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitirme/lang/tr.dart';
import 'package:bitirme/lang/en_US.dart';
import 'package:bitirme/lang/de_germany.dart';
import 'package:bitirme/components/yogapose.dart';
import 'package:bitirme/components/scale_route.dart';
import 'package:bitirme/yoga_detect/poses.dart';
import 'package:bitirme/yoga_detect/cameracontroller.dart';
import 'package:camera/camera.dart';

class YogaPage extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const YogaPage({
     required this.cameras,
  });

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDarkModeStatus();
      _loadSelectedLanguage();
      _loadUserEmail();
    });
  }

  Future<void> _loadUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email ?? '';
    });
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _loadDarkModeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkModeEnabled = value;
    });
    await prefs.setBool('darkMode', value);
  }

  void onPoseSelect(
      BuildContext context,
      String title,
      List<String> asanas,
      Color color,
      ) async {
    if (widget.cameras == null || widget.cameras!.isEmpty) {
      // Handle the case where no cameras are available
      // For example, show an error message or navigate back
      print('No camera is found in yoga.dart');
    }
    else{
      print('var');
    }
    Navigator.push(
      context,
      ScaleRoute(
        page: Poses(
          cameras: widget.cameras,
          title: title,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          asanas: asanas,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Yoga',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LoginScreen(cameras:cameras);
                  }),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(),
                child: Image(image: AssetImage('assets/lotus.png')),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/home.png',
                  width: 24,
                  height: 24,
                ),
                title: Text(_languageMap[_selectedLanguage]!['HomeLabel']!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YogaPage(cameras: widget.cameras)),
                  );
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/settings.png',
                  width: 24,
                  height: 24,
                ),
                title: Text(_languageMap[_selectedLanguage]!['SettingsLabel']!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(emailController: userEmail),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: Container(
                width: 150,
                height: 150,
                child: Image.asset(
                  'assets/yoga8.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                _languageMap[_selectedLanguage]!['StartYoga']!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onTap: () {
                onPoseSelect(
                  context,
                  'Yoga Pose Title', // Replace with actual title
                  beginnerAsanas, // Replace with actual asanas
                  Colors.blue, // Replace with actual color
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
