import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class YogaPosePage extends StatefulWidget {
  @override
  _YogaPosePageState createState() => _YogaPosePageState();
}

class _YogaPosePageState extends State<YogaPosePage> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  late List<CameraDescription> _cameras;
  late List<dynamic> _recognitions;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    Tflite.close();
  }

  void _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      _isCameraInitialized = true;
    });
    _controller.startImageStream((CameraImage image) {
      if (_isCameraInitialized) {
        _recognizeMovement(image);
      }
    });
  }

  void _loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/tflite_modelyoga.tflite',
      labels: "assets/txtyoga.txt",
    );
    print("Model Load Result: $res");
  }

  void _recognizeMovement(CameraImage image) async {
    if (_isCameraInitialized) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      setState(() {
        _recognitions = recognitions!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yoga Pose Detection'),
      ),
      body: _isCameraInitialized
          ? Stack(
        children: [
          CameraPreview(_controller),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.7),
              child: Text(
                'Pose: ${_recognitions.isNotEmpty ? _recognitions[0]['label'] : 'No pose detected'}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: YogaPosePage(),
  ));
}
