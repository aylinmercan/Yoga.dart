import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // uygulama başlamasını bekle sonra başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void initState(){
    super.initState();
    const delayDuration = Duration(seconds: 4);
    Future.delayed(delayDuration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),  // Replace 'LoginScreen' with your actual class name
        ),
      );
    });


  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoga',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFf2e1d8, <int, Color>{
          50: Color(0xFFf2e1d8),
          100: Color(0xFFf2e1d8),
          200: Color(0xFFf2e1d8),
          300:Color(0xFFf2e1d8),
          400:Color(0xFFf2e1d8),
          500:Color(0xFFf2e1d8),
          600:Color(0xFFf2e1d8),
          700:Color(0xFFf2e1d8),
          800:Color(0xFFf2e1d8),
          900:Color(0xFFf2e1d8),
        }),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Yoga',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}