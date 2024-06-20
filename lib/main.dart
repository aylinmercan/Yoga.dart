import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';
import 'login.dart'; // Import your login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize cameras
  List<CameraDescription>? cameras = [];
  try {
    cameras = await availableCameras();
  } catch (e) {
    print('Error initializing cameras: $e');
  }

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription>? cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(0xFFf2e1d8, <int, Color>{
            50: Color(0xFFf2e1d8),
            100: Color(0xFFf2e1d8),
            200: Color(0xFFf2e1d8),
            300: Color(0xFFf2e1d8),
            400: Color(0xFFf2e1d8),
            500: Color(0xFFf2e1d8),
            600: Color(0xFFf2e1d8),
            700: Color(0xFFf2e1d8),
            800: Color(0xFFf2e1d8),
            900: Color(0xFFf2e1d8),
          }),
        ),
        useMaterial3: true,
      ),
      home: MySplashScreen(cameras: cameras),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const MySplashScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    const delayDuration = Duration(seconds: 4);
    Future.delayed(delayDuration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(cameras: widget.cameras),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yoga',
          style: TextStyle(color: Color(0xFF735236)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallp.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(), // Placeholder for loading indicator
              SizedBox(height: 20),
              Text('Loading...'), // Placeholder for loading text
            ],
          ),
        ),
      ),
    );
  }
}
