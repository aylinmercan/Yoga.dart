import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:bitirme/yoga_detect/bndbox.dart';
import 'package:bitirme/yoga_detect/cameracontroller.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String title;
  final String model;
  final String customModel;

  const InferencePage({required this.cameras, required this.title, required this.model, required this.customModel});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  late List<dynamic> _recognitions = []; // Initialize as an empty list
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    if (widget.cameras == null || widget.cameras!.isEmpty) {
      print('No camera is found in inferance.dart');
      // Handle the case where no cameras are available
      // For example, show an error message or navigate back
      // Alternatively, you can disable the Camera widget in the UI
    } else {
      var res = loadModel();
      print('Model Response: ' + res.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
          ),
          BndBox(
            results:  _recognitions,
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
            customModel: widget.customModel,
          ),
        ],
      ),
    );
  }

  _setRecognitions(recognitions, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _recognitions = recognitions ?? []; // Ensure recognitions is not null
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  loadModel() async {
    return await Tflite.loadModel(
      model: widget.model,
    );
  }
}